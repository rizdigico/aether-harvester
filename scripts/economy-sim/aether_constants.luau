-- aether_constants.luau
-- Real economy constants recovered from the Aether Harvester source build.
-- Pure Lua table (no Roblox engine). Every number is copied verbatim from the
-- recovered game files; each block cites the source file:line. This is the single
-- source of truth for the economy sims (E6.1, E7.3).

local Constants = {}

-- ============================================================
-- XP CURVE
--   src/ReplicatedStorage/AetherShared/Modules/Utils.luau:19-21
--   function Utils.CalculateXPRequired(level)
--       return math.floor(100 * math.pow(1.5, level - 1))
--   end
-- ============================================================
Constants.XP_BASE = 100 -- Utils.luau:20
Constants.XP_MULTIPLIER = 1.5 -- Utils.luau:20
-- floor(100 * 1.5^(level-1))  -- exact mirror of the game formula
function Constants.CalculateXPRequired(level)
    return math.floor(100 * math.pow(1.5, level - 1))
end

-- ============================================================
-- NODE TYPES (base yields, respawn, xp)
--   src/ServerScriptService/AetherServer/GameServices/NodeManager.luau:21-28
--   NodeManager.NodeTypes = { prefix -> {ResourceId, MinYield, MaxYield,
--                                         RespawnTime, XP} }
--   NOTE: HerbNode uses ResourceId "ancient_wood" and Tree uses the same id
--   (NodeManager.luau:25-26), matching the recovered file verbatim.
-- ============================================================
Constants.NodeTypes = {
    AetherNode = { ResourceId = "aether_shard", MinYield = 1, MaxYield = 3, RespawnTime = 30, XP = 10 }, -- NodeManager.luau:22
    CrystalNode = { ResourceId = "crystal_fragment", MinYield = 1, MaxYield = 2, RespawnTime = 45, XP = 15 }, -- :23
    OreNode = { ResourceId = "volcanic_ore", MinYield = 1, MaxYield = 2, RespawnTime = 60, XP = 25 }, -- :24
    HerbNode = { ResourceId = "ancient_wood", MinYield = 1, MaxYield = 3, RespawnTime = 40, XP = 12 }, -- :25
    Tree = { ResourceId = "ancient_wood", MinYield = 1, MaxYield = 3, RespawnTime = 50, XP = 10 }, -- :26
    Rock = { ResourceId = "aether_shard", MinYield = 1, MaxYield = 2, RespawnTime = 35, XP = 8 }, -- :27
}

-- Harvest boost item (consumable) multiplier when owned
--   NodeManager.luau:94-96  (if harvest_boost count > 0 -> boost = 1.5)
Constants.HARVEST_BOOST_MULTIPLIER = 1.5 -- NodeManager.luau:95
Constants.HARVEST_BOOST_ITEM_ID = "harvest_boost" -- NodeManager.luau:94

-- ============================================================
-- UPGRADES (cost curve)
--   src/ServerScriptService/AetherServer/GameServices/UpgradeService.luau:4-55
--   UpgradeService.Database = { id -> {BaseCost, CostMultiplier, MaxLevel, Effect} }
--   CalculateCost (line 144): floor(baseCost * multiplier^currentLevel)
-- ============================================================
Constants.Upgrades = {
    pickaxe_power_1 = {
        Name = "Pickaxe Power I",
        BaseCost = 100,
        CostMultiplier = 1.5,
        MaxLevel = 10,
        EffectPower = 0.2,
    }, -- UpgradeService.luau:5-14
    pickaxe_speed_1 = {
        Name = "Pickaxe Speed I",
        BaseCost = 150,
        CostMultiplier = 1.6,
        MaxLevel = 10,
        EffectSpeed = 0.15,
    }, -- :15-24
    inventory_1 = {
        Name = "Inventory Expansion I",
        BaseCost = 500,
        CostMultiplier = 2.0,
        MaxLevel = 5,
        EffectSlots = 20,
    }, -- :25-34
    pet_capacity_1 = { Name = "Pet Capacity I", BaseCost = 1000, CostMultiplier = 2.5, MaxLevel = 5, EffectSlots = 2 }, -- :35-44
    energy_regen_1 = { Name = "Energy Regen I", BaseCost = 200, CostMultiplier = 1.4, MaxLevel = 10, EffectRegen = 0.1 }, -- :45-54
}

