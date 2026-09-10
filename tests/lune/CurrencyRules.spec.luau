local CurrencyRules = require("../../src/ReplicatedStorage/AetherShared/Modules/CurrencyRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local SHARDS = { Id = "AetherShards" }

return {
    {
        name = "CurrencyRules.CanAdd",
        tests = {
            {
                name = "accepts a known currency and returns the next bounded balance",
                fn = function()
                    local ok, nextBalance = CurrencyRules.CanAdd("AetherShards", 25, 100, SHARDS)
                    expectEqual(ok, true, "known currency")
                    expectEqual(nextBalance, 125, "next balance")
                end,
            },
            {
                name = "rejects unknown, malformed, and overflowing grants",
                fn = function()
                    local ok = CurrencyRules.CanAdd("Unknown", 1, 0, SHARDS)
                    expectEqual(ok, false, "definition mismatch")
                    ok = CurrencyRules.CanAdd("AetherShards", 0, 0, SHARDS)
                    expectEqual(ok, false, "zero amount")
                    ok = CurrencyRules.CanAdd("AetherShards", 2, 1000000000, SHARDS)
                    expectEqual(ok, false, "overflow")
                    ok = CurrencyRules.CanAdd("AetherShards", 1.5, 0, SHARDS)
                    expectEqual(ok, false, "fractional amount")
                end,
            },
        },
    },
    {
        name = "CurrencyRules.CanRemove",
        tests = {
            {
                name = "does not allow spending more than the current balance",
                fn = function()
                    local ok, nextBalance = CurrencyRules.CanRemove("AetherShards", 30, 100, SHARDS)
                    expectEqual(ok, true, "sufficient balance")
                    expectEqual(nextBalance, 70, "next balance")
                    ok = CurrencyRules.CanRemove("AetherShards", 101, 100, SHARDS)
                    expectEqual(ok, false, "insufficient balance")
                end,
            },
        },
    },
}
