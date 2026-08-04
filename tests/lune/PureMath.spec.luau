--!strict
-- Lune spec for the pure domain module (no Roblox engine).

local PureMath = require("../../src/ReplicatedStorage/AetherShared/Modules/PureMath")

local function expectEqual(actual: any, expected: any, label: string)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)), 2)
    end
end

local function expectTrue(value: any, label: string)
    if not value then
        error(string.format("%s: expected truthy, got %s", label, tostring(value)), 2)
    end
end

return {
    {
        name = "PureMath.XPRequiredForLevel",
        tests = {
            {
                name = "level 1 -> 100",
                fn = function()
                    expectEqual(PureMath.XPRequiredForLevel(1), 100, "lvl1")
                end,
            },
            {
                name = "level 2 -> 150",
                fn = function()
                    expectEqual(PureMath.XPRequiredForLevel(2), 150, "lvl2")
                end,
            },
            {
                name = "level 5 -> 506 (1.5^4*100)",
                fn = function()
                    expectEqual(PureMath.XPRequiredForLevel(5), 506, "lvl5")
                end,
            },
        },
    },
    {
        name = "PureMath.Clamp",
        tests = {
            {
                name = "clamps above max",
                fn = function()
                    expectEqual(PureMath.Clamp(150, 0, 100), 100, "high")
                end,
            },
            {
                name = "clamps below min",
                fn = function()
                    expectEqual(PureMath.Clamp(-5, 0, 100), 0, "low")
                end,
            },
            {
                name = "keeps in range",
                fn = function()
                    expectEqual(PureMath.Clamp(42, 0, 100), 42, "mid")
                end,
            },
        },
    },
    {
        name = "PureMath.FormatNumber",
        tests = {
            {
                name = "formats millions",
                fn = function()
                    expectEqual(PureMath.FormatNumber(1000000), "1,000,000", "1M")
                end,
            },
            {
                name = "formats thousands",
                fn = function()
                    expectEqual(PureMath.FormatNumber(1234), "1,234", "1k")
                end,
            },
            {
                name = "formats small",
                fn = function()
                    expectEqual(PureMath.FormatNumber(42), "42", "42")
                end,
            },
            {
                name = "formats zero",
                fn = function()
                    expectEqual(PureMath.FormatNumber(0), "0", "zero")
                end,
            },
        },
    },
    {
        name = "PureMath.SeededRNG",
        tests = {
            {
                name = "same seed -> same sequence",
                fn = function()
                    local a = PureMath.SeededRNG(42)
                    local b = PureMath.SeededRNG(42)
                    for _ = 1, 10 do
                        expectEqual(a(), b(), "sequence match")
                    end
                end,
            },
            {
                name = "values in [0,1)",
                fn = function()
                    local rng = PureMath.SeededRNG(7)
                    for _ = 1, 50 do
                        local v = rng()
                        expectTrue(v >= 0 and v < 1, "range")
                    end
                end,
            },
            {
                name = "different seeds differ",
                fn = function()
                    local a = PureMath.SeededRNG(1)()
                    local b = PureMath.SeededRNG(2)()
                    expectTrue(a ~= b, "seeds differ")
                end,
            },
        },
    },
    {
        name = "PureMath.Shuffle",
        tests = {
            {
                name = "preserves elements deterministically",
                fn = function()
                    local t1 = { 1, 2, 3, 4, 5, 6 }
                    local t2 = { 1, 2, 3, 4, 5, 6 }
                    PureMath.Shuffle(t1, PureMath.SeededRNG(99))
                    PureMath.Shuffle(t2, PureMath.SeededRNG(99))
                    for i = 1, 6 do
                        expectEqual(t1[i], t2[i], "same shuffle")
                    end
                    table.sort(t1)
                    for i = 1, 6 do
                        expectEqual(t1[i], i, "all elements")
                    end
                end,
            },
        },
    },
}
