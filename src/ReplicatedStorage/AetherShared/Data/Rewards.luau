-- Rewards data module
local Rewards = {}

Rewards.DailyCalendar = {
    Day1 = { Currency = 50, Item = "aether_shard", Amount = 5 },
    Day2 = { Currency = 75, XP = 100 },
    Day3 = { Currency = 100, Item = "energy_potion", Amount = 2 },
    Day4 = { Currency = 150, XP = 200 },
    Day5 = { Currency = 200, Item = "aether_shard", Amount = 10 },
    Day6 = { Currency = 300, XP = 500 },
    Day7 = { Currency = 500, Item = "iron_pickaxe", Amount = 1, Bonus = "Streak bonus!" },
    Day8 = { Currency = 400, XP = 800 },
    Day9 = { Currency = 450, Item = "aether_shard", Amount = 20 },
    Day10 = { Currency = 500, XP = 1000 },
    Day11 = { Currency = 600, Item = "crystal_fragment", Amount = 5 },
    Day12 = { Currency = 700, XP = 1500 },
    Day13 = { Currency = 800, Item = "aether_shard", Amount = 30 },
    Day14 = { Currency = 1000, Item = "iron_pickaxe", Amount = 1, Bonus = "Streak bonus!" },
    Day15 = { Currency = 900, XP = 2000 },
    Day16 = { Currency = 1000, Item = "aether_shard", Amount = 40 },
    Day17 = { Currency = 1200, XP = 2500 },
    Day18 = { Currency = 1500, Item = "crystal_pickaxe", Amount = 1 },
    Day19 = { Currency = 2000, XP = 3000 },
    Day20 = { Currency = 2500, Item = "aether_shard", Amount = 50, Bonus = "Halfway reward!" },
    Day21 = { Currency = 3000, Item = "void_essence", Amount = 2, Bonus = "Streak bonus!" },
    Day22 = { Currency = 3500, XP = 5000 },
    Day23 = { Currency = 4000, Item = "aether_shard", Amount = 60 },
    Day24 = { Currency = 5000, XP = 7500 },
    Day25 = { Currency = 6000, Item = "crystal_fragment", Amount = 20 },
    Day26 = { Currency = 7000, XP = 10000 },
    Day27 = { Currency = 8000, Item = "aether_shard", Amount = 100 },
    Day28 = { Currency = 10000, Item = "crystal_pickaxe", Amount = 1, Bonus = "Streak bonus!" },
    Day29 = { Currency = 15000, XP = 20000 },
    Day30 = { Currency = 50000, Pet = "ancient_dragon_pet", Bonus = "MONTHLY REWARD!" },
}

Rewards.ExtraRewards = {
    ["daily_login"] = {
        Id = "daily_login",
        Name = "Daily Login",
        Description = "Log in to the game",
        Type = "Daily",
        Rewards = {
            XP = 100,
            Currency = { AetherShards = 50 },
        },
    },
    ["weekly_challenge"] = {
        Id = "weekly_challenge",
        Name = "Weekly Challenge",
        Description = "Complete the weekly challenge",
        Type = "Weekly",
        Rewards = {
            XP = 1000,
            Currency = { AetherShards = 500 },
            Items = { "energy_potion", "pet_food" },
        },
    },
    ["season_pass"] = {
        Id = "season_pass",
        Name = "Season Pass Reward",
        Description = "Season pass progression reward",
        Type = "Seasonal",
        Rewards = {
            XP = 2000,
            Currency = { AetherShards = 1000 },
            Items = { "harvest_boost", "lucky_charm" },
        },
    },
}

function Rewards.GetDailyReward(day)
    if type(day) == "string" then
        return Rewards.DailyCalendar[day]
    end
    if type(day) ~= "number" then
        return nil
    end
    local dayNumber = math.floor(day)
    if dayNumber < 1 or dayNumber > 30 then
        return nil
    end
    return Rewards.DailyCalendar["Day" .. tostring(dayNumber)]
end

function Rewards.GetMonthlyReward()
    return Rewards.DailyCalendar[30]
end

function Rewards.CalculateStreakBonus(streakDays)
    if streakDays >= 28 then
        return 2.0
    elseif streakDays >= 21 then
        return 1.5
    elseif streakDays >= 14 then
        return 1.3
    elseif streakDays >= 7 then
        return 1.2
    else
        return 1.0
    end
end

function Rewards.GetExtraReward(rewardId)
    return Rewards.ExtraRewards[rewardId]
end

function Rewards.GetAllExtraRewards()
    return Rewards.ExtraRewards
end

return Rewards
