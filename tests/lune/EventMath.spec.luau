local EventMath = require("../../src/ReplicatedStorage/AetherShared/Modules/EventMath")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "EventMath.GetBonus",
        tests = {
            {
                name = "returns configured bonuses and safe defaults",
                fn = function()
                    expectEqual(EventMath.GetBonus("DoubleXP"), 2, "double xp")
                    expectEqual(EventMath.GetBonus("unknown"), 1, "unknown event")
                    expectEqual(EventMath.GetBonus(nil), 1, "malformed event")
                end,
            },
        },
    },
    {
        name = "EventMath.GetYieldMultiplier",
        tests = {
            {
                name = "counts active yield events only",
                fn = function()
                    expectEqual(
                        EventMath.GetYieldMultiplier({
                            { Type = "ResourceRush", Active = true },
                            { Type = "DoubleXP", Active = true },
                            { Type = "HarvestFestival", Active = false },
                        }),
                        1.5,
                        "yield events"
                    )
                end,
            },
        },
    },
    {
        name = "EventMath.GetXPMultiplier",
        tests = {
            {
                name = "counts active double xp events and composes safely",
                fn = function()
                    expectEqual(
                        EventMath.GetXPMultiplier({
                            { Type = "DoubleXP", Active = true },
                            { Type = "ResourceRush", Active = true },
                            { Type = "DoubleXP", Active = false },
                        }),
                        2,
                        "xp events"
                    )
                    expectEqual(EventMath.GetXPMultiplier(nil), 1, "no events")
                end,
            },
        },
    },
}
