-- Simulates a new player's first 60-minute session
-- Fixed seed for reproducibility
math.randomseed(42)

local shard_balance = 0
local time_minutes = 0
local harvest_count = 0
local first_upgrade_time = nil

-- Constants
local HARVEST_RATE = 10 -- shards gained per harvest action (multiple nodes per action)
local UPGRADE_COST = 100
local QUEST_REWARD = 50 -- quest completed at minute 20

-- Simulate first session
while time_minutes < 60 do
    -- Harvest every 10 minutes
    if time_minutes % 10 == 0 then
        harvest_count = harvest_count + 1
        shard_balance = shard_balance + HARVEST_RATE * harvest_count
        print(string.format("Minute %d: Harvested %d nodes, Shards: %d", time_minutes, harvest_count, shard_balance))

        -- Quest reward at minute 20
        if time_minutes == 20 then
            shard_balance = shard_balance + QUEST_REWARD
            print(
                string.format(
                    "Minute %d: Quest completed! +%d shards, Shards: %d",
                    time_minutes,
                    QUEST_REWARD,
                    shard_balance
                )
            )
        end

        -- Check for first upgrade
        if shard_balance >= UPGRADE_COST and first_upgrade_time == nil then
            first_upgrade_time = time_minutes
            shard_balance = shard_balance - UPGRADE_COST
            print(
                string.format(
                    "Minute %d: First upgrade purchased! Remaining shards: %d",
                    first_upgrade_time,
                    shard_balance
                )
            )
        end
    end
    time_minutes = time_minutes + 1
end

-- Print final summary
print(
    string.format(
        "\nFirst upgrade at %s minutes. Final shard balance: %d",
        first_upgrade_time and tostring(first_upgrade_time) or "never",
        shard_balance
    )
)
