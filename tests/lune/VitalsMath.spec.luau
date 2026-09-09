local VitalsMath = require("../../src/ReplicatedStorage/AetherShared/Modules/VitalsMath")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "VitalsMath.NormalizeEnergy",
        tests = {
            {
                name = "clamps malformed and out of range values",
                fn = function()
                    expectEqual(VitalsMath.NormalizeMaxEnergy(nil), 100, "default max")
                    expectEqual(VitalsMath.NormalizeMaxEnergy(140.8), 140, "whole max")
                    expectEqual(VitalsMath.NormalizeEnergy(-5, 100), 0, "lower bound")
                    expectEqual(VitalsMath.NormalizeEnergy(150, 100), 100, "upper bound")
                    expectEqual(VitalsMath.NormalizeEnergy(nil, 125), 125, "missing energy")
                end,
            },
        },
    },
    {
        name = "VitalsMath.ConsumeEnergy",
        tests = {
            {
                name = "spends only when the player has enough energy",
                fn = function()
                    local remaining, spent = VitalsMath.ConsumeEnergy(20, 5, 100)
                    expectEqual(remaining, 15, "remaining energy")
                    expectEqual(spent, true, "successful spend")

                    remaining, spent = VitalsMath.ConsumeEnergy(4, 5, 100)
                    expectEqual(remaining, 4, "failed spend preserves energy")
                    expectEqual(spent, false, "insufficient energy")
                end,
            },
        },
    },
    {
        name = "VitalsMath.RegenEnergy",
        tests = {
            {
                name = "regenerates over time without exceeding the cap",
                fn = function()
                    expectEqual(VitalsMath.RegenEnergy(10, 2, 2, 100), 14, "regen")
                    expectEqual(VitalsMath.RegenEnergy(99, 2, 2, 100), 100, "cap")
                    expectEqual(VitalsMath.RegenEnergy(10, -1, 2, 100), 10, "invalid duration")
                end,
            },
        },
    },
}
