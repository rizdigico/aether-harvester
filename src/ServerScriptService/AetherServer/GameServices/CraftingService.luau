local CraftingService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)

CraftingService.Recipes = {
    ["crystal_pickaxe"] = {
        Id = "crystal_pickaxe",
        Name = "Crystal Pickaxe",
        ResultItemId = "crystal_pickaxe",
        Ingredients = {
            { ItemId = "crystal_fragment", Amount = 10 },
            { ItemId = "aether_shard", Amount = 50 },
        },
        RequiredLevel = 10,
        CraftingTime = 5,
    },
    ["aether_pickaxe"] = {
        Id = "aether_pickaxe",
        Name = "Aether Pickaxe",
        ResultItemId = "aether_pickaxe",
        Ingredients = {
            { ItemId = "aether_crystal", Amount = 5 },
            { ItemId = "storm_essence", Amount = 3 },
            { ItemId = "void_shard", Amount = 1 },
        },
        RequiredLevel = 25,
        CraftingTime = 15,
    },
    ["pet_food"] = {
        Id = "pet_food",
        Name = "Pet Food",
        ResultItemId = "pet_food",
        Ingredients = {
            { ItemId = "ancient_wood", Amount = 5 },
            { ItemId = "aether_shard", Amount = 10 },
        },
        RequiredLevel = 5,
        CraftingTime = 3,
    },
    ["energy_potion"] = {
        Id = "energy_potion",
        Name = "Energy Potion",
        ResultItemId = "energy_potion",
        Ingredients = {
            { ItemId = "crystal_fragment", Amount = 3 },
            { ItemId = "aether_shard", Amount = 15 },
        },
        RequiredLevel = 3,
        CraftingTime = 2,
    },
    ["harvest_boost"] = {
        Id = "harvest_boost",
        Name = "Harvest Boost",
        ResultItemId = "harvest_boost",
        Ingredients = {
            { ItemId = "storm_essence", Amount = 2 },
            { ItemId = "aether_crystal", Amount = 1 },
        },
        RequiredLevel = 15,
        CraftingTime = 10,
    },
}

function CraftingService.Initialize()
    print("[CraftingService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- CraftItem: craft a recipe for the player
    local CraftItem = Remotes:FindFirstChild("CraftItem")
    if CraftItem then
        CraftItem.OnServerEvent:Connect(function(player, recipeId)
            if type(recipeId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "CraftItem", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = CraftingService.CraftItem(player, recipeId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Crafting failed")
                end
            end
        end)
    end

    -- RequestRecipes: refresh the player's available recipes
    local RequestRecipes = Remotes:FindFirstChild("RequestRecipes")
    if RequestRecipes then
        RequestRecipes.OnServerEvent:Connect(function(player)
            if not RateLimiter.Check(player, "RequestRecipes", 1) then
                return
            end
            local available = CraftingService.GetAvailableRecipes(player)
            local ItemCrafted = Remotes:FindFirstChild("ItemCrafted")
            if ItemCrafted then
                ItemCrafted:FireClient(player, "recipes", available)
            end
        end)
    end

    print("[CraftingService] Initialized")
end

function CraftingService.GetRecipe(recipeId)
    return CraftingService.Recipes[recipeId]
end

function CraftingService.GetAllRecipes()
    return CraftingService.Recipes
end

function CraftingService.GetAvailableRecipes(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return {}
    end

    local available = {}
    for _, recipe in pairs(CraftingService.Recipes) do
        if data.Level and data.Level >= recipe.RequiredLevel then
            table.insert(available, recipe)
        end
    end
    return available
end

function CraftingService.CanCraft(player, recipeId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local recipe = CraftingService.Recipes[recipeId]
    if not recipe then
        return false, "Recipe not found"
    end

    if data.Level and data.Level < recipe.RequiredLevel then
        return false, "Level too low"
    end

    -- Check ingredients
    for _, ingredient in ipairs(recipe.Ingredients) do
        local itemData = require(game.ReplicatedStorage.AetherShared.Data.Items).GetItem(ingredient.ItemId)
        if not itemData then
            return false, "Invalid ingredient: " .. ingredient.ItemId
        end

        local count = PlayerDataService.GetItemCount(player, ingredient.ItemId)

        if count < ingredient.Amount then
            return false, "Not enough " .. ingredient.ItemId
        end
    end

    return true, "Can craft"
end

function CraftingService.CraftItem(player, recipeId)
    local canCraft, reason = CraftingService.CanCraft(player, recipeId)
    if not canCraft then
        return false, reason
    end

    local data = PlayerDataService.GetData(player)
    local recipe = CraftingService.Recipes[recipeId]

    -- Remove ingredients transactionally. CanCraft performs the first
    -- ownership check; this second check handles a mutation between checks or
    -- a recipe containing repeated ingredients without minting a free result.
    local removedIngredients = {}
    for _, ingredient in ipairs(recipe.Ingredients) do
        if not PlayerDataService.RemoveItem(player, ingredient.ItemId, ingredient.Amount) then
            for itemId, amount in pairs(removedIngredients) do
                PlayerDataService.AddItem(player, itemId, amount)
            end
            return false, "Could not remove crafting ingredients"
        end
        removedIngredients[ingredient.ItemId] = (removedIngredients[ingredient.ItemId] or 0) + ingredient.Amount
    end

    -- Add result item
    if not PlayerDataService.AddItem(player, recipe.ResultItemId, 1) then
        for itemId, amount in pairs(removedIngredients) do
            PlayerDataService.AddItem(player, itemId, amount)
        end
        return false, "Could not add crafted item"
    end

    -- Award XP
    local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
    ProgressionService.AddXP(player, 50)

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local ItemCrafted = Remotes:FindFirstChild("ItemCrafted")
        if ItemCrafted then
            ItemCrafted:FireClient(player, recipe.ResultItemId, 1)
        end
    end

    print("[CraftingService] " .. player.Name .. " crafted " .. recipe.Name)
    return true, "Crafted " .. recipe.Name
end

return CraftingService
