--!strict
-- Engine-free currency mutation predicates.
-- Currency ids and balances are still owned by the server; this module keeps
-- every grant/spend finite, integral, non-negative, and bounded.

local CurrencyRules = {}

local MAX_BALANCE = 1000000000

CurrencyRules.Definitions = {
    AetherShards = { Id = "AetherShards" },
    AetherGems = { Id = "AetherGems" },
    EventTokens = { Id = "EventTokens" },
    FamePoints = { Id = "FamePoints" },
}

local function isFiniteInteger(value: any): boolean
    return type(value) == "number"
        and value == value
        and value < math.huge
        and value > -math.huge
        and value == math.floor(value)
end

local function isNonNegativeInteger(value: any): boolean
    return isFiniteInteger(value) and value >= 0 and value <= MAX_BALANCE
end

local function isValidDefinition(currencyId: any, definition: any): boolean
    return type(currencyId) == "string"
        and currencyId ~= ""
        and type(definition) == "table"
        and definition.Id == currencyId
end

function CurrencyRules.CanAdd(
    currencyId: any,
    amount: any,
    currentBalance: any,
    definition: any
): (boolean, number, string)
    if not isValidDefinition(currencyId, definition) then
        return false, 0, "Unknown currency"
    end
    if not isFiniteInteger(amount) or amount < 1 or amount > MAX_BALANCE then
        return false, 0, "Invalid amount"
    end
    local current = if currentBalance == nil then 0 else currentBalance
    if not isNonNegativeInteger(current) then
        return false, 0, "Invalid current balance"
    end
    if current > MAX_BALANCE - amount then
        return false, 0, "Currency limit reached"
    end
    return true, current + amount, "Currency can be added"
end

function CurrencyRules.CanRemove(
    currencyId: any,
    amount: any,
    currentBalance: any,
    definition: any
): (boolean, number, string)
    if not isValidDefinition(currencyId, definition) then
        return false, 0, "Unknown currency"
    end
    if not isFiniteInteger(amount) or amount < 1 or amount > MAX_BALANCE then
        return false, 0, "Invalid amount"
    end
    if not isNonNegativeInteger(currentBalance) or currentBalance < amount then
        return false, 0, "Not enough currency"
    end
    return true, currentBalance - amount, "Currency can be removed"
end

return CurrencyRules
