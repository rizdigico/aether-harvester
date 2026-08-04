--
-- Quests.luau
-- Quest definitions module for Aether Harvester Simulator
--

local Quests = {}

--[[
    QUEST STRUCTURE:
    {
        name = "QuestName",
        displayName = "Display Name",
        description = "Description",
        type = Enum.QuestType,
        category = Enum.QuestCategory,
        difficulty = Enum.QuestDifficulty,
        objectives = {
            {
                type = Enum.ObjectiveType,
                description = "Objective description",
                target = {
                    itemName = "ItemName",
                    quantity = 10,
                    creatureName = "CreatureName",
                    -- Other target properties
                },
                completed = false,
                progress = 0
            }
        },
        rewards = {
            {
                type = Enum.RewardType,
                value = 100,
                itemName = "ItemName",
                quantity = 5,
                currency = "Gold",
                xp = 1000
            }
        },
        requirements = {
            {
                type = Enum.RequirementType,
                value = 5,
                itemName = "ItemName",
                level = 3
            }
        },
        completionText = "Quest completed! You have earned rewards.",
        failureText = "Quest failed. Try again later."
    }
]]

-- Quest type enum
local QuestType = Enum.create("QuestType", {
    Main = 1,
    Side = 2,
    Daily = 3,
    Weekly = 4,
    Event = 5,
})

-- Quest category enum
local QuestCategory = Enum.create("QuestCategory", {
    Exploration = 1,
    Combat = 2,
    Crafting = 3,
    Collection = 4,
    Social = 5,
    Survival = 6,
})

-- Quest difficulty enum
local QuestDifficulty = Enum.create("QuestDifficulty", {
    Easy = 1,
    Medium = 2,
    Hard = 3,
    Expert = 4,
})

-- Objective type enum
local ObjectiveType = Enum.create("ObjectiveType", {
    CollectItems = 1,
    KillCreatures = 2,
    ReachLocation = 3,
    CompleteSubquest = 4,
    CraftItem = 5,
})

-- Reward type enum
local RewardType = Enum.create("RewardType", {
    Currency = 1,
    XP = 2,
    Item = 3,
    Creature = 4,
    SkillPoint = 5,
})

-- Requirement type enum
local RequirementType = Enum.create("RequirementType", {
    Item = 1,
    Level = 2,
    Skill = 3,
    Currency = 4,
})

-- Base quests
Quests.StartingAdventure = {
    name = "StartingAdventure",
    displayName = "Starting Adventure",
    description = "Your first quest! Find your way around the island and gather resources.",
    type = QuestType.Main,
    category = QuestCategory.Exploration,
    difficulty = QuestDifficulty.Easy,
    objectives = {
        {
            type = ObjectiveType.CollectItems,
            description = "Collect 10 Wood.",
            target = {
                itemName = "Wood",
                quantity = 10,
            },
            completed = false,
            progress = 0,
        },
        {
            type = ObjectiveType.CollectItems,
            description = "Collect 5 Stone.",
            target = {
                itemName = "Stone",
                quantity = 5,
            },
            completed = false,
            progress = 0,
        },
    },
    rewards = {
        {
            type = RewardType.Currency,
            value = 50,
            currency = "Gold",
        },
        {
            type = RewardType.XP,
            value = 500,
        },
        {
            type = RewardType.Item,
            itemName = "HealthPotion",
            quantity = 1,
        },
    },
    requirements = {
        {
            type = RequirementType.Level,
            value = 1,
        },
    },
    completionText = "You have successfully started your adventure! You have earned rewards.",
    failureText = "You need to gather more resources to complete this quest.",
}

