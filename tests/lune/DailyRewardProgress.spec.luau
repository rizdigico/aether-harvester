--!strict
-- Pure tests for the daily reward calendar state machine.

local DailyRewardProgress = require("../../src/ReplicatedStorage/AetherShared/Modules/DailyRewardProgress")
local Rewards = require("../../src/ReplicatedStorage/AetherShared/Data/Rewards")

local function expectEqual(actual: any, expected: any, label: string)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)), 2)
    end
end

local function expectTrue(value: any, label: string)
    if not value then
        error(string.format("%s: expected truthy", label), 2)
    end
end

return {
    {
        name = "DailyRewardProgress.ResolveClaim",
        tests = {
            {
                name = "first claim starts at streak one",
                fn = function()
                    local result = DailyRewardProgress.ResolveClaim(nil, 0, 172800)
                    expectTrue(result.canClaim, "first claim allowed")
                    expectEqual(result.streak, 1, "first streak")
                end,
            },
            {
                name = "same day is rejected",
                fn = function()
                    local day = DailyRewardProgress.GetDayIndex(172800)
                    local result = DailyRewardProgress.ResolveClaim(day, 4, 172800)
                    expectTrue(not result.canClaim, "duplicate rejected")
                    expectEqual(result.reason, "already_claimed", "duplicate reason")
                    expectEqual(result.streak, 4, "streak preserved")
                end,
            },
            {
                name = "next UTC day increments streak",
                fn = function()
                    local day = DailyRewardProgress.GetDayIndex(172800)
                    local result = DailyRewardProgress.ResolveClaim(day, 4, 172800 + 86400)
                    expectEqual(result.streak, 5, "consecutive streak")
                end,
            },
            {
                name = "a missed day resets streak",
                fn = function()
                    local day = DailyRewardProgress.GetDayIndex(172800)
                    local result = DailyRewardProgress.ResolveClaim(day, 4, 172800 + 2 * 86400)
                    expectEqual(result.streak, 1, "reset streak")
                end,
            },
        },
    },
    {
        name = "Rewards.GetDailyReward",
        tests = {
            {
                name = "numeric day resolves the calendar key",
                fn = function()
                    expectEqual(Rewards.GetDailyReward(1).Currency, 50, "day one")
                end,
            },
            {
                name = "day thirty resolves the monthly reward",
                fn = function()
                    expectEqual(Rewards.GetDailyReward(30).Pet, "ancient_dragon_pet", "day thirty pet")
                end,
            },
            {
                name = "streak cycles across the 30-day calendar",
                fn = function()
                    expectEqual(DailyRewardProgress.GetRewardDay(31, 30), 1, "cycle day")
                end,
            },
        },
    },
}
