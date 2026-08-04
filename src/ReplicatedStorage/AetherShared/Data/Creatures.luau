--
-- Creatures.luau
-- Creature database module for Aether Harvester Simulator
--

local Creatures = {}

--[[
    CREATURE STRUCTURE:
    {
        name = "CreatureName",
        displayName = "Display Name",
        description = "Description",
        rarity = Enum.CreatureRarity,
        type = Enum.CreatureType,
        stats = {
            health = 100,
            maxHealth = 100,
            attack = 10,
            defense = 5,
            speed = 5,
            agility = 5,
            intelligence = 5,
            luck = 5
        },
        properties = {
            weight = 50,
            size = Enum.CreatureSize.Medium,
            tamable = true,
            breedable = true,
            aggressive = false,
            passive = true,
            tamedByDefault = false
        },
        abilities = {
            {
                name = "AbilityName",
                description = "Ability description",
                cooldown = 5,
                effect = function(creature, target)
                    -- Ability effect logic
                end
            }
        },
        breeding = {
            compatibleSpecies = {"Species1", "Species2"},
            offspring = {
                {
                    name = "Offspring1",
                    chance = 0.5
                }
            }
        },
        drops = {
            {
                itemName = "Item1",
                minQuantity = 1,
                maxQuantity = 3,
                chance = 0.7
            }
        },
        taming = {
            requiredItems = {
                {
                    itemName = "Item1",
                    quantity = 1
                }
            },
            successChance = 0.7
        },
        training = {
            stats = {
                health = {
                    base = 10,
                    growth = 0.5
                },
                attack = {
                    base = 5,
                    growth = 0.3
                }
            }
        }
    }
]]

-- Rarity enum
local CreatureRarity = Enum.create("CreatureRarity", {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Legendary = 5
})

-- Creature type enum
local CreatureType = Enum.create("CreatureType", {
    Mammal = 1,
    Bird = 2,
    Reptile = 3,
    Insect = 4,
    Mythical = 5
})

-- Creature size enum
local CreatureSize = Enum.create("CreatureSize", {
    Small = 1,
    Medium = 2,
    Large = 3
})

-- Base creatures
Creatures.Rabbit = {
    name = "Rabbit",
    displayName = "Rabbit",
    description = "A small, fast creature that can be tamed.",
    rarity = CreatureRarity.Common,
    type = CreatureType.Mammal,
    stats = {
        health = 30,
        maxHealth = 30,
        attack = 3,
        defense = 2,
        speed = 10,
        agility = 15,
        intelligence = 3,
        luck = 5
    },
    properties = {
        weight = 5,
        size = CreatureSize.Small,
        tamable = true,
        breedable = true,
        aggressive = false,
        passive = true,
        tamedByDefault = false
    },
    abilities = {
        {
            name = "Burrow",
            description = "Quickly digs into the ground to hide.",
            cooldown = 10,
            effect = function(creature, target)
                local humanoid = creature:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = humanoid.WalkSpeed * 2
                    game:GetService("Debris"):AddItem(humanoid, 3)
                end
            end
        }
    },
    breeding = {
        compatibleSpecies = {"Rabbit", "Fox"},
        offspring = {
            {
                name = "Rabbit",
                chance = 0.8
            },
            {
                name = "Fox",
                chance = 0.2
            }
        }
    },
    drops = {
        {
            itemName = "AetherShard",
            minQuantity = 1,
            maxQuantity = 2,
            chance = 0.3
        },
        {
            itemName = "Wood",
            minQuantity = 1,
            maxQuantity = 3,
            chance = 1.0
        }
    },
    taming = {
        requiredItems = {
            {
                itemName = "Wood",
                quantity = 1
            }
        },
        successChance = 0.7
    },
    training = {
        stats = {
            health = {
                base = 2,
                growth = 0.2
            },
            attack = {
                base = 1,
                growth = 0.1
            },
            speed = {
                base = 1,
                growth = 0.2
            }
        }
    }
}

