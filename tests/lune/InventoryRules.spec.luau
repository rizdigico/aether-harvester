local InventoryRules = require("../../src/ReplicatedStorage/AetherShared/Modules/InventoryRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

local RESOURCE = { Id = "aether_shard" }

return {
    {
        name = "InventoryRules.CanAdd",
        tests = {
            {
                name = "accepts a known item and returns the next bounded count",
                fn = function()
                    local ok, nextCount = InventoryRules.CanAdd("aether_shard", 5, 10, RESOURCE)
                    expectEqual(ok, true, "known item")
                    expectEqual(nextCount, 15, "next count")
                end,
            },
            {
                name = "rejects unknown, malformed, and overflowing grants",
                fn = function()
                    local ok = InventoryRules.CanAdd("unknown", 1, 0, RESOURCE)
                    expectEqual(ok, false, "definition mismatch")
                    ok = InventoryRules.CanAdd("aether_shard", 0, 0, RESOURCE)
                    expectEqual(ok, false, "zero amount")
                    ok = InventoryRules.CanAdd("aether_shard", 2, 1000000000, RESOURCE)
                    expectEqual(ok, false, "overflow")
                end,
            },
        },
    },
    {
        name = "InventoryRules.CanRemove",
        tests = {
            {
                name = "does not allow removing more than the owned count",
                fn = function()
                    local ok, nextCount = InventoryRules.CanRemove("aether_shard", 3, 10, RESOURCE)
                    expectEqual(ok, true, "sufficient items")
                    expectEqual(nextCount, 7, "next count")
                    ok = InventoryRules.CanRemove("aether_shard", 11, 10, RESOURCE)
                    expectEqual(ok, false, "insufficient items")
                end,
            },
        },
    },
}
