-- Simulates days 1-7 of progression (backlog E6.1)
-- Uses REAL constants from aether_constants.luau (recovered game build).
-- Fixed seed for reproducibility.
math.randomseed(42)

local Constants = require("./aether_constants")

local node = Constants.NodeTypes.AetherNode -- AetherNode, NodeManager.luau:22

local player = {
    level = 1,
    xp = 0,
    shards = 0,
    upgrades = {
        pickaxe_power_1 = 0,
    },
    dailyRewardDay = 1,
    questDone = {
        quest_first_harvest = false,
        quest_island_explorer = false,
    },
}

local function addXP(amount)
    player.xp += amount
    while player.xp >= Constants.CalculateXPRequired(player.level) do
        player.xp -= Constants.CalculateXPRequired(player.level)
        player.level += 1
    end
end

-- Spend shards on the cheapest real upgrade (Pickaxe Power I, base 100 / x1.5, MaxLevel 10).
local function spendOnUpgrades()
    local up = Constants.Upgrades.pickaxe_power_1
    while player.upgrades.pickaxe_power_1 < up.MaxLevel do
        local cost = Constants.CalculateUpgradeCost(up, player.upgrades.pickaxe_power_1)
        if player.shards >= cost then
            player.shards -= cost
            player.upgrades.pickaxe_power_1 += 1
        else
            break
        end
    end
end

for day = 1, 7 do
    local dailyHarvested = 0
    local dailyXp = 0

    -- ~1 hour of play: 60 minutes, AetherNode (30s respawn) harvested twice/min.
    local harvests = 120
    for _ = 1, harvests do
        local y = math.random(node.MinYield, node.MaxYield)
        player.shards += y
        dailyHarvested += y
        addXP(node.XP)
        dailyXp += node.XP
    end

    -- Daily login reward (Rewards.luau DailyCalendar, rotates through the 30 days).
    local daily = Constants.DailyCalendar[(player.dailyRewardDay - 1) % #Constants.DailyCalendar + 1]
    player.shards += daily.Currency
    dailyXp += daily.XP or 0
    addXP(daily.XP or 0)

    -- Real quests: First Harvest (day 1) then Island Explorer (day 2+).
    if not player.questDone.quest_first_harvest and dailyHarvested >= 5 then
        player.questDone.quest_first_harvest = true
        player.shards += Constants.Quests.quest_first_harvest.Shards
        addXP(Constants.Quests.quest_first_harvest.XP)
        dailyXp += Constants.Quests.quest_first_harvest.XP
    end
    if day >= 2 and not player.questDone.quest_island_explorer then
        player.questDone.quest_island_explorer = true
        player.shards += Constants.Quests.quest_island_explorer.Shards
        addXP(Constants.Quests.quest_island_explorer.XP)
        dailyXp += Constants.Quests.quest_island_explorer.XP
    end

    spendOnUpgrades()

    print(
        string.format(
            "Day %d: Level %d, XP %d/%d, Shards %d, PickaxePowerI lv%d",
            day,
            player.level,
            player.xp,
            Constants.CalculateXPRequired(player.level),
            player.shards,
            player.upgrades.pickaxe_power_1
        )
    )

    player.dailyRewardDay += 1
end

print(
    string.format(
        "\nEnd of week: Level %d, XP %d, Shards %d, PickaxePowerI level %d/10",
        player.level,
        player.xp,
        player.shards,
        player.upgrades.pickaxe_power_1
    )
)
