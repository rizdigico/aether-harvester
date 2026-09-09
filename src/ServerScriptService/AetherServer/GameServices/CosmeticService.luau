local CosmeticService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)

CosmeticService.Cosmetics = {
    ["hat_phoenix"] = {
        Id = "hat_phoenix",
        Name = "Phoenix Crown",
        Type = "Hat",
        Rarity = "Legendary",
        Price = 5000,
        Effect = "A flaming crown that hovers above the player",
    },
    ["wings_angel"] = {
        Id = "wings_angel",
        Name = "Angel Wings",
        Type = "Wings",
        Rarity = "Epic",
        Price = 3000,
        Effect = "Radiant white wings",
    },
    ["aura_golden"] = {
        Id = "aura_golden",
        Name = "Golden Aura",
        Type = "Aura",
        Rarity = "Rare",
        Price = 1000,
        Effect = "A golden glow around the player",
    },
    ["trail_stars"] = {
        Id = "trail_stars",
        Name = "Star Trail",
        Type = "Trail",
        Rarity = "Epic",
        Price = 2000,
        Effect = "Leaves a trail of stars",
    },
    ["pet_follower_glow"] = {
        Id = "pet_follower_glow",
        Name = "Glowing Pet",
        Type = "PetEffect",
        Rarity = "Rare",
        Price = 1500,
        Effect = "Your pet glows with aether energy",
    },
}

function CosmeticService.Initialize()
    print("[CosmeticService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- PurchaseCosmetic
    local PurchaseCosmetic = Remotes:FindFirstChild("PurchaseCosmetic")
    if PurchaseCosmetic then
        PurchaseCosmetic.OnServerEvent:Connect(function(player, cosmeticId)
            if type(cosmeticId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "PurchaseCosmetic", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = CosmeticService.PurchaseCosmetic(player, cosmeticId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Purchase failed")
                end
            end
        end)
    end

    -- EquipCosmetic
    local EquipCosmetic = Remotes:FindFirstChild("EquipCosmetic")
    if EquipCosmetic then
        EquipCosmetic.OnServerEvent:Connect(function(player, cosmeticId)
            if type(cosmeticId) ~= "string" then
                return
            end
            if not RateLimiter.Check(player, "EquipCosmetic", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = CosmeticService.EquipCosmetic(player, cosmeticId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Equip failed")
                end
            end
        end)
    end

    -- GetCosmeticCatalog: return a public catalog plus this player's ownership.
    local GetCosmeticCatalog = Remotes:FindFirstChild("GetCosmeticCatalog")
    if GetCosmeticCatalog then
        GetCosmeticCatalog.OnServerInvoke = function(player)
            if not RateLimiter.Check(player, "GetCosmeticCatalog", 0.5) then
                return { Cosmetics = {}, Owned = {}, Equipped = nil }
            end
            return CosmeticService.GetCatalogForPlayer(player)
        end
    end

    print("[CosmeticService] Initialized")
end

function CosmeticService.GetCosmetic(cosmeticId)
    return CosmeticService.Cosmetics[cosmeticId]
end

function CosmeticService.GetAllCosmetics()
    return CosmeticService.Cosmetics
end

function CosmeticService.GetOwnedCosmetics(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return {}
    end
    return data.Cosmetics or {}
end

function CosmeticService.GetCatalogForPlayer(player)
    local data = PlayerDataService.GetData(player)
    local owned = {}
    if data and type(data.Cosmetics) == "table" then
        for _, cosmeticId in ipairs(data.Cosmetics) do
            if type(cosmeticId) == "string" then
                owned[cosmeticId] = true
            end
        end
    end

    local cosmetics = {}
    for _, cosmetic in pairs(CosmeticService.Cosmetics) do
        table.insert(cosmetics, {
            Id = cosmetic.Id,
            Name = cosmetic.Name,
            Type = cosmetic.Type,
            Rarity = cosmetic.Rarity,
            Price = cosmetic.Price,
            Effect = cosmetic.Effect,
        })
    end
    table.sort(cosmetics, function(a, b)
        if a.Price == b.Price then
            return a.Name < b.Name
        end
        return a.Price < b.Price
    end)

    return {
        Cosmetics = cosmetics,
        Owned = owned,
        Equipped = data and data.EquippedCosmetic or nil,
    }
end

function CosmeticService.PurchaseCosmetic(player, cosmeticId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local cosmetic = CosmeticService.Cosmetics[cosmeticId]
    if not cosmetic then
        return false, "Cosmetic not found"
    end

    if data.Cosmetics then
        for _, ownedId in ipairs(data.Cosmetics) do
            if ownedId == cosmeticId then
                return false, "Cosmetic already owned"
            end
        end
    end

    if
        not data.Currency
        or type(data.Currency.AetherShards) ~= "number"
        or data.Currency.AetherShards < cosmetic.Price
    then
        return false, "Not enough currency"
    end

    -- Deduct cost
    if not PlayerDataService.RemoveCurrency(player, "AetherShards", cosmetic.Price) then
        return false, "Not enough currency"
    end

    -- Add to owned cosmetics
    if not data.Cosmetics then
        data.Cosmetics = {}
    end
    table.insert(data.Cosmetics, cosmeticId)

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local CosmeticPurchased = Remotes:FindFirstChild("CosmeticPurchased")
        if CosmeticPurchased then
            CosmeticPurchased:FireClient(player, cosmeticId)
        end
    end

    print("[CosmeticService] " .. player.Name .. " purchased " .. cosmetic.Name)
    return true, "Purchased " .. cosmetic.Name
end

function CosmeticService.EquipCosmetic(player, cosmeticId)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false
    end

    if not CosmeticService.Cosmetics[cosmeticId] then
        return false, "Cosmetic not found"
    end

    -- Check if owned
    local owned = false
    if data.Cosmetics then
        for _, ownedId in ipairs(data.Cosmetics) do
            if ownedId == cosmeticId then
                owned = true
                break
            end
        end
    end

    if not owned then
        return false, "Cosmetic not owned"
    end

    -- Equip
    data.EquippedCosmetic = cosmeticId

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local CosmeticEquipped = Remotes:FindFirstChild("CosmeticEquipped")
        if CosmeticEquipped then
            CosmeticEquipped:FireClient(player, cosmeticId)
        end
    end

    return true, "Cosmetic equipped"
end

return CosmeticService
