local PrestigeMath = require("../../src/ReplicatedStorage/AetherShared/Modules/PrestigeMath")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "PrestigeMath.GetXPMultiplier",
        tests = {
            {
                name = "starts at one and scales by ten percent",
                fn = function()
                    expectEqual(PrestigeMath.GetXPMultiplier(0), 1, "zero prestige")
                    expectEqual(PrestigeMath.GetXPMultiplier(3), 1.3, "three prestige")
                end,
            },
            {
                name = "clamps malformed and excessive prestige values",
                fn = function()
                    expectEqual(PrestigeMath.NormalizeLevel(-2), 0, "negative")
                    expectEqual(PrestigeMath.NormalizeLevel(99), 50, "maximum")
                    expectEqual(PrestigeMath.NormalizeLevel(0 / 0), 0, "nan")
                end,
            },
        },
    },
    {
        name = "PrestigeMath.CanPrestige",
        tests = {
            {
                name = "requires level one hundred and available prestige slots",
                fn = function()
                    expectEqual(PrestigeMath.CanPrestige(99, 0), false, "level gate")
                    expectEqual(PrestigeMath.CanPrestige(100, 0), true, "ready")
                    expectEqual(PrestigeMath.CanPrestige(100, 50), false, "maxed")
                end,
            },
        },
    },
}
