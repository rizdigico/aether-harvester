--!strict
-- Pure-Luau spec runnable by Lune (no Roblox engine).
-- Shape: list of { name = string, tests = { { name = string, fn = function } } }

local Util = require("../../src/ReplicatedStorage/AetherShared/Util")

local function expectEqual(actual: any, expected: any, label: string)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)), 2)
    end
end

return {
    {
        name = "Util.clamp",
        tests = {
            {
                name = "clamps above max",
                fn = function()
                    expectEqual(Util.clamp(150, 0, 100), 100, "clamp high")
                end,
            },
            {
                name = "clamps below min",
                fn = function()
                    expectEqual(Util.clamp(-50, 0, 100), 0, "clamp low")
                end,
            },
            {
                name = "keeps in-range",
                fn = function()
                    expectEqual(Util.clamp(42, 0, 100), 42, "clamp mid")
                end,
            },
        },
    },
    {
        name = "Util.safeDivide",
        tests = {
            {
                name = "divides normally",
                fn = function()
                    expectEqual(Util.safeDivide(10, 2, -1), 5, "divide")
                end,
            },
            {
                name = "fallback on zero",
                fn = function()
                    expectEqual(Util.safeDivide(10, 0, -1), -1, "zero divisor")
                end,
            },
        },
    },
}
