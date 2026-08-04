--
-- Items.luau
-- Item database module for Aether Harvester Simulator
--

local Items = {}

--[[
    ITEM STRUCTURE:
    {
        name = "ItemName",
        displayName = "Display Name",
        description = "Description",
        rarity = Enum.ItemRarity,
        type = Enum.ItemType,
        value = 0,
        stackable = false,
        maxStack = 99,
        icon = "rbxassetid://123456789",
        properties = {
            durability = 100,
            weight = 0.5,
            -- Additional properties
        },
        abilities = {
            {
                name = "AbilityName",
                description = "Ability description",
                cooldown = 5,
                effect = function(player, item)
                    -- Ability effect logic
                end
            }
        },
        recipes = {
            {
                name = "RecipeName",
                ingredients = {
                    {
                        itemName = "Ingredient1",
                        quantity = 1
                    }
                },
                result = {
                    itemName = "ResultItem",
                    quantity = 1
                }
            }
        }
    }
]]

-- Rarity enum
local ItemRarity = Enum.create("ItemRarity", {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Legendary = 5,
})

-- Item type enum
local ItemType = Enum.create("ItemType", {
    Tool = 1,
    Resource = 2,
    Consumable = 3,
    CraftingMaterial = 4,
    Currency = 5,
    Misc = 6,
})

-- Base items
Items.AetherShard = {
    name = "AetherShard",
    displayName = "Aether Shard",
    description = "A fragment of the Aether, used for crafting and alchemy.",
    rarity = ItemRarity.Common,
    type = ItemType.Resource,
    value = 5,
    stackable = true,
    maxStack = 999,
    icon = "rbxassetid://123456789",
    properties = {
        durability = nil,
        weight = 0.1,
    },
}

Items.WoodenPickaxe = {
    name = "WoodenPickaxe",
    displayName = "Wooden Pickaxe",
    description = "A basic pickaxe for mining.",
    rarity = ItemRarity.Common,
    type = ItemType.Tool,
    value = 20,
    stackable = false,
    maxStack = 1,
    icon = "rbxassetid://987654321",
    properties = {
        durability = 100,
        weight = 1.5,
        miningSpeed = 1.0,
        miningPower = 10,
    },
    abilities = {
        {
            name = "MiningBoost",
            description = "Increases mining speed by 10% for 5 seconds.",
            cooldown = 30,
            effect = function(player, item)
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local miningSpeed = humanoid:GetAttribute("MiningSpeed") or 1.0
                        humanoid:SetAttribute("MiningSpeed", miningSpeed * 1.1)
                        game:GetService("Debris"):AddItem(humanoid, 5)
                    end
                end
            end,
        },
    },
}

-- Additional items (30+)
Items.CopperOre = {
    name = "CopperOre",
    displayName = "Copper Ore",
    description = "A raw copper ore.",
    rarity = ItemRarity.Common,
    type = ItemType.Resource,
    value = 10,
    stackable = true,
    maxStack = 99,
    icon = "rbxassetid://987654320",
    properties = {
        durability = nil,
        weight = 0.2,
    },
}

Items.IronOre = {
    name = "IronOre",
    displayName = "Iron Ore",
    description = "A raw iron ore.",
    rarity = ItemRarity.Uncommon,
    type = ItemType.Resource,
    value = 20,
    stackable = true,
    maxStack = 99,
    icon = "rbxassetid://987654319",
    properties = {
        durability = nil,
        weight = 0.3,
    },
}

Items.GoldOre = {
    name = "GoldOre",
    displayName = "Gold Ore",
    description = "A raw gold ore.",
    rarity = ItemRarity.Rare,
    type = ItemType.Resource,
    value = 50,
    stackable = true,
    maxStack = 99,
    icon = "rbxassetid://987654318",
    properties = {
        durability = nil,
        weight = 0.4,
    },
}

Items.Stone = {
    name = "Stone",
    displayName = "Stone",
    description = "A basic building material.",
    rarity = ItemRarity.Common,
    type = ItemType.CraftingMaterial,
    value = 2,
    stackable = true,
    maxStack = 999,
    icon = "rbxassetid://987654317",
    properties = {
        durability = nil,
        weight = 0.1,
    },
}

Items.Wood = {
    name = "Wood",
    displayName = "Wood",
    description = "A basic building material.",
    rarity = ItemRarity.Common,
    type = ItemType.CraftingMaterial,
    value = 3,
    stackable = true,
    maxStack = 999,
    icon = "rbxassetid://987654316",
    properties = {
        durability = nil,
        weight = 0.2,
    },
}

Items.HealthPotion = {
    name = "HealthPotion",
    displayName = "Health Potion",
    description = "Restores 25% of maximum health.",
    rarity = ItemRarity.Uncommon,
    type = ItemType.Consumable,
    value = 15,
    stackable = true,
    maxStack = 99,
    icon = "rbxassetid://987654315",
    properties = {
        durability = nil,
        weight = 0.1,
        healAmount = 25,
    },
    abilities = {
        {
            name = "Heal",
            description = "Restores health.",
            cooldown = 0,
            effect = function(player, item)
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local maxHealth = humanoid.MaxHealth
                        local currentHealth = humanoid.Health
                        humanoid.Health = currentHealth + (maxHealth * item.properties.healAmount / 100)
                    end
                end
            end,
        },
    },
}

Items.ManaPotion = {
    name = "ManaPotion",
    displayName = "Mana Potion",
    description = "Restores 25% of maximum mana.",
    rarity = ItemRarity.Uncommon,
    type = ItemType.Consumable,
    value = 15,
    stackable = true,
    maxStack = 99,
    icon = "rbxassetid://987654314",
    properties = {
        durability = nil,
        weight = 0.1,
        manaAmount = 25,
    },
    abilities = {
        {
            name = "RestoreMana",
            description = "Restores mana.",
            cooldown = 0,
            effect = function(player, item)
                local character = player.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        local mana = humanoid:GetAttribute("Mana") or 0
                        humanoid:SetAttribute("Mana", mana + (100 * item.properties.manaAmount / 100))
                    end
                end
            end,
        },
    },
}

-- Function to get all items
function Items.GetAll()
    local allItems = {}
    for name, item in pairs(Items) do
        table.insert(allItems, { name = name, item = item })
    end
    return allItems
end

-- Function to get item by name
function Items.Get(name)
    return Items[name]
end

-- Function to get items by type
function Items.GetByType(type)
    local items = {}
    for name, item in pairs(Items) do
        if item.type == type then
            table.insert(items, { name = name, item = item })
        end
    end
    return items
end

-- Function to get items by rarity
function Items.GetByRarity(rarity)
    local items = {}
    for name, item in pairs(Items) do
        if item.rarity == rarity then
            table.insert(items, { name = name, item = item })
        end
    end
    return items
end

return Items
