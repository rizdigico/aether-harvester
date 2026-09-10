--!strict
-- Engine-free inventory mutation predicates.
-- The server still owns the inventory; this module keeps every mutation
-- bounded and tied to a known item definition.

local InventoryRules = {}

local MAX_ITEM_COUNT = 1000000000

local function isFiniteInteger(value: any): boolean
    return type(value) == "number"
        and value == value
        and value < math.huge
        and value > -math.huge
        and value == math.floor(value)
end

local function isNonNegativeInteger(value: any): boolean
    return isFiniteInteger(value) and value >= 0 and value <= MAX_ITEM_COUNT
end

local function isValidDefinition(itemId: any, definition: any): boolean
    return type(itemId) == "string" and itemId ~= "" and type(definition) == "table" and definition.Id == itemId
end

function InventoryRules.CanAdd(itemId: any, amount: any, currentCount: any, definition: any): (boolean, number, string)
    if not isValidDefinition(itemId, definition) then
        return false, 0, "Unknown item"
    end
    if not isFiniteInteger(amount) or amount < 1 or amount > MAX_ITEM_COUNT then
        return false, 0, "Invalid amount"
    end
    local current = if currentCount == nil then 0 else currentCount
    if not isNonNegativeInteger(current) then
        return false, 0, "Invalid current count"
    end
    if current > MAX_ITEM_COUNT - amount then
        return false, 0, "Inventory limit reached"
    end
    return true, current + amount, "Item can be added"
end

function InventoryRules.CanRemove(
    itemId: any,
    amount: any,
    currentCount: any,
    definition: any
): (boolean, number, string)
    if not isValidDefinition(itemId, definition) then
        return false, 0, "Unknown item"
    end
    if not isFiniteInteger(amount) or amount < 1 or amount > MAX_ITEM_COUNT then
        return false, 0, "Invalid amount"
    end
    if not isNonNegativeInteger(currentCount) or currentCount < amount then
        return false, 0, "Not enough items"
    end
    return true, currentCount - amount, "Item can be removed"
end

return InventoryRules
