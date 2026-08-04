-- Recipes data module
-- Single source of truth for crafting recipes, mirroring CraftingService.Recipes
local Recipes = {}

Recipes.Database = {
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
    ["health_elixir"] = {
        Id = "health_elixir",
        Name = "Health Elixir",
        ResultItemId = "health_elixir",
        Ingredients = {
            { ItemId = "prism_coral", Amount = 2 },
            { ItemId = "aether_shard", Amount = 10 },
        },
        RequiredLevel = 2,
        CraftingTime = 2,
    },
    ["speed_potion"] = {
        Id = "speed_potion",
        Name = "Speed Potion",
        ResultItemId = "speed_potion",
        Ingredients = {
            { ItemId = "star_fragment", Amount = 1 },
            { ItemId = "aether_shard", Amount = 20 },
        },
        RequiredLevel = 6,
        CraftingTime = 4,
    },
    ["steel_pickaxe"] = {
        Id = "steel_pickaxe",
        Name = "Steel Pickaxe",
        ResultItemId = "steel_pickaxe",
        Ingredients = {
            { ItemId = "crystal_shard", Amount = 8 },
            { ItemId = "volcanic_ore", Amount = 5 },
            { ItemId = "aether_shard", Amount = 30 },
        },
        RequiredLevel = 10,
        CraftingTime = 8,
    },
    ["quantum_harvester"] = {
        Id = "quantum_harvester",
        Name = "Quantum Harvester",
        ResultItemId = "quantum_harvester",
        Ingredients = {
            { ItemId = "aether_core", Amount = 2 },
            { ItemId = "void_pearl", Amount = 3 },
            { ItemId = "crystal_shard", Amount = 20 },
        },
        RequiredLevel = 25,
        CraftingTime = 20,
    },
    ["aether_rod"] = {
        Id = "aether_rod",
        Name = "Aether Rod",
        ResultItemId = "aether_rod",
        Ingredients = {
            { ItemId = "deep_pearl", Amount = 3 },
            { ItemId = "aether_crystal", Amount = 4 },
            { ItemId = "sky_essence", Amount = 2 },
        },
        RequiredLevel = 18,
        CraftingTime = 12,
    },
}

function Recipes.GetAll()
    return Recipes.Database
end

function Recipes.Get(recipeId)
    return Recipes.Database[recipeId]
end

function Recipes.GetAvailable(playerLevel)
    local available = {}
    playerLevel = playerLevel or 1
    for _, recipe in pairs(Recipes.Database) do
        if playerLevel >= recipe.RequiredLevel then
            table.insert(available, recipe)
        end
    end
    return available
end

return Recipes