-- floor(baseCost * multiplier^currentLevel) -- exact mirror of UpgradeService.luau:144
function Constants.CalculateUpgradeCost(upgrade, currentLevel)
    return math.floor(upgrade.BaseCost * math.pow(upgrade.CostMultiplier, currentLevel))
end

-- ============================================================
-- QUEST REWARDS
--   src/ReplicatedStorage/AetherShared/Data/Quests.luau:4-132
--   Each quest: { Id, Difficulty, LevelRequired, Objectives, Rewards }
--   Rewards: { XP, Currency.AetherShards, Items }
-- ============================================================
Constants.Quests = {
    quest_first_harvest = {
        Title = "First Harvest",
        Difficulty = "Easy",
        LevelRequired = 1,
        XP = 100,
        Shards = 50,
        Items = { "basic_pickaxe" },
    }, -- Quests.luau:5-20
    quest_island_explorer = {
        Title = "Island Explorer",
        Difficulty = "Easy",
        LevelRequired = 5,
        XP = 300,
        Shards = 150,
        Items = {},
    }, -- :53-67
    quest_crystal_collector = {
        Title = "Crystal Collector",
        Difficulty = "Medium",
        LevelRequired = 10,
        XP = 500,
        Shards = 200,
        Items = { "energy_potion" },
    }, -- :21-36
    quest_pet_master = {
        Title = "Pet Master",
        Difficulty = "Medium",
        LevelRequired = 12,
        XP = 800,
        Shards = 400,
        Items = { "pet_food", "lucky_charm" },
    }, -- :100-115
    quest_creature_tamer = {
        Title = "Creature Tamer",
        Difficulty = "Hard",
        LevelRequired = 15,
        XP = 1000,
        Shards = 500,
        Items = { "pet_food" },
    }, -- :37-52
    quest_guild_leader = {
        Title = "Guild Leader",
        Difficulty = "Medium",
        LevelRequired = 15,
        XP = 1500,
        Shards = 800,
        Items = { "island_deed" },
    }, -- :84-99
    quest_master_harvester = {
        Title = "Master Harvester",
        Difficulty = "Hard",
        LevelRequired = 20,
        XP = 2000,
        Shards = 1000,
        Items = { "harvest_boost", "lucky_charm" },
    }, -- :68-83
    quest_legendary_hunter = {
        Title = "Legendary Hunter",
        Difficulty = "Very Hard",
        LevelRequired = 35,
        XP = 5000,
        Shards = 2500,
        Items = { "portal_key", "ancient_relic" },
    }, -- :116-131
}

-- ============================================================
-- ITEM VALUES (used as sinks / sell reference)
--   src/ReplicatedStorage/AetherShared/Data/Items.luau (full table, lines 4-366)
--   Key resource/material values below. Item name -> Value (shards).
-- ============================================================
Constants.ItemValues = {
    aether_shard = 1, -- Items.luau:40
    ancient_wood = 2, -- :262
    crystal_fragment = 5, -- :127
    wolf_tooth = 5, -- :202
    basic_pickaxe = 10, -- :28
    pet_food = 10, -- :166
    iron_pickaxe = 50, -- :155
    shadow_fur = 50, -- :13
    volcanic_ore = 25, -- :79
    energy_potion = 25, -- :178
    verdant_bark = 30, -- :139
    spirit_crystal = 100, -- :103
    harvest_boost = 100, -- :250
    void_essence = 100, -- :298
    aether_crystal = 150, -- :214
    aether_fur = 150, -- :285
    crystal_pickaxe = 200, -- :325
    crystal_scale = 200, -- :115
    lucky_charm = 250, -- :91
    guardian_seed = 250, -- :337
    storm_essence = 300, -- :361
    drake_egg = 300, -- :52
    sky_essence = 400, -- :238
    leviathan_scale = 1000, -- :226
    void_shard = 1000, -- :349
    aether_pickaxe = 2000, -- :67
    island_deed = 5000, -- :274
    ancient_relic = 5000, -- :190
    portal_key = 10000, -- :310
}

