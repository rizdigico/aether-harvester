local BaseRules = require("../../src/ReplicatedStorage/AetherShared/Modules/BaseRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "BaseRules.IsValidCoordinate",
        tests = {
            {
                name = "accepts bounded integer grid cells",
                fn = function()
                    expectEqual(BaseRules.IsValidCoordinate(-7), true, "minimum")
                    expectEqual(BaseRules.IsValidCoordinate(7), true, "maximum")
                    expectEqual(BaseRules.IsValidCoordinate(8), false, "out of bounds")
                    expectEqual(BaseRules.IsValidCoordinate(1.5), false, "fraction")
                end,
            },
        },
    },
    {
        name = "BaseRules.IsValidRotation",
        tests = {
            {
                name = "allows quarter-turns only",
                fn = function()
                    expectEqual(BaseRules.IsValidRotation(0), true, "zero")
                    expectEqual(BaseRules.IsValidRotation(90), true, "quarter turn")
                    expectEqual(BaseRules.IsValidRotation(45), false, "diagonal")
                    expectEqual(BaseRules.IsValidRotation(360), false, "full turn")
                end,
            },
        },
    },
    {
        name = "BaseRules.CanPlace",
        tests = {
            {
                name = "enforces the thirty-decoration cap",
                fn = function()
                    expectEqual(BaseRules.CanPlace(29), true, "last slot")
                    expectEqual(BaseRules.CanPlace(30), false, "full")
                    expectEqual(BaseRules.CanPlace(-1), false, "negative")
                end,
            },
        },
    },
}
