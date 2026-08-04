--!strict
-- Pure-Luau spec for Modules/Progression.luau runnable by Lune.
-- Tests: New, AddXP, LevelUp, stat calculations, level cap, getters.

local Progression = require("../../src/ReplicatedStorage/AetherShared/Modules/Progression")

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

return {
    -- ============================================================
    -- New()
    -- ============================================================
    {
        name = "Progression.New",
        tests = {
            {
                name = "initializes at level 1",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p.level, 1, "level")
                end,
            },
            {
                name = "initializes xp at 0",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p.xp, 0, "xp")
                end,
            },
            {
                name = "initial xpToNextLevel is 1000",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p.xpToNextLevel, 1000, "xpToNextLevel")
                end,
            },
            {
                name = "initial skillPoints is 0",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p.skillPoints, 0, "skillPoints")
                end,
            },
            {
                name = "initial stats are all 1",
                fn = function()
                    local p = Progression.New()
                    local stats = p.stats
                    expectEqual(stats.strength, 1, "strength")
                    expectEqual(stats.agility, 1, "agility")
                    expectEqual(stats.intelligence, 1, "intelligence")
                    expectEqual(stats.defense, 1, "defense")
                    expectEqual(stats.speed, 1, "speed")
                    expectEqual(stats.luck, 1, "luck")
                end,
            },
            {
                name = "skillTrees is empty initially",
                fn = function()
                    local p = Progression.New()
                    expectEqual(#p.skillTrees, 0, "skillTrees empty")
                end,
            },
        },
    },

    -- ============================================================
    -- Getters
    -- ============================================================
    {
        name = "Progression getters",
        tests = {
            {
                name = "GetLevel matches field",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p:GetLevel(), 1, "GetLevel")
                end,
            },
            {
                name = "GetXP matches field",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p:GetXP(), 0, "GetXP")
                end,
            },
            {
                name = "GetXPToNextLevel matches field",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p:GetXPToNextLevel(), 1000, "GetXPToNextLevel")
                end,
            },
            {
                name = "GetSkillPoints matches field",
                fn = function()
                    local p = Progression.New()
                    expectEqual(p:GetSkillPoints(), 0, "GetSkillPoints")
                end,
            },
            {
                name = "GetStats returns stats table",
                fn = function()
                    local p = Progression.New()
                    local stats = p:GetStats()
                    expectTrue(type(stats) == "table", "GetStats is table")
                    expectEqual(stats.strength, 1, "stats.strength")
                end,
            },
        },
    },

    -- ============================================================
    -- AddXP (without level up)
    -- ============================================================
    {
        name = "Progression.AddXP - no level up",
        tests = {
            {
                name = "adds xp below threshold",
                fn = function()
                    local p = Progression.New()
                    p:AddXP(500)
                    expectEqual(p.xp, 500, "xp after add")
                    expectEqual(p.level, 1, "level unchanged")
                end,
            },
            {
                name = "accumulates xp",
                fn = function()
                    local p = Progression.New()
                    p:AddXP(200)
                    p:AddXP(300)
                    expectEqual(p.xp, 500, "accumulated xp")
                end,
            },
        },
    },

    -- ============================================================
    -- LevelUp
    -- ============================================================
    {
        name = "Progression.LevelUp",
        tests = {
            {
                name = "increments level",
                fn = function()
                    local p = Progression.New()
                    p:LevelUp()
                    expectEqual(p.level, 2, "level after levelup")
                end,
            },
            {
                name = "resets xp by subtracting xpToNextLevel",
                fn = function()
                    local p = Progression.New()
                    p.xp = 1500 -- above threshold
                    p:LevelUp()
                    -- xpToNextLevel was 1000, so xp = 1500 - 1000 = 500
                    expectEqual(p.xp, 500, "xp after levelup")
                end,
            },
            {
                name = "increases xpToNextLevel",
                fn = function()
                    local p = Progression.New()
                    p:LevelUp()
                    -- xpToNextLevel = 1000 + (1000 * 0.1 * 2) = 1200
                    expectEqual(p.xpToNextLevel, 1200, "xpToNextLevel after levelup")
                end,
            },
            {
                name = "awards skill points",
                fn = function()
                    local p = Progression.New()
                    p:LevelUp()
                    expectEqual(p.skillPoints, 1, "skillPoints after levelup")
                end,
            },
            {
                name = "updates stats",
                fn = function()
                    local p = Progression.New()
                    p:LevelUp() -- level 2
                    expectEqual(p.stats.strength, math.floor(2 * 0.5), "strength at level 2")
                    expectEqual(p.stats.agility, math.floor(2 * 0.4), "agility at level 2")
                    expectEqual(p.stats.intelligence, math.floor(2 * 0.3), "intelligence at level 2")
                    expectEqual(p.stats.defense, math.floor(2 * 0.4), "defense at level 2")
                    expectEqual(p.stats.speed, math.floor(2 * 0.6), "speed at level 2")
                    expectEqual(p.stats.luck, math.floor(2 * 0.2), "luck at level 2")
                end,
            },
        },
    },

    -- ============================================================
    -- AddXP with level ups
    -- ============================================================
    {
        name = "Progression.AddXP - triggers level up",
        tests = {
            {
                name = "single level up on exactly threshold",
                fn = function()
                    local p = Progression.New()
                    p:AddXP(1000)
                    expectEqual(p.level, 2, "level after 1000 xp")
                    -- xpToNextLevel was 1000, new is 1000 + 1000*0.1*2 = 1200
                    -- xp = 1000 - 1000 = 0
                    expectEqual(p.xp, 0, "xp reset")
                end,
            },
            {
                name = "multiple level ups on large XP",
                fn = function()
                    local p = Progression.New()
                    -- Give enough XP for multiple levels
                    -- Level 1→2 needs 1000 xp, level 2→3 needs 1200 xp, level 3→4 needs 1300...
                    -- Total for 3 levels: 1000 + 1200 + 1300 = 3500
                    p:AddXP(3500)
                    expectTrue(p.level >= 3, "multiple level ups")
                end,
            },
        },
    },

    -- ============================================================
    -- Stat calculations at various levels
    -- ============================================================
    {
        name = "Progression.UpdateStats",
        tests = {
            {
                name = "level 10 stats",
                fn = function()
                    local p = Progression.New()
                    for _ = 1, 9 do
                        p:LevelUp()
                    end
                    -- level should be 10
                    expectEqual(p.level, 10, "level 10")
                    expectEqual(p.stats.strength, math.floor(10 * 0.5), "str@10")
                    expectEqual(p.stats.speed, math.floor(10 * 0.6), "spd@10")
                    expectEqual(p.stats.luck, math.floor(10 * 0.2), "lck@10")
                end,
            },
        },
    },

    -- ============================================================
    -- XP curve consistency
    -- ============================================================
    {
        name = "Progression XP curve",
        tests = {
            {
                name = "xpToNextLevel increases each level",
                fn = function()
                    local p = Progression.New()
                    local prevThreshold = p.xpToNextLevel
                    for _ = 1, 10 do
                        p:LevelUp()
                        expectTrue(
                            p.xpToNextLevel > prevThreshold,
                            "threshold grows: " .. tostring(prevThreshold) .. " -> " .. tostring(p.xpToNextLevel)
                        )
                        prevThreshold = p.xpToNextLevel
                    end
                end,
            },
        },
    },
}
