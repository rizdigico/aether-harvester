-- Simulates days 1-7 with progression
-- Fixed seed for reproducibility
math.randomseed(42)

local player_data = {
    level = 1,
    xp = 0,
    shards = 0,
    gems = 0,
    upgrades = 0,
    daily_reward = 100,
    quest_reward = 50,
}

-- XP curve: xp_needed(level) = 100 * 1.5^(level-1)
local function xp_needed(level)
    return 100 * (1.5 ^ (level - 1))
end

-- Simulate 7 days
for day = 1, 7 do
    local daily_shards = 0
    local daily_xp = 0
    local daily_upgrades = 0

    -- Simulate 2 sessions per day
    for session = 1, 2 do
        -- Harvesting
        local harvest_shards = math.random(50, 150)
        player_data.shards = player_data.shards + harvest_shards
        daily_shards = daily_shards + harvest_shards

        -- XP from harvesting
        local harvest_xp = math.random(10, 30)
        player_data.xp = player_data.xp + harvest_xp
        daily_xp = daily_xp + harvest_xp

        -- Quest rewards
        player_data.shards = player_data.shards + player_data.quest_reward
        daily_shards = daily_shards + player_data.quest_reward

        -- Daily reward
        if session == 1 then
            player_data.shards = player_data.shards + player_data.daily_reward
            daily_shards = daily_shards + player_data.daily_reward
        end

        -- Upgrades
        if player_data.shards >= 100 then
            local upgrade_count = math.floor(player_data.shards / 100)
            player_data.shards = player_data.shards - (upgrade_count * 100)
            player_data.upgrades = player_data.upgrades + upgrade_count
            daily_upgrades = daily_upgrades + upgrade_count
        end
    end

    -- Level up check
    while player_data.xp >= xp_needed(player_data.level) do
        player_data.xp = player_data.xp - xp_needed(player_data.level)
        player_data.level = player_data.level + 1
    end

    -- Print daily summary
    print(
        string.format(
            "Day %d: Level %d, XP: %d, Shards: %d, Gems: %d, Upgrades: %d",
            day,
            player_data.level,
            player_data.xp,
            player_data.shards,
            player_data.gems,
            player_data.upgrades
        )
    )
end
