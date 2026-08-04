-- Simulates 30 days of currency flow for 3 player types (backlog E7.3)
-- Uses REAL constants from aether_constants.luau (recovered game build).
-- Fixed seed for reproducibility.
math.randomseed(42)

local Constants = require("./aether_constants")

-- Player types: playtime in hours/day. Real yields/XP/sinks drive flow.
local playerTypes = {
    casual = { name = "Casual", playtimeHours = 1, shards = 0, pickaxeLevel = 0 },
    engaged = { name = "Engaged", playtimeHours = 3, shards = 0, pickaxeLevel = 0 },
    whale = { name = "Whale", playtimeHours = 6, shards = 0, pickaxeLevel = 0 },
}

local up = Constants.Upgrades.pickaxe_power_1 -- sink: base 100, x1.5, max 10

-- Estimate shards/hr using the real AetherNode yield + respawn, with the
-- +50% harvest_boost consumable multiplier (NodeManager.luau:94-96) applied.
local node = Constants.NodeTypes.AetherNode
local avgYield = (node.MinYield + node.MaxYield) / 2
local harvestsPerHour = 3600 / node.RespawnTime -- 3600s/hr / 30s respawn
local shardsPerHour = math.floor(avgYield * harvestsPerHour * Constants.HARVEST_BOOST_MULTIPLIER)

local function sinkUpgrades(shards, level)
    local remaining = shards
    while level < up.MaxLevel do
        local cost = Constants.CalculateUpgradeCost(up, level)
        if remaining >= cost then
            remaining -= cost
            level += 1
        else
            break
        end
    end
    return remaining, level
end

for day = 1, 30 do
    for _, p in pairs(playerTypes) do
        -- Harvest income (real yields) + daily login reward (real calendar).
        p.shards += shardsPerHour * p.playtimeHours
        local daily = Constants.DailyCalendar[((day - 1) % #Constants.DailyCalendar) + 1]
        p.shards += daily.Currency
        p.shards += (daily.Amount or 0) * (Constants.ItemValues[daily.Item] or 0)

        -- Sink: spend on upgrades.
        p.shards, p.pickaxeLevel = sinkUpgrades(p.shards, p.pickaxeLevel)
    end
end

for _, p in pairs(playerTypes) do
    print(
        string.format(
            "Player Type: %s, Playtime %dh/day, Final Shards: %d, PickaxePowerI lv%d/10",
            p.name,
            p.playtimeHours,
            p.shards,
            p.pickaxeLevel
        )
    )
end

print(
    string.format(
        "\nReal yield model: %.1f shards/node avg, %d harvests/hr, %d shards/hr (with +50%% boost)",
        avgYield,
        harvestsPerHour,
        shardsPerHour
    )
)
