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

return ToolRules
