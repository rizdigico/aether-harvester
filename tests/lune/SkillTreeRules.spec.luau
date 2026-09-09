local SkillTreeRules = require("../../src/ReplicatedStorage/AetherShared/Modules/SkillTreeRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "SkillTreeRules.CanPurchase",
        tests = {
            {
                name = "enforces points, level, prerequisites, and max level",
                fn = function()
                    local levels = {}
                    local ok, reason = SkillTreeRules.CanPurchase("harvest_rhythm", levels, 1, 1)
                    expectEqual(ok, false, "level gate")
                    expectEqual(reason, "Player level is too low", "level reason")

                    ok, reason = SkillTreeRules.CanPurchase("harvest_rhythm", levels, 1, 5)
                    expectEqual(ok, false, "prerequisite gate")
                    expectEqual(reason, "Prerequisite skill is not ready", "prerequisite reason")

                    levels.harvest_precision = 2
                    ok = SkillTreeRules.CanPurchase("harvest_rhythm", levels, 1, 5)
                    expectEqual(ok, true, "purchase allowed")

                    levels.harvest_rhythm = 5
                    ok = SkillTreeRules.CanPurchase("harvest_rhythm", levels, 1, 5)
                    expectEqual(ok, false, "max level")
                end,
            },
        },
    },
    {
        name = "SkillTreeRules.NormalizeLevels",
        tests = {
            {
                name = "drops unknown skills and clamps known levels",
                fn = function()
                    local levels = SkillTreeRules.NormalizeLevels({
                        harvest_precision = 99.8,
                        aether_reserves = -2,
                        unknown = 4,
                    })
                    expectEqual(levels.harvest_precision, 5, "upper clamp")
                    expectEqual(levels.aether_reserves, 0, "lower clamp")
                    expectEqual(levels.unknown, nil, "unknown skill")
                end,
            },
        },
    },
    {
        name = "SkillTreeRules.GetEffectTotals",
        tests = {
            {
                name = "aggregates bounded effects",
                fn = function()
                    local totals = SkillTreeRules.GetEffectTotals({
                        harvest_precision = 2,
                        aether_reserves = 3,
                        harvest_rhythm = 1,
                    })
                    expectEqual(totals.HarvestYield, 0.1, "yield bonus")
                    expectEqual(totals.MaxEnergy, 15, "energy bonus")
                    expectEqual(totals.HarvestSpeed, 0.04, "speed bonus")
                end,
            },
        },
    },
}
