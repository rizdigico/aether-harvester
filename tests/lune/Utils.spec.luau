--!strict
-- Pure-Luau spec for Modules/Utils.luau runnable by Lune.
-- Tests: RNG, Math, String, Table, Validation helpers, Constants, Enums.

local Utils = require("../../src/ReplicatedStorage/AetherShared/Modules/Utils")

local function expectEqual(actual: any, expected: any, label: string)
    if actual ~= expected then
        error(string.format("%s: expected %s, got %s", label, tostring(expected), tostring(actual)), 2)
    end
end

local function expectNear(actual: number, expected: number, epsilon: number, label: string)
    if math.abs(actual - expected) > epsilon then
        error(
            string.format(
                "%s: expected ~%s (±%s), got %s",
                label,
                tostring(expected),
                tostring(epsilon),
                tostring(actual)
            ),
            2
        )
    end
end

local function expectTrue(value: any, label: string)
    if not value then
        error(string.format("%s: expected truthy, got %s", label, tostring(value)), 2)
    end
end

local function expectFalse(value: any, label: string)
    if value then
        error(string.format("%s: expected falsy, got %s", label, tostring(value)), 2)
    end
end

return {
    -- ============================================================
    -- Constants
    -- ============================================================
    {
        name = "Constants",
        tests = {
            {
                name = "GAME_VERSION is a string",
                fn = function()
                    expectTrue(type(Utils.Constants.GAME_VERSION) == "string", "GAME_VERSION type")
                end,
            },
            {
                name = "MAX_LEVEL is 100",
                fn = function()
                    expectEqual(Utils.Constants.MAX_LEVEL, 100, "MAX_LEVEL")
                end,
            },
            {
                name = "MAX_INVENTORY_SLOTS_BASE is 50",
                fn = function()
                    expectEqual(Utils.Constants.MAX_INVENTORY_SLOTS_BASE, 50, "MAX_INVENTORY_SLOTS_BASE")
                end,
            },
            {
                name = "SKILL_POINTS_PER_LEVEL is 5",
                fn = function()
                    expectEqual(Utils.Constants.SKILL_POINTS_PER_LEVEL, 5, "SKILL_POINTS_PER_LEVEL")
                end,
            },
            {
                name = "PRESTIGE_REQUIRED_LEVEL is 50",
                fn = function()
                    expectEqual(Utils.Constants.PRESTIGE_REQUIRED_LEVEL, 50, "PRESTIGE_REQUIRED_LEVEL")
                end,
            },
        },
    },

    -- ============================================================
    -- Enums
    -- ============================================================
    {
        name = "Enums",
        tests = {
            {
                name = "ItemRarity has expected values",
                fn = function()
                    expectEqual(Utils.Enums.ItemRarity.Common, 1, "ItemRarity.Common")
                    expectEqual(Utils.Enums.ItemRarity.Legendary, 5, "ItemRarity.Legendary")
                    expectEqual(Utils.Enums.ItemRarity.Mythic, 6, "ItemRarity.Mythic")
                end,
            },
            {
                name = "ItemType has expected values",
                fn = function()
                    expectEqual(Utils.Enums.ItemType.Resource, 1, "ItemType.Resource")
                    expectEqual(Utils.Enums.ItemType.QuestItem, 5, "ItemType.QuestItem")
                end,
            },
            {
                name = "BiomeType has expected values",
                fn = function()
                    expectEqual(Utils.Enums.BiomeType.Forest, 1, "BiomeType.Forest")
                    expectEqual(Utils.Enums.BiomeType.Arctic, 7, "BiomeType.Arctic")
                end,
            },
        },
    },

    -- ============================================================
    -- Math helpers
    -- ============================================================
    {
        name = "Math.clamp",
        tests = {
            {
                name = "clamps above max",
                fn = function()
                    expectEqual(Utils.clamp(150, 0, 100), 100, "clamp high")
                end,
            },
            {
                name = "clamps below min",
                fn = function()
                    expectEqual(Utils.clamp(-50, 0, 100), 0, "clamp low")
                end,
            },
            {
                name = "keeps in-range value",
                fn = function()
                    expectEqual(Utils.clamp(42, 0, 100), 42, "clamp mid")
                end,
            },
            {
                name = "handles min equals max",
                fn = function()
                    expectEqual(Utils.clamp(5, 7, 7), 7, "clamp same")
                end,
            },
        },
    },
    {
        name = "Math.lerp",
        tests = {
            {
                name = "lerp at midpoint",
                fn = function()
                    expectEqual(Utils.lerp(0.5, 0, 100), 50, "lerp mid")
                end,
            },
            {
                name = "lerp at start",
                fn = function()
                    expectEqual(Utils.lerp(0, 10, 20), 10, "lerp start")
                end,
            },
            {
                name = "lerp at end",
                fn = function()
                    expectEqual(Utils.lerp(1, 10, 20), 20, "lerp end")
                end,
            },
        },
    },
    {
        name = "Math.distance2D",
        tests = {
            {
                name = "returns squared distance",
                fn = function()
                    -- distance2D returns SQUARED distance (dx*dx + dy*dy)
                    expectEqual(Utils.distance2D(0, 0, 3, 4), 25, "distance2D 3-4-5")
                end,
            },
            {
                name = "same point returns 0",
                fn = function()
                    expectEqual(Utils.distance2D(5, 5, 5, 5), 0, "distance2D same")
                end,
            },
        },
    },
    {
        name = "Math.distance3D",
        tests = {
            {
                name = "calculates Euclidean distance",
                fn = function()
                    expectNear(Utils.distance3D(0, 0, 0, 1, 2, 2), 3, 0.001, "distance3D 1-2-2")
                end,
            },
            {
                name = "same point returns 0",
                fn = function()
                    expectEqual(Utils.distance3D(0, 0, 0, 0, 0, 0), 0, "distance3D same")
                end,
            },
        },
    },
    {
        name = "Math.angleBetween",
        tests = {
            {
                name = "perpendicular vectors",
                fn = function()
                    expectNear(Utils.angleBetween(1, 0, 0, 1), math.pi / 2, 0.001, "angle perp")
                end,
            },
            {
                name = "parallel same direction",
                fn = function()
                    expectNear(Utils.angleBetween(1, 0, 1, 0), 0, 0.001, "angle parallel")
                end,
            },
            {
                name = "opposite vectors",
                fn = function()
                    expectNear(Utils.angleBetween(1, 0, -1, 0), math.pi, 0.001, "angle opposite")
                end,
            },
            {
                name = "zero vector returns 0",
                fn = function()
                    expectEqual(Utils.angleBetween(0, 0, 1, 1), 0, "angle zero")
                end,
            },
        },
    },
    {
        name = "Math.mapRange",
        tests = {
            {
                name = "maps midpoint",
                fn = function()
                    expectEqual(Utils.mapRange(50, 0, 100, 0, 1000), 500, "mapRange mid")
                end,
            },
            {
                name = "maps min",
                fn = function()
                    expectEqual(Utils.mapRange(0, 0, 100, 0, 1000), 0, "mapRange min")
                end,
            },
            {
                name = "maps max",
                fn = function()
                    expectEqual(Utils.mapRange(100, 0, 100, 0, 1000), 1000, "mapRange max")
                end,
            },
        },
    },
    {
        name = "Math.roundTo",
        tests = {
            {
                name = "rounds to integer",
                fn = function()
                    expectEqual(Utils.roundTo(3.7), 4, "round int")
                end,
            },
            {
                name = "rounds to precision",
                fn = function()
                    expectEqual(Utils.roundTo(3.14159, 2), 3.14, "round 2dp")
                end,
            },
            {
                name = "rounds zero precision",
                fn = function()
                    expectEqual(Utils.roundTo(2.5), 3, "round 0dp")
                end,
            },
        },
    },

    -- ============================================================
    -- String helpers
    -- ============================================================
    {
        name = "String.formatNumber",
        tests = {
            {
                name = "formats thousands",
                fn = function()
                    expectEqual(Utils.formatNumber(1000000), "1,000,000", "format 1M")
                end,
            },
            {
                name = "formats small number",
                fn = function()
                    expectEqual(Utils.formatNumber(42), "42", "format 42")
                end,
            },
            {
                name = "formats zero",
                fn = function()
                    expectEqual(Utils.formatNumber(0), "0", "format 0")
                end,
            },
        },
    },
    {
        name = "String.formatTime",
        tests = {
            {
                name = "formats seconds only",
                fn = function()
                    expectEqual(Utils.formatTime(30), "30s", "format 30s")
                end,
            },
            {
                name = "formats minutes and seconds",
                fn = function()
                    expectEqual(Utils.formatTime(90), "1m 30s", "format 90s")
                end,
            },
            {
                name = "formats hours",
                fn = function()
                    expectEqual(Utils.formatTime(3661), "1h 1m 1s", "format 3661s")
                end,
            },
            {
                name = "formats days",
                fn = function()
                    expectEqual(Utils.formatTime(90061), "1d 1h 1m 1s", "format 90061s")
                end,
            },
        },
    },
    {
        name = "String.truncate",
        tests = {
            {
                name = "truncates long string",
                fn = function()
                    expectEqual(Utils.truncate("Hello World", 5), "He...", "truncate long")
                end,
            },
            {
                name = "keeps short string",
                fn = function()
                    expectEqual(Utils.truncate("Hi", 5), "Hi", "truncate short")
                end,
            },
            {
                name = "custom suffix",
                fn = function()
                    expectEqual(Utils.truncate("Hello World", 8, ".."), "Hello ..", "truncate custom suffix")
                end,
            },
        },
    },
    {
        name = "String.generateUID",
        tests = {
            {
                name = "generates default length",
                fn = function()
                    local uid = Utils.generateUID()
                    expectEqual(#uid, 8, "uid default len")
                end,
            },
            {
                name = "generates custom length",
                fn = function()
                    local uid = Utils.generateUID(16)
                    expectEqual(#uid, 16, "uid custom len")
                end,
            },
            {
                name = "generates unique values",
                fn = function()
                    local uid1 = Utils.generateUID(16)
                    local uid2 = Utils.generateUID(16)
                    expectTrue(uid1 ~= uid2, "uid unique")
                end,
            },
        },
    },

    -- ============================================================
    -- Table helpers
    -- ============================================================
    {
        name = "Table.deepClone",
        tests = {
            {
                name = "clones nested table",
                fn = function()
                    local original = { a = 1, b = { c = 2 } }
                    local cloned = Utils.deepClone(original)
                    expectEqual(cloned.a, 1, "clone.a")
                    expectEqual(cloned.b.c, 2, "clone.b.c")
                    -- Verify independence
                    cloned.b.c = 99
                    expectEqual(original.b.c, 2, "original.b.c unchanged")
                end,
            },
            {
                name = "handles non-table",
                fn = function()
                    expectEqual(Utils.deepClone(42), 42, "clone number")
                    expectEqual(Utils.deepClone("hello"), "hello", "clone string")
                end,
            },
        },
    },
    {
        name = "Table.merge",
        tests = {
            {
                name = "merges with overwrite",
                fn = function()
                    local target = { a = 1, b = 2 }
                    local source = { b = 3, c = 4 }
                    local result = Utils.merge(target, source)
                    expectEqual(result.a, 1, "merge a")
                    expectEqual(result.b, 3, "merge b overwritten")
                    expectEqual(result.c, 4, "merge c added")
                end,
            },
        },
    },
    {
        name = "Table.filter",
        tests = {
            {
                name = "filters correctly",
                fn = function()
                    local data = { 1, 2, 3, 4, 5 }
                    local result = Utils.filter(data, function(v)
                        return v > 3
                    end)
                    expectEqual(#result, 2, "filter count")
                    expectEqual(result[1], 4, "filter first")
                    expectEqual(result[2], 5, "filter second")
                end,
            },
        },
    },
    {
        name = "Table.find",
        tests = {
            {
                name = "finds matching element",
                fn = function()
                    local data = { 10, 20, 30 }
                    local result = Utils.find(data, function(v)
                        return v == 20
                    end)
                    expectEqual(result, 20, "find match")
                end,
            },
            {
                name = "returns nil when not found",
                fn = function()
                    local data = { 10, 20, 30 }
                    local result = Utils.find(data, function(v)
                        return v == 99
                    end)
                    expectEqual(result, nil, "find miss")
                end,
            },
        },
    },
    {
        name = "Table.contains",
        tests = {
            {
                name = "returns true for present value",
                fn = function()
                    expectTrue(Utils.contains({ 1, 2, 3 }, 2), "contains yes")
                end,
            },
            {
                name = "returns false for absent value",
                fn = function()
                    expectFalse(Utils.contains({ 1, 2, 3 }, 4), "contains no")
                end,
            },
        },
    },
    {
        name = "Table.count",
        tests = {
            {
                name = "counts entries",
                fn = function()
                    expectEqual(Utils.count({ a = 1, b = 2, c = 3 }), 3, "count")
                end,
            },
            {
                name = "counts empty table",
                fn = function()
                    expectEqual(Utils.count({}), 0, "count empty")
                end,
            },
        },
    },

    -- ============================================================
    -- Validation helpers
    -- ============================================================
    {
        name = "Validation.isPositiveInteger",
        tests = {
            {
                name = "accepts positive integer",
                fn = function()
                    expectTrue(Utils.isPositiveInteger(5), "pos int")
                end,
            },
            {
                name = "rejects zero",
                fn = function()
                    expectFalse(Utils.isPositiveInteger(0), "zero")
                end,
            },
            {
                name = "rejects negative",
                fn = function()
                    expectFalse(Utils.isPositiveInteger(-3), "negative")
                end,
            },
            {
                name = "rejects float",
                fn = function()
                    expectFalse(Utils.isPositiveInteger(3.5), "float")
                end,
            },
            {
                name = "rejects string",
                fn = function()
                    expectFalse(Utils.isPositiveInteger("5"), "string")
                end,
            },
        },
    },
    {
        name = "Validation.isNonNegativeInteger",
        tests = {
            {
                name = "accepts zero",
                fn = function()
                    expectTrue(Utils.isNonNegativeInteger(0), "zero")
                end,
            },
            {
                name = "accepts positive",
                fn = function()
                    expectTrue(Utils.isNonNegativeInteger(10), "positive")
                end,
            },
            {
                name = "rejects negative",
                fn = function()
                    expectFalse(Utils.isNonNegativeInteger(-1), "negative")
                end,
            },
        },
    },
    {
        name = "Validation.isValidItemId",
        tests = {
            {
                name = "accepts positive integer",
                fn = function()
                    expectTrue(Utils.isValidItemId(1), "valid id")
                end,
            },
            {
                name = "rejects zero",
                fn = function()
                    expectFalse(Utils.isValidItemId(0), "zero id")
                end,
            },
        },
    },
    {
        name = "Validation.isValidCreatureId",
        tests = {
            {
                name = "accepts positive integer",
                fn = function()
                    expectTrue(Utils.isValidCreatureId(1), "valid id")
                end,
            },
            {
                name = "rejects negative",
                fn = function()
                    expectFalse(Utils.isValidCreatureId(-1), "neg id")
                end,
            },
        },
    },

    -- ============================================================
    -- RNG helpers
    -- ============================================================
    {
        name = "RNG.seededRandom",
        tests = {
            {
                name = "returns a function",
                fn = function()
                    local rng = Utils.seededRandom(42)
                    expectTrue(type(rng) == "function", "rng is function")
                end,
            },
            {
                name = "produces values in [0,1)",
                fn = function()
                    local rng = Utils.seededRandom(42)
                    for _ = 1, 20 do
                        local v = rng()
                        expectTrue(v >= 0 and v < 1, "rng range")
                    end
                end,
            },
            {
                name = "same seed produces same sequence",
                fn = function()
                    local rng1 = Utils.seededRandom(42)
                    local rng2 = Utils.seededRandom(42)
                    local v1 = rng1()
                    local v2 = rng2()
                    expectNear(v1, v2, 0.0001, "seed reproducibility")
                end,
            },
        },
    },
    {
        name = "RNG.weightedRandom",
        tests = {
            {
                name = "returns an element from the table",
                fn = function()
                    local items = { "A", "B", "C" }
                    local weights = { 0.5, 0.3, 0.2 }
                    for _ = 1, 30 do
                        local result = Utils.weightedRandom(items, weights)
                        expectTrue(result == "A" or result == "B" or result == "C", "weighted result in set")
                    end
                end,
            },
        },
    },
    {
        name = "RNG.chanceRoll",
        tests = {
            {
                name = "100% always true",
                fn = function()
                    for _ = 1, 20 do
                        expectTrue(Utils.chanceRoll(100), "100% chance")
                    end
                end,
            },
            {
                name = "0% always false",
                fn = function()
                    for _ = 1, 20 do
                        expectFalse(Utils.chanceRoll(0), "0% chance")
                    end
                end,
            },
        },
    },
    {
        name = "RNG.shuffle",
        tests = {
            {
                name = "preserves all elements",
                fn = function()
                    local t = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
                    Utils.shuffle(t)
                    -- Sort and verify all elements present
                    table.sort(t)
                    for i = 1, 10 do
                        expectEqual(t[i], i, "shuffle element " .. i)
                    end
                end,
            },
        },
    },
}