Quests.TheMysteriousForest = {
    name = "TheMysteriousForest",
    displayName = "The Mysterious Forest",
    description = "Explore the forest and find rare resources.",
    type = QuestType.Side,
    category = QuestCategory.Exploration,
    difficulty = QuestDifficulty.Medium,
    objectives = {
        {
            type = ObjectiveType.CollectItems,
            description = "Collect 15 CopperOre.",
            target = {
                itemName = "CopperOre",
                quantity = 15,
            },
            completed = false,
            progress = 0,
        },
        {
            type = ObjectiveType.CollectItems,
            description = "Collect 5 IronOre.",
            target = {
                itemName = "IronOre",
                quantity = 5,
            },
            completed = false,
            progress = 0,
        },
    },
    rewards = {
        {
            type = RewardType.Currency,
            value = 100,
            currency = "Gold",
        },
        {
            type = RewardType.XP,
            value = 1000,
        },
        {
            type = RewardType.Item,
            itemName = "ManaPotion",
            quantity = 1,
        },
    },
    requirements = {
        {
            type = RequirementType.Item,
            itemName = "WoodenPickaxe",
            quantity = 1,
        },
    },
    completionText = "You have explored the mysterious forest and earned rewards.",
    failureText = "You need to gather more resources to complete this quest.",
}

Quests.TamingTheWild = {
    name = "TamingTheWild",
    displayName = "Taming The Wild",
    description = "Tame a creature and make it your companion.",
    type = QuestType.Main,
    category = QuestCategory.Social,
    difficulty = QuestDifficulty.Medium,
    objectives = {
        {
            type = ObjectiveType.KillCreatures,
            description = "Tame a Rabbit.",
            target = {
                creatureName = "Rabbit",
                quantity = 1,
            },
            completed = false,
            progress = 0,
        },
    },
    rewards = {
        {
            type = RewardType.Currency,
            value = 150,
            currency = "Gold",
        },
        {
            type = RewardType.XP,
            value = 1200,
        },
        {
            type = RewardType.Item,
            itemName = "HealthPotion",
            quantity = 2,
        },
    },
    requirements = {
        {
            type = RequirementType.Level,
            value = 3,
        },
    },
    completionText = "You have tamed a creature and earned rewards.",
    failureText = "You need to tame a creature to complete this quest.",
}

-- Additional quests (20 total)
Quests.TheAncientRuins = {
    name = "TheAncientRuins",
    displayName = "The Ancient Ruins",
    description = "Explore the ancient ruins and find hidden treasures.",
    type = QuestType.Side,
    category = QuestCategory.Exploration,
    difficulty = QuestDifficulty.Hard,
    objectives = {
        {
            type = ObjectiveType.CollectItems,
            description = "Collect 20 GoldOre.",
            target = {
                itemName = "GoldOre",
                quantity = 20,
            },
            completed = false,
            progress = 0,
        },
        {
            type = ObjectiveType.CollectItems,
            description = "Find the Ancient Key.",
            target = {
                itemName = "AncientKey",
                quantity = 1,
            },
            completed = false,
            progress = 0,
        },
    },
    rewards = {
        {
            type = RewardType.Currency,
            value = 250,
            currency = "Gold",
        },
        {
            type = RewardType.XP,
            value = 2000,
        },
        {
            type = RewardType.Item,
            itemName = "LegendarySword",
            quantity = 1,
        },
    },
    requirements = {
        {
            type = RequirementType.Item,
            itemName = "IronOre",
            quantity = 10,
        },
    },
    completionText = "You have explored the ancient ruins and found treasures.",
    failureText = "You need to gather more resources to complete this quest.",
}

-- Function to get all quests
function Quests.GetAll()
    local allQuests = {}
    for name, quest in pairs(Quests) do
        table.insert(allQuests, { name = name, quest = quest })
    end
    return allQuests
end

-- Function to get quest by name
function Quests.Get(name)
    return Quests[name]
end

-- Function to get quests by type
function Quests.GetByType(type)
    local quests = {}
    for name, quest in pairs(Quests) do
        if quest.type == type then
            table.insert(quests, { name = name, quest = quest })
        end
    end
    return quests
end

-- Function to get quests by category
function Quests.GetByCategory(category)
    local quests = {}
    for name, quest in pairs(Quests) do
        if quest.category == category then
            table.insert(quests, { name = name, quest = quest })
        end
    end
    return quests
end

-- Function to get quests by difficulty
function Quests.GetByDifficulty(difficulty)
    local quests = {}
    for name, quest in pairs(Quests) do
        if quest.difficulty == difficulty then
            table.insert(quests, { name = name, quest = quest })
        end
    end
    return quests
end

return Quests
