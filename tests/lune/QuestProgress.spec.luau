--!strict
-- Lune spec for the pure quest-progression module (no Roblox engine).

local QuestProgress = require("../../src/ReplicatedStorage/AetherShared/Modules/QuestProgress")

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
        name = "QuestProgress.ComputeQuestProgress.partial",
        tests = {
            {
                name = "harvest 3 of 5 aether_shard is incomplete",
                fn = function()
                    local questDef = { Objectives = { { Type = "Harvest", ItemId = "aether_shard", Amount = 5 } } }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 3 })
                    expectTrue(not result.completed, "not completed")
                    expectEqual(result.done, 3, "done")
                    expectEqual(result.total, 5, "total")
                end,
            },
            {
                name = "partial in one of two objectives is incomplete",
                fn = function()
                    local questDef = {
                        Objectives = {
                            { Type = "Visit", IslandId = "void_rifts", Amount = 1 },
                            { Type = "Collect", ItemId = "void_essence", Amount = 3 },
                        },
                    }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 1, 1 })
                    expectTrue(not result.completed, "not completed")
                    expectEqual(result.done, 2, "done")
                    expectEqual(result.total, 4, "total")
                end,
            },
        },
    },
    {
        name = "QuestProgress.ComputeQuestProgress.exact",
        tests = {
            {
                name = "harvest exactly 5 of 5 is complete",
                fn = function()
                    local questDef = { Objectives = { { Type = "Harvest", ItemId = "aether_shard", Amount = 5 } } }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 5 })
                    expectTrue(result.completed, "completed")
                    expectEqual(result.done, 5, "done")
                    expectEqual(result.total, 5, "total")
                end,
            },
            {
                name = "both objectives met exactly is complete",
                fn = function()
                    local questDef = {
                        Objectives = {
                            { Type = "Visit", IslandId = "void_rifts", Amount = 1 },
                            { Type = "Collect", ItemId = "void_essence", Amount = 3 },
                        },
                    }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 1, 3 })
                    expectTrue(result.completed, "completed")
                    expectEqual(result.done, 4, "done")
                    expectEqual(result.total, 4, "total")
                end,
            },
        },
    },
    {
        name = "QuestProgress.ComputeQuestProgress.overcomplete clamp",
        tests = {
            {
                name = "harvest 9 of 5 clamps done to 5 but stays complete",
                fn = function()
                    local questDef = { Objectives = { { Type = "Harvest", ItemId = "aether_shard", Amount = 5 } } }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 9 })
                    expectTrue(result.completed, "completed")
                    expectEqual(result.done, 5, "done clamped")
                    expectEqual(result.total, 5, "total")
                end,
            },
            {
                name = "overcomplete one objective but incomplete other",
                fn = function()
                    local questDef = {
                        Objectives = {
                            { Type = "Visit", IslandId = "void_rifts", Amount = 1 },
                            { Type = "Collect", ItemId = "void_essence", Amount = 3 },
                        },
                    }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 99, 2 })
                    expectTrue(not result.completed, "not completed")
                    expectEqual(result.done, 3, "done clamped")
                    expectEqual(result.total, 4, "total")
                end,
            },
        },
    },
    {
        name = "QuestProgress.ComputeQuestProgress.multiple objectives",
        tests = {
            {
                name = "three objectives all met",
                fn = function()
                    local questDef = {
                        Objectives = {
                            { Type = "Defeat", CreatureRarity = "Legendary", Amount = 3 },
                            { Type = "Collect", ItemId = "abyssal_core", Amount = 1 },
                            { Type = "Visit", IslandId = "void_rifts", Amount = 1 },
                        },
                    }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 3, 1, 1 })
                    expectTrue(result.completed, "completed")
                    expectEqual(result.done, 5, "done")
                    expectEqual(result.total, 5, "total")
                end,
            },
            {
                name = "defaults amount to 1 when omitted",
                fn = function()
                    local questDef = { Objectives = { { Type = "Craft", ItemId = "steel_pickaxe" } } }
                    local result = QuestProgress.ComputeQuestProgress(questDef, { 1 })
                    expectTrue(result.completed, "completed")
                    expectEqual(result.done, 1, "done")
                    expectEqual(result.total, 1, "total")
                end,
            },
        },
    },
    {
        name = "QuestProgress.ComputeQuestProgress.zero objectives",
        tests = {
            {
                name = "no objectives yields done=0 total=0 completed=true (vacuous)",
                fn = function()
                    local result = QuestProgress.ComputeQuestProgress({ Objectives = {} }, {})
                    expectTrue(result.completed, "vacuous completion")
                    expectEqual(result.done, 0, "done")
                    expectEqual(result.total, 0, "total")
                end,
            },
            {
                name = "nil questDef is safe",
                fn = function()
                    local result = QuestProgress.ComputeQuestProgress(nil, nil)
                    expectTrue(result.completed, "safe")
                    expectEqual(result.done, 0, "done")
                    expectEqual(result.total, 0, "total")
                end,
            },
        },
    },
    {
        name = "QuestProgress.MatchesObjective",
        tests = {
            {
                name = "Harvest matches by ItemId",
                fn = function()
                    local objective = { Type = "Harvest", ItemId = "aether_shard", Amount = 5 }
                    expectTrue(QuestProgress.MatchesObjective(objective, "Harvest", "aether_shard"), "match")
                    expectTrue(not QuestProgress.MatchesObjective(objective, "Harvest", "ancient_wood"), "no match")
                end,
            },
            {
                name = "Harvest with nil ItemId matches any target",
                fn = function()
                    local objective = { Type = "Harvest", Amount = 1000 }
                    expectTrue(QuestProgress.MatchesObjective(objective, "Harvest", "anything"), "wildcard")
                end,
            },
            {
                name = "Tame matches by CreatureId",
                fn = function()
                    local objective = { Type = "Tame", CreatureId = "cloud_sprite", Amount = 1 }
                    expectTrue(QuestProgress.MatchesObjective(objective, "Tame", "cloud_sprite"), "match")
                    expectTrue(not QuestProgress.MatchesObjective(objective, "Tame", "aether_fox"), "no match")
                end,
            },
            {
                name = "DefeatRarity matches by CreatureRarity only",
                fn = function()
                    local objective = { Type = "DefeatRarity", CreatureRarity = "Legendary", Amount = 5 }
                    expectTrue(QuestProgress.MatchesObjective(objective, "DefeatRarity", "Legendary"), "match")
                    expectTrue(not QuestProgress.MatchesObjective(objective, "DefeatRarity", "Epic"), "no match")
                end,
            },
            {
                name = "Visit matches any target by type",
                fn = function()
                    local objective = { Type = "Visit", IslandId = "storm_peaks", Amount = 1 }
                    expectTrue(QuestProgress.MatchesObjective(objective, "Visit", "storm_peaks"), "match")
                end,
            },
            {
                name = "wrong objective Type does not match",
                fn = function()
                    local objective = { Type = "Harvest", ItemId = "aether_shard", Amount = 5 }
                    expectTrue(not QuestProgress.MatchesObjective(objective, "Tame", "aether_shard"), "type mismatch")
                end,
            },
        },
    },
    {
        name = "QuestProgress.ClampObjectiveProgress",
        tests = {
            {
                name = "clamps progress to amount",
                fn = function()
                    expectEqual(QuestProgress.ClampObjectiveProgress(12, 5), 5, "over")
                end,
            },
            {
                name = "keeps progress under amount",
                fn = function()
                    expectEqual(QuestProgress.ClampObjectiveProgress(3, 5), 3, "under")
                end,
            },
            {
                name = "defaults progress and amount to 0/1 safely",
                fn = function()
                    expectEqual(QuestProgress.ClampObjectiveProgress(nil, nil), 0, "nil-safe")
                end,
            },
        },
    },
}
