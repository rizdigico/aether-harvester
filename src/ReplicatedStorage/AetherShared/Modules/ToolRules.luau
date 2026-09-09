--!strict
-- Pure tool ownership, durability, and harvest-effect rules.

local ToolRules = {}

ToolRules.DEFAULT_TOOL_ID = "basic_pickaxe"
ToolRules.MIN_DURABILITY = 0

local function isFiniteNumber(value: any): boolean
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

function ToolRules.NormalizeDurability(value: any, maximum: any): number
    local maxDurability = isFiniteNumber(maximum) and math.max(1, math.floor(maximum)) or 1
    if not isFiniteNumber(value) then
        return maxDurability
    end
    return math.clamp(math.floor(value), ToolRules.MIN_DURABILITY, maxDurability)
end

function ToolRules.CanEquip(toolId: any, ownedCount: any, definition: any): (boolean, string)
    if type(toolId) ~= "string" or toolId == "" then
        return false, "Invalid tool"
    end
    if type(definition) ~= "table" or definition.Type ~= "Tool" then
        return false, "That item is not a tool"
    end
    if not isFiniteNumber(ownedCount) or ownedCount < 1 then
        return false, "You do not own that tool"
    end
    return true, "Tool can be equipped"
end

function ToolRules.CanUse(durability: any, maximum: any): boolean
    return ToolRules.NormalizeDurability(durability, maximum) > ToolRules.MIN_DURABILITY
end

function ToolRules.GetYieldMultiplier(power: any): number
    if not isFiniteNumber(power) then
        return 1
    end
    return math.clamp(1 + math.max(0, power - 10) / 100, 1, 3)
end

function ToolRules.GetCooldownMultiplier(speed: any): number
    if not isFiniteNumber(speed) or speed <= 0 then
        return 1
    end
    return math.clamp(1 / speed, 0.25, 2)
end

function ToolRules.GetRepairCost(durability: any, maximum: any, itemValue: any): number
    local maxDurability = ToolRules.NormalizeDurability(nil, maximum)
    local currentDurability = ToolRules.NormalizeDurability(durability, maxDurability)
    if not isFiniteNumber(itemValue) or itemValue < 1 or currentDurability >= maxDurability then
        return 0
    end
    return math.max(1, math.ceil((maxDurability - currentDurability) * itemValue * 0.1))
end

function ToolRules.CanRepair(durability: any, maximum: any, itemValue: any, balance: any): (boolean, number, string)
    local cost = ToolRules.GetRepairCost(durability, maximum, itemValue)
    if cost <= 0 then
        return false, 0, "Tool is already fully repaired"
    end
    if not isFiniteNumber(balance) or balance < cost then
        return false, cost, "Not enough currency"
    end
    return true, cost, "Tool can be repaired"
end

return ToolRules
