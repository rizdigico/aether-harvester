-- Simulates 30 days of currency flow for 3 player types
-- Fixed seed for reproducibility
math.randomseed(42)

local player_types = {
    casual = { playtime = 1, shards = 0, gems = 0, inflation = false },
    engaged = { playtime = 3, shards = 0, gems = 0, inflation = false },
    whale = { playtime = 6, shards = 0, gems = 0, inflation = false },
}

-- Constants
local HARVEST_RATE = 50 -- shards per hour
local QUEST_REWARD = 50 -- shards per day
local DAILY_REWARD = 100 -- shards per day
local UPGRADE_COST = 100 -- shards per upgrade

-- Simulate 30 days
for _ = 1, 30 do
    for _, player in pairs(player_types) do
        -- Calculate daily earnings
        local daily_earnings = (HARVEST_RATE * player.playtime) + QUEST_REWARD + DAILY_REWARD
        player.shards = player.shards + daily_earnings

        -- Calculate daily sinks
        local daily_sinks = math.floor(player.shards / UPGRADE_COST) * UPGRADE_COST
        player.shards = player.shards - daily_sinks

        -- Check for inflation
        if player.shards > 100000 then
            player.inflation = true
        end
    end
end

-- Print results
for name, player in pairs(player_types) do
    print(
        string.format(
            "Player Type: %s, Final Shards: %d, Inflation: %s",
            name,
            player.shards,
            player.inflation and "Yes" or "No"
        )
    )
end
