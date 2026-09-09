local ReceiptJournal = require("../../src/ReplicatedStorage/AetherShared/Modules/ReceiptJournal")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "ReceiptJournal.TryMark",
        tests = {
            {
                name = "marks a new purchase exactly once",
                fn = function()
                    local journal = {}
                    expectEqual(ReceiptJournal.TryMark(journal, "purchase-1", 100), true, "first mark")
                    expectEqual(ReceiptJournal.IsProcessed(journal, "purchase-1"), true, "journal lookup")
                    expectEqual(ReceiptJournal.TryMark(journal, "purchase-1", 101), false, "duplicate mark")
                    expectEqual(journal["purchase-1"], 100, "original timestamp retained")
                end,
            },
            {
                name = "rejects malformed receipt identifiers and timestamps",
                fn = function()
                    expectEqual(ReceiptJournal.TryMark({}, "", 100), false, "empty id")
                    expectEqual(ReceiptJournal.TryMark({}, "purchase-2", -1), false, "negative timestamp")
                    expectEqual(ReceiptJournal.TryMark({}, "purchase-2", 1.5), false, "fractional timestamp")
                end,
            },
        },
    },
}