Creatures.Fox = {
    name = "Fox",
    displayName = "Fox",
    description = "A cunning creature that can be tamed.",
    rarity = CreatureRarity.Uncommon,
    type = CreatureType.Mammal,
    stats = {
        health = 40,
        maxHealth = 40,
        attack = 5,
        defense = 3,
        speed = 12,
        agility = 18,
        intelligence = 8,
        luck = 10
    },
    properties = {
        weight = 8,
        size = CreatureSize.Small,
        tamable = true,
        breedable = true,
        aggressive = false,
        passive = true,
        tamedByDefault = false
    },
    abilities = {
        {
            name = "Stealth",
            description = "Increases stealth and evasion.",
            cooldown = 15,
            effect = function(creature, target)
                local humanoid = creature:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = humanoid.WalkSpeed * 1.2
                    humanoid.JumpPower = humanoid.JumpPower * 1.1
                    game:GetService("Debris"):AddItem(humanoid, 5)
                end
            end
        }
    },
    breeding = {
        compatibleSpecies = {"Fox", "Rabbit"},
        offspring = {
            {
                name = "Fox",
                chance = 0.7
            },
            {
                name = "Rabbit",
                chance = 0.3
            }
        }
    },
    drops = {
        {
            itemName = "AetherShard",
            minQuantity = 1,
            maxQuantity = 2,
            chance = 0.4
        },
        {
            itemName = "Stone",
            minQuantity = 1,
            maxQuantity = 2,
            chance = 0.8
        }
    },
    taming = {
        requiredItems = {
            {
                itemName = "Stone",
                quantity = 1
            }
        },
        successChance = 0.8
    },
    training = {
        stats = {
            health = {
                base = 3,
                growth = 0.3
            },
            attack = {
                base = 2,
                growth = 0.2
            },
            agility = {
                base = 2,
                growth = 0.3
            }
        }
    }
}

-- Additional creatures (12 total)
Creatures.Bird = {
    name = "Bird",
    displayName = "Bird",
    description = "A small bird that can be tamed.",
    rarity = CreatureRarity.Common,
    type = CreatureType.Bird,
    stats = {
        health = 20,
        maxHealth = 20,
        attack = 2,
        defense = 1,
        speed = 15,
        agility = 20,
        intelligence = 4,
        luck = 8
    },
    properties = {
        weight = 2,
        size = CreatureSize.Small,
        tamable = true,
        breedable = true,
        aggressive = false,
        passive = true,
        tamedByDefault = false
    },
    abilities = {
        {
            name = "Fly",
            description = "Allows the creature to fly.",
            cooldown = 0,
            effect = function(creature, target)
                local humanoid = creature:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 20
                    humanoid.PlatformStand = true
                end
            end
        }
    },
    drops = {
        {
            itemName = "Feather",
            minQuantity = 1,
            maxQuantity = 2,
            chance = 1.0
        }
    },
    taming = {
        requiredItems = {
            {
                itemName = "Wood",
                quantity = 1
            }
        },
        successChance = 0.6
    }
}

-- Function to get all creatures
function Creatures.GetAll()
    local allCreatures = {}
    for name, creature in pairs(Creatures) do
        table.insert(allCreatures, {name = name, creature = creature})
    end
    return allCreatures
end

-- Function to get creature by name
function Creatures.Get(name)
    return Creatures[name]
end

-- Function to get creatures by type
function Creatures.GetByType(type)
    local creatures = {}
    for name, creature in pairs(Creatures) do
        if creature.type == type then
            table.insert(creatures, {name = name, creature = creature})
        end
    end
    return creatures
end

-- Function to get creatures by rarity
function Creatures.GetByRarity(rarity)
    local creatures = {}
    for name, creature in pairs(Creatures) do
        if creature.rarity == rarity then
            table.insert(creatures, {name = name, creature = creature})
        end
    end
    return creatures
end

return Creatures