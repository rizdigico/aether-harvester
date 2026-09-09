local UpgradeMath = require("../../src/ReplicatedStorage/AetherShared/Modules/UpgradeMath")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "UpgradeMath.CalculateCost",
        tests = {
            {
                name = "scales from the current level",
                fn = function()
                    expectEqual(UpgradeMath.CalculateCost(100, 1.5, 0), 100, "level zero")
                    expectEqual(UpgradeMath.CalculateCost(100, 1.5, 2), 225, "level two")
                end,
            },
            {
                name = "rejects malformed inputs and caps overflow",
                fn = function()
                    expectEqual(UpgradeMath.CalculateCost(100, 1.5, -1), 0, "negative level")
                    expectEqual(UpgradeMath.CalculateCost(100, 0.5, 1), 0, "subunit multiplier")
                    expectEqual(UpgradeMath.CalculateCost(1000000000, 10, 10), 1000000000, "cost cap")
                end,
            },
        },
    },
    {
        name = "UpgradeMath.CanPurchase",
        tests = {
            {
                name = "allows an affordable non-maxed upgrade",
                fn = function()
                    expectEqual(UpgradeMath.CanPurchase(2, 10, 500, 450), true, "purchase allowed")
                end,
            },
            {
                name = "rejects maxed and unaffordable upgrades",
                fn = function()
                    expectEqual(UpgradeMath.CanPurchase(10, 10, 500, 1), false, "maxed")
                    expectEqual(UpgradeMath.CanPurchase(2, 10, 400, 450), false, "unaffordable")
                end,
            },
        },
    },
}