-- ============================================================
-- DAILY CALENDAR (30-day login rewards)
--   src/ReplicatedStorage/AetherShared/Data/Rewards.luau:4-35
--   Rewards.DailyCalendar = { DayN = { Currency, XP?, Item?, Amount?, Bonus? } }
-- ============================================================
Constants.DailyCalendar = {
    { Day = 1, Currency = 50, Item = "aether_shard", Amount = 5 }, -- Rewards.luau:5
    { Day = 2, Currency = 75, XP = 100 }, -- :6
    { Day = 3, Currency = 100, Item = "energy_potion", Amount = 2 }, -- :7
    { Day = 4, Currency = 150, XP = 200 }, -- :8
    { Day = 5, Currency = 200, Item = "aether_shard", Amount = 10 }, -- :9
    { Day = 6, Currency = 300, XP = 500 }, -- :10
    { Day = 7, Currency = 500, Item = "iron_pickaxe", Amount = 1, Bonus = "Streak bonus!" }, -- :11
    { Day = 8, Currency = 400, XP = 800 }, -- :12
    { Day = 9, Currency = 450, Item = "aether_shard", Amount = 20 }, -- :13
    { Day = 10, Currency = 500, XP = 1000 }, -- :14
    { Day = 11, Currency = 600, Item = "crystal_fragment", Amount = 5 }, -- :15
    { Day = 12, Currency = 700, XP = 1500 }, -- :16
    { Day = 13, Currency = 800, Item = "aether_shard", Amount = 30 }, -- :17
    { Day = 14, Currency = 1000, Item = "iron_pickaxe", Amount = 1, Bonus = "Streak bonus!" }, -- :18
    { Day = 15, Currency = 900, XP = 2000 }, -- :19
    { Day = 16, Currency = 1000, Item = "aether_shard", Amount = 40 }, -- :20
    { Day = 17, Currency = 1200, XP = 2500 }, -- :21
    { Day = 18, Currency = 1500, Item = "crystal_pickaxe", Amount = 1 }, -- :22
    { Day = 19, Currency = 2000, XP = 3000 }, -- :23
    { Day = 20, Currency = 2500, Item = "aether_shard", Amount = 50, Bonus = "Halfway reward!" }, -- :24
    { Day = 21, Currency = 3000, Item = "void_essence", Amount = 2, Bonus = "Streak bonus!" }, -- :25
    { Day = 22, Currency = 3500, XP = 5000 }, -- :26
    { Day = 23, Currency = 4000, Item = "aether_shard", Amount = 60 }, -- :27
    { Day = 24, Currency = 5000, XP = 7500 }, -- :28
    { Day = 25, Currency = 6000, Item = "crystal_fragment", Amount = 20 }, -- :29
    { Day = 26, Currency = 7000, XP = 10000 }, -- :30
    { Day = 27, Currency = 8000, Item = "aether_shard", Amount = 100 }, -- :31
    { Day = 28, Currency = 10000, Item = "crystal_pickaxe", Amount = 1, Bonus = "Streak bonus!" }, -- :32
    { Day = 29, Currency = 15000, XP = 20000 }, -- :33
    { Day = 30, Currency = 50000, Item = "ancient_dragon_pet", Amount = 1, Bonus = "MONTHLY REWARD!" }, -- :34
}

-- ============================================================
-- PET BONUSES (HarvestPower / Luck feed into harvest)
--   src/ReplicatedStorage/AetherShared/Data/Pets.luau (stats per pet, lines 4-261)
--   src/ServerScriptService/AetherServer/GameServices/PetService.luau:292-304
--   GetPetBonuses(player) -> petData.Stats { HarvestPower, Speed, Luck, Defense }
-- ============================================================
Constants.PetHarvestPower = {
    aether_spirit_pet = 5, -- Pets.luau:17
    crystal_golem_pet = 15, -- :41
    void_tentacle_pet = 10, -- :66
    fire_sprite_pet = 8, -- :91
    storm_elemental_pet = 12, -- :115
    ancient_dragon_pet = 25, -- :140
    cloud_sprite = 5, -- :165
    verdant_deer = 7, -- :182
    storm_hawk = 10, -- :199
    crystal_fox = 12, -- :218
    shadow_wolf = 15, -- :237
    aether_fox = 20, -- :254
}
Constants.PetLuck = {
    aether_spirit_pet = 2, -- Pets.luau:19
    crystal_golem_pet = 5, -- :43
    void_tentacle_pet = 8, -- :68
    fire_sprite_pet = 3, -- :93
    storm_elemental_pet = 10, -- :117
    ancient_dragon_pet = 15, -- :142
    cloud_sprite = 2, -- :165
    verdant_deer = 4, -- :182
    storm_hawk = 3, -- :199
    crystal_fox = 6, -- :218
    shadow_wolf = 5, -- :237
    aether_fox = 10, -- :254
}
-- No-pet fallback (no equipped pet, or unknown id)
Constants.NO_PET_BONUS = { HarvestPower = 0, Speed = 0, Luck = 0, Defense = 0 } -- PetService.luau:295,299

return Constants
