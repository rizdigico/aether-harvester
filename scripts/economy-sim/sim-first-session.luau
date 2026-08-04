-- Simulates a new player's first 60-minute session (backlog E6.1)
-- Uses REAL constants from aether_constants.luau (recovered game build).
-- Fixed seed for reproducibility.
math.randomseed(42)

local Constants = require("./aether_constants")

-- Single AetherNode available to a fresh player (first island).
-- NodeManager.luau:22 -> AetherNode { MinYield=1, MaxYield=3, RespawnTime=30, XP=10 }
local node = Constants.NodeTypes.AetherNode

local shardBalance = 0
local shardsHarvested = 0
local xp = 0
local level = 1
local timeMinutes = 0
local firstUpgradeTime = nil
local questDone = false

-- Walk the real XP curve, leveling as needed.
local function addXP(amount)
    xp += amount
    while xp >= Constants.CalculateXPRequired(level) do
        xp -= Constants.CalculateXPRequired(level)
        level += 1
    end
end

-- Per-60s tick: a 30s-respawn node is harvested twice per minute.
while timeMinutes < 60 do
    local harvestsThisMinute = 2
    for _ = 1, harvestsThisMinute do
        local yieldAmount = math.random(node.MinYield, node.MaxYield)
        shardBalance += yieldAmount
        shardsHarvested += yieldAmount
        addXP(node.XP)
    end
    print(
        string.format(
            "Minute %d: +%d..%d shards/harvest, Shards: %d, Level %d",
            timeMinutes,
            node.MinYield,
            node.MaxYield,
            shardBalance,
            level
        )
    )

    -- Quest "First Harvest": harvest 5 aether_shards (Quests.luau:5-20)
    -- Reward: +50 shards, +100 XP, grants basic_pickaxe.
    if not questDone and shardsHarvested >= 5 then
        questDone = true
        shardBalance += Constants.Quests.quest_first_harvest.Shards
        addXP(Constants.Quests.quest_first_harvest.XP)
        print(
            string.format(
                "Minute %d: Quest 'First Harvest' complete! +%d shards, +%d XP, Shards: %d, Level %d",
                timeMinutes,
                Constants.Quests.quest_first_harvest.Shards,
                Constants.Quests.quest_first_harvest.XP,
                shardBalance,
                level
            )
        )
    end

    -- First upgrade when affordable: Pickaxe Power I base cost 100 (UpgradeService.luau:11)
    if firstUpgradeTime == nil and shardBalance >= Constants.Upgrades.pickaxe_power_1.BaseCost then
        firstUpgradeTime = timeMinutes
        shardBalance -= Constants.Upgrades.pickaxe_power_1.BaseCost
        print(
            string.format("Minute %d: Pickaxe Power I purchased! Remaining shards: %d", firstUpgradeTime, shardBalance)
        )
    end

    timeMinutes += 1
end

print(
    string.format(
        "\nFirst upgrade at %s minutes. Final shards: %d | Level %d (XP %d/%d)",
        firstUpgradeTime and tostring(firstUpgradeTime) or "never",
        shardBalance,
        level,
        xp,
        Constants.CalculateXPRequired(level)
    )
)
