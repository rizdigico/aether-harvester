--!strict
-- Pure receipt-idempotency helpers. The server persists the returned journal
-- inside the player's profile before acknowledging a developer-product receipt.

local ReceiptJournal = {}

function ReceiptJournal.IsProcessed(journal: { [string]: number }?, purchaseId: string): boolean
    return type(journal) == "table" and type(purchaseId) == "string" and journal[purchaseId] ~= nil
end

function ReceiptJournal.TryMark(journal: { [string]: number }, purchaseId: string, timestamp: number): boolean
    if type(journal) ~= "table" or type(purchaseId) ~= "string" or purchaseId == "" then
        return false
    end
    if type(timestamp) ~= "number" or timestamp < 0 or timestamp ~= math.floor(timestamp) then
        return false
    end
    if ReceiptJournal.IsProcessed(journal, purchaseId) then
        return false
    end

    -- Do not prune old IDs. A receipt can be retried after a long outage, and
    -- deleting its journal entry would make a duplicate grant possible.
    journal[purchaseId] = timestamp
    return true
end

return ReceiptJournal
