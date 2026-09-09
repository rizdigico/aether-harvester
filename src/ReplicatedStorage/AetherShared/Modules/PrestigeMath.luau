--!strict
-- Pure prestige rules shared by server logic and offline tests.

local PrestigeMath = {}

PrestigeMath.REQUIRED_LEVEL = 100
PrestigeMath.MAX_PRESTIGE = 50
PrestigeMath.XP_BONUS_PER_PRESTIGE = 0.1

local function isFiniteNumber(value: any): boolean
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

function PrestigeMath.NormalizeLevel(value: any): number
    if not isFiniteNumber(value) then
        return 0
    end
    return math.clamp(math.floor(value), 0, PrestigeMath.MAX_PRESTIGE)
end

function PrestigeMath.GetXPMultiplier(prestigeLevel: any): number
    return 1 + PrestigeMath.NormalizeLevel(prestigeLevel) * PrestigeMath.XP_BONUS_PER_PRESTIGE
end

function PrestigeMath.CanPrestige(level: any, prestigeLevel: any): (boolean, string)
    if not isFiniteNumber(level) then
        return false, "Level is unavailable"
    end
    if PrestigeMath.NormalizeLevel(prestigeLevel) >= PrestigeMath.MAX_PRESTIGE then
        return false, "Prestige maximum reached"
    end
    if math.floor(level) < PrestigeMath.REQUIRED_LEVEL then
        return false, "Reach level " .. tostring(PrestigeMath.REQUIRED_LEVEL) .. " first"
    end
    return true, "Ready to ascend"
end

function PrestigeMath.GetNextLevel(prestigeLevel: any): number
    return math.min(PrestigeMath.MAX_PRESTIGE, PrestigeMath.NormalizeLevel(prestigeLevel) + 1)
end

return PrestigeMath
