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
    ["quest_storm_peaks_visit"] = {
        Id = "quest_storm_peaks_visit",
        Title = "Storm Caller",
        Description = "Visit the Storm Peaks for the first time",
        Type = "Exploration",
        Difficulty = "Easy",
        LevelRequired = 2,
        Objectives = {
            { Type = "Visit", IslandId = "storm_peaks", Amount = 1 },
        },
        Rewards = {
            XP = 120,
            Currency = { AetherShards = 60 },
            Items = { "storm_shield" },
        },
    },
    ["quest_crystal_harvest"] = {
        Id = "quest_crystal_harvest",
        Title = "Crystal Harvest",
        Description = "Harvest 8 Crystal Fragments from crystal formations",
        Type = "Harvesting",
        Difficulty = "Easy",
        LevelRequired = 3,
        Objectives = {
            { Type = "Harvest", ItemId = "crystal_fragment", Amount = 8 },
        },
        Rewards = {
            XP = 150,
            Currency = { AetherShards = 80 },
            Items = { "crystal_orb" },
        },
    },
    ["quest_woodcutter"] = {
        Id = "quest_woodcutter",
        Title = "First Woodcutter",
        Description = "Chop 10 Ancient Wood with a Stone Axe",
        Type = "Harvesting",
        Difficulty = "Easy",
        LevelRequired = 1,
        Objectives = {
            { Type = "Harvest", ItemId = "ancient_wood", Amount = 10 },
        },
        Rewards = {
            XP = 100,
            Currency = { AetherShards = 50 },
            Items = { "stone_axe" },
        },
    },
    ["quest_tame_cloud_sprite"] = {
        Id = "quest_tame_cloud_sprite",
        Title = "Tame a Cloud Sprite",
        Description = "Tame a Cloud Sprite in the Cloud Gardens",
        Type = "Taming",
        Difficulty = "Easy",
        LevelRequired = 4,
        Objectives = {
            { Type = "Tame", CreatureId = "cloud_sprite", Amount = 1 },
        },
        Rewards = {
            XP = 200,
            Currency = { AetherShards = 100 },
            Items = { "pet_food" },
        },
    },
    ["quest_craft_energy_potion"] = {
        Id = "quest_craft_energy_potion",
        Title = "Aspiring Alchemist",
        Description = "Craft 3 Energy Potions at a crafting station",
        Type = "Crafting",
        Difficulty = "Easy",
        LevelRequired = 3,
        Objectives = {
            { Type = "Craft", ItemId = "energy_potion", Amount = 3 },
        },
        Rewards = {
            XP = 180,
            Currency = { AetherShards = 90 },
            Items = { "health_elixir" },
        },
    },
    ["quest_daily_harvest"] = {
        Id = "quest_daily_harvest",
        Title = "Daily Harvest",
        Description = "Harvest 25 Aether Shards today",
        Type = "Harvesting",
        Difficulty = "Easy",
        LevelRequired = 1,
        Objectives = {
            { Type = "Harvest", ItemId = "aether_shard", Amount = 25 },
        },
        Rewards = {
            XP = 250,
            Currency = { AetherShards = 120 },
            Items = { "xp_boost" },
        },
    },
    ["quest_void_wanderer"] = {
        Id = "quest_void_wanderer",
        Title = "Void Wanderer",
        Description = "Visit the Void Rifts and collect 3 Void Essence",
        Type = "Exploration",
        Difficulty = "Medium",
        LevelRequired = 8,
        Objectives = {
            { Type = "Visit", IslandId = "void_rifts", Amount = 1 },
            { Type = "Collect", ItemId = "void_essence", Amount = 3 },
        },
        Rewards = {
            XP = 400,
            Currency = { AetherShards = 200 },
            Items = { "void_pearl" },
        },
    },
    ["quest_storm_drake_tamer"] = {
        Id = "quest_storm_drake_tamer",
        Title = "Storm Tamer",
        Description = "Tame a Storm Hawk in the Storm Peaks",
        Type = "Taming",
        Difficulty = "Medium",
        LevelRequired = 12,
        Objectives = {
            { Type = "Tame", CreatureId = "storm_hawk", Amount = 1 },
        },
        Rewards = {
            XP = 600,
            Currency = { AetherShards = 300 },
            Items = { "storm_shield", "pet_food" },
        },
    },
    ["quest_craft_steel_pickaxe"] = {
        Id = "quest_craft_steel_pickaxe",
        Title = "Master Smith",
        Description = "Craft a Steel Pickaxe",
        Type = "Crafting",
        Difficulty = "Medium",
        LevelRequired = 10,
        Objectives = {
            { Type = "Craft", ItemId = "steel_pickaxe", Amount = 1 },
        },
        Rewards = {
            XP = 500,
            Currency = { AetherShards = 250 },
            Items = { "xp_boost" },
        },
    },
    ["quest_mythril_dust_collector"] = {
        Id = "quest_mythril_dust_collector",
        Title = "Mythril Dust Collector",
        Description = "Collect 3 Mythril Dust from rare nodes",
        Type = "Collection",
        Difficulty = "Rare",
        LevelRequired = 20,
        Objectives = {
            { Type = "Collect", ItemId = "mythril_dust", Amount = 3 },
        },
        Rewards = {
            XP = 1000,
            Currency = { AetherShards = 500 },
            Items = { "aether_core" },
        },
    },
    ["quest_abyssal_hunter"] = {
        Id = "quest_abyssal_hunter",
        Title = "Abyssal Hunter",
        Description = "Defeat 3 abyssal creatures and collect their cores",
        Type = "Combat",
        Difficulty = "Hard",
        LevelRequired = 25,
        Objectives = {
            { Type = "Defeat", CreatureRarity = "Legendary", Amount = 3 },
            { Type = "Collect", ItemId = "abyssal_core", Amount = 1 },
        },
        Rewards = {
            XP = 2000,
            Currency = { AetherShards = 1000 },
            Items = { "quantum_harvester" },
        },
    },
    ["quest_sky_base_architect"] = {
        Id = "quest_sky_base_architect",
        Title = "Sky Base Architect",
        Description = "Deliver 50 Crystal Shards to the Architect",
        Type = "Deliver",
        Difficulty = "Epic",
        LevelRequired = 30,
        Objectives = {
            { Type = "Deliver", ItemId = "crystal_shard", Amount = 50 },
        },
        Rewards = {
            XP = 3000,
            Currency = { AetherShards = 1500 },
            Items = { "aether_fountain" },
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
