--
-- Recipes.luau
-- Crafting recipes module for Aether Harvester Simulator
--

local Recipes = {}

--[[
    RECIPE STRUCTURE:
    {
        name = "RecipeName",
        displayName = "Display Name",
        description = "Description",
        result = {
            itemName = "ResultItem",
            quantity = 1
        },
        ingredients = {
            {
                itemName = "Ingredient1",
                quantity = 1
            },
            {
                itemName = "Ingredient2",
                quantity = 2
            }
        },
        levelRequirement = 1,
        craftingTime = 5,
        energyCost = 0,
        successChance = 1.0,
        failureEffects = {
            {
                itemName = "Ash",
                quantity = 1
            }
        }
    }
]]

-- Base recipes
Recipes.WoodenPickaxe = {
    name = "WoodenPickaxe",
    displayName = "Wooden Pickaxe",
    description = "A basic pickaxe for mining.",
    result = {
        itemName = "WoodenPickaxe",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "Wood",
            quantity = 5,
        },
        {
            itemName = "Stone",
            quantity = 3,
        },
    },
    levelRequirement = 1,
    craftingTime = 5,
    energyCost = 0,
    successChance = 1.0,
}

Recipes.StoneAxe = {
    name = "StoneAxe",
    displayName = "Stone Axe",
    description = "A basic axe for chopping.",
    result = {
        itemName = "StoneAxe",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "Stone",
            quantity = 8,
        },
        {
            itemName = "Wood",
            quantity = 3,
        },
    },
    levelRequirement = 2,
    craftingTime = 7,
    energyCost = 0,
    successChance = 1.0,
}

Recipes.CopperSword = {
    name = "CopperSword",
    displayName = "Copper Sword",
    description = "A basic sword for combat.",
    result = {
        itemName = "CopperSword",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "CopperOre",
            quantity = 5,
        },
        {
            itemName = "Wood",
            quantity = 3,
        },
    },
    levelRequirement = 3,
    craftingTime = 10,
    energyCost = 0,
    successChance = 1.0,
}

Recipes.IronPickaxe = {
    name = "IronPickaxe",
    displayName = "Iron Pickaxe",
    description = "A stronger pickaxe for mining.",
    result = {
        itemName = "IronPickaxe",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "IronOre",
            quantity = 8,
        },
        {
            itemName = "Wood",
            quantity = 5,
        },
    },
    levelRequirement = 4,
    craftingTime = 12,
    energyCost = 0,
    successChance = 1.0,
}

Recipes.HealthPotion = {
    name = "HealthPotion",
    displayName = "Health Potion",
    description = "Restores 25% of maximum health.",
    result = {
        itemName = "HealthPotion",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "AetherShard",
            quantity = 2,
        },
        {
            itemName = "Water",
            quantity = 1,
        },
    },
    levelRequirement = 2,
    craftingTime = 8,
    energyCost = 0,
    successChance = 0.95,
    failureEffects = {
        {
            itemName = "Ash",
            quantity = 1,
        },
    },
}

Recipes.ManaPotion = {
    name = "ManaPotion",
    displayName = "Mana Potion",
    description = "Restores 25% of maximum mana.",
    result = {
        itemName = "ManaPotion",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "AetherShard",
            quantity = 3,
        },
        {
            itemName = "Water",
            quantity = 1,
        },
    },
    levelRequirement = 3,
    craftingTime = 10,
    energyCost = 0,
    successChance = 0.95,
    failureEffects = {
        {
            itemName = "Ash",
            quantity = 1,
        },
    },
}

Recipes.Workbench = {
    name = "Workbench",
    displayName = "Workbench",
    description = "A crafting station for building and crafting.",
    result = {
        itemName = "Workbench",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "Wood",
            quantity = 15,
        },
        {
            itemName = "Stone",
            quantity = 10,
        },
    },
    levelRequirement = 3,
    craftingTime = 20,
    energyCost = 0,
    successChance = 1.0,
}

-- Additional recipes
Recipes.Furnace = {
    name = "Furnace",
    displayName = "Furnace",
    description = "A smelting station for turning ores into metals.",
    result = {
        itemName = "Furnace",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "Stone",
            quantity = 12,
        },
        {
            itemName = "IronOre",
            quantity = 5,
        },
    },
    levelRequirement = 5,
    craftingTime = 30,
    energyCost = 0,
    successChance = 1.0,
}

Recipes.ArmorSet = {
    name = "ArmorSet",
    displayName = "Basic Armor Set",
    description = "A set of basic armor for protection.",
    result = {
        itemName = "ArmorSet",
        quantity = 1,
    },
    ingredients = {
        {
            itemName = "Leather",
            quantity = 10,
        },
        {
            itemName = "IronOre",
            quantity = 5,
        },
    },
    levelRequirement = 4,
    craftingTime = 15,
    energyCost = 0,
    successChance = 1.0,
}

-- Function to get all recipes
function Recipes.GetAll()
    local allRecipes = {}
    for name, recipe in pairs(Recipes) do
        table.insert(allRecipes, { name = name, recipe = recipe })
    end
    return allRecipes
end

-- Function to get recipe by name
function Recipes.Get(name)
    return Recipes[name]
end

-- Function to check if player can craft recipe
function Recipes.CanCraft(player, recipeName)
    local playerLevel = player:GetAttribute("Level") or 1
    local recipe = Recipes[recipeName]
    if not recipe then
        return false, "Recipe not found."
    end
    if playerLevel < recipe.levelRequirement then
        return false, string.format("You need level %d to craft this.", recipe.levelRequirement)
    end
    return true
end

-- Function to get ingredients for recipe
function Recipes.GetIngredients(recipeName)
    local recipe = Recipes[recipeName]
    if not recipe then
        return nil, "Recipe not found."
    end
    return recipe.ingredients
end

return Recipes
