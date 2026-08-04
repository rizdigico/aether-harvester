-- Quests data module
local Quests = {}

Quests.Database = {
    ["quest_first_harvest"] = {
        Id = "quest_first_harvest",
        Title = "First Harvest",
        Description = "Harvest 5 Aether Shards from resource nodes",
        Type = "Harvesting",
        Difficulty = "Easy",
        LevelRequired = 1,
        Objectives = {
            { Type = "Harvest", ItemId = "aether_shard", Amount = 5 },
        },
        Rewards = {
            XP = 100,
            Currency = { AetherShards = 50 },
            Items = { "basic_pickaxe" },
        },
    },
    ["quest_crystal_collector"] = {
        Id = "quest_crystal_collector",
        Title = "Crystal Collector",
        Description = "Collect 10 Aether Crystals",
        Type = "Collection",
        Difficulty = "Medium",
        LevelRequired = 10,
        Objectives = {
            { Type = "Collect", ItemId = "aether_crystal", Amount = 10 },
        },
        Rewards = {
            XP = 500,
            Currency = { AetherShards = 200 },
            Items = { "energy_potion" },
        },
    },
    ["quest_creature_tamer"] = {
        Id = "quest_creature_tamer",
        Title = "Creature Tamer",
        Description = "Tame 3 Aether Foxes",
        Type = "Taming",
        Difficulty = "Hard",
        LevelRequired = 15,
        Objectives = {
            { Type = "Tame", CreatureId = "aether_fox", Amount = 3 },
        },
        Rewards = {
            XP = 1000,
            Currency = { AetherShards = 500 },
            Items = { "pet_food" },
        },
    },
    ["quest_island_explorer"] = {
        Id = "quest_island_explorer",
        Title = "Island Explorer",
        Description = "Visit all 10 islands",
        Type = "Exploration",
        Difficulty = "Easy",
        LevelRequired = 5,
        Objectives = {
            { Type = "Visit", IslandId = "all", Amount = 10 },
        },
        Rewards = {
            XP = 300,
            Currency = { AetherShards = 150 },
        },
    },
    ["quest_master_harvester"] = {
        Id = "quest_master_harvester",
        Title = "Master Harvester",
        Description = "Harvest 1000 resource nodes",
        Type = "Harvesting",
        Difficulty = "Hard",
        LevelRequired = 20,
        Objectives = {
            { Type = "Harvest", Amount = 1000 },
        },
        Rewards = {
            XP = 2000,
            Currency = { AetherShards = 1000 },
            Items = { "harvest_boost", "lucky_charm" },
        },
    },
    ["quest_guild_leader"] = {
        Id = "quest_guild_leader",
        Title = "Guild Leader",
        Description = "Create a guild with 10 members",
        Type = "Social",
        Difficulty = "Medium",
        LevelRequired = 15,
        Objectives = {
            { Type = "Guild", Action = "Create", Amount = 1 },
        },
        Rewards = {
            XP = 1500,
            Currency = { AetherShards = 800 },
            Items = { "island_deed" },
        },
    },
    ["quest_pet_master"] = {
        Id = "quest_pet_master",
        Title = "Pet Master",
        Description = "Collect 10 different pets",
        Type = "Collection",
        Difficulty = "Medium",
        LevelRequired = 12,
        Objectives = {
            { Type = "Collect", ItemId = "pets", Amount = 10 },
        },
        Rewards = {
            XP = 800,
            Currency = { AetherShards = 400 },
            Items = { "pet_food", "lucky_charm" },
        },
    },
    ["quest_legendary_hunter"] = {
        Id = "quest_legendary_hunter",
        Title = "Legendary Hunter",
        Description = "Defeat 5 legendary creatures",
        Type = "Combat",
        Difficulty = "Very Hard",
        LevelRequired = 35,
        Objectives = {
            { Type = "Defeat", CreatureRarity = "Legendary", Amount = 5 },
        },
        Rewards = {
            XP = 5000,
            Currency = { AetherShards = 2500 },
            Items = { "portal_key", "ancient_relic" },
        },
    },
}

function Quests.GetAll()
    return Quests.Database
end

function Quests.Get(questId)
    return Quests.Database[questId]
end

function Quests.GetByDifficulty(difficulty)
    local results = {}
    for _, quest in pairs(Quests.Database) do
        if quest.Difficulty == difficulty then
            table.insert(results, quest)
        end
    end
    return results
end

return Quests
