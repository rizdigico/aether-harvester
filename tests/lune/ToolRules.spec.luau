local ToolRules = require("../../src/ReplicatedStorage/AetherShared/Modules/ToolRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "ToolRules.NormalizeDurability",
        tests = {
            {
                name = "clamps missing and invalid durability",
                fn = function()
                    expectEqual(ToolRules.NormalizeDurability(nil, 100), 100, "missing durability")
                    expectEqual(ToolRules.NormalizeDurability(140, 100), 100, "upper bound")
                    expectEqual(ToolRules.NormalizeDurability(-5, 100), 0, "lower bound")
                end,
            },
        },
    },
    {
        name = "ToolRules.CanEquip",
        tests = {
            {
                name = "requires an owned tool definition",
                fn = function()
                    local ok = ToolRules.CanEquip("basic_pickaxe", 1, { Type = "Tool" })
                    expectEqual(ok, true, "owned tool")
                    ok = ToolRules.CanEquip("basic_pickaxe", 0, { Type = "Tool" })
                    expectEqual(ok, false, "unowned tool")
                    ok = ToolRules.CanEquip("aether_shard", 1, { Type = "Resource" })
                    expectEqual(ok, false, "resource is not a tool")
                end,
            },
        },
    },
    {
        name = "ToolRules.GetHarvestEffects",
        tests = {
            {
                name = "scales yield and cooldown from tool stats",
                fn = function()
                    expectEqual(ToolRules.GetYieldMultiplier(10), 1, "base power")
                    expectEqual(ToolRules.GetYieldMultiplier(60), 1.5, "power bonus")
                    expectEqual(ToolRules.GetCooldownMultiplier(2), 0.5, "speed bonus")
                    expectEqual(ToolRules.GetCooldownMultiplier(nil), 1, "missing speed")
                end,
            },
        },
    },
    {
        name = "ToolRules.Repair",
        tests = {
            {
                name = "prices only missing durability and requires balance",
                fn = function()
                    expectEqual(ToolRules.GetRepairCost(50, 100, 10), 50, "half repair cost")
                    expectEqual(ToolRules.GetRepairCost(100, 100, 10), 0, "full tool is free")
                    local ok, cost = ToolRules.CanRepair(50, 100, 10, 49)
                    expectEqual(ok, false, "insufficient balance")
                    expectEqual(cost, 50, "reported cost")
                    ok, cost = ToolRules.CanRepair(50, 100, 10, 50)
                    expectEqual(ok, true, "repair allowed")
                    expectEqual(cost, 50, "allowed cost")
                end,
            },
        },
    },
}
