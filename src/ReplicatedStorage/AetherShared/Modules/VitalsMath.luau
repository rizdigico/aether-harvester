--!strict
-- Pure player-vitals rules shared by the server and offline tests.

local VitalsMath = {}

VitalsMath.DEFAULT_MAX_ENERGY = 100
VitalsMath.HARVEST_ENERGY_COST = 5
VitalsMath.BASE_REGEN_PER_SECOND = 2

local function isFiniteNumber(value: any): boolean
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

function VitalsMath.NormalizeMaxEnergy(value: any): number
    if not isFiniteNumber(value) then
        return VitalsMath.DEFAULT_MAX_ENERGY
    end
    return math.clamp(math.floor(value), 1, 1000)
end

function VitalsMath.NormalizeEnergy(value: any, maxEnergy: any): number
    local normalizedMax = VitalsMath.NormalizeMaxEnergy(maxEnergy)
    if not isFiniteNumber(value) then
        return normalizedMax
    end
    return math.clamp(value, 0, normalizedMax)
end

function VitalsMath.ConsumeEnergy(current: any, amount: any, maxEnergy: any): (number, boolean)
    local normalizedMax = VitalsMath.NormalizeMaxEnergy(maxEnergy)
    local normalizedCurrent = VitalsMath.NormalizeEnergy(current, normalizedMax)
    if not isFiniteNumber(amount) or amount <= 0 or amount > normalizedMax then
        return normalizedCurrent, false
    end
    if normalizedCurrent < amount then
        return normalizedCurrent, false
    end
    return normalizedCurrent - amount, true
end

function VitalsMath.RegenEnergy(current: any, seconds: any, regenPerSecond: any, maxEnergy: any): number
    local normalizedMax = VitalsMath.NormalizeMaxEnergy(maxEnergy)
    local normalizedCurrent = VitalsMath.NormalizeEnergy(current, normalizedMax)
    if not isFiniteNumber(seconds) or seconds <= 0 or not isFiniteNumber(regenPerSecond) or regenPerSecond <= 0 then
        return normalizedCurrent
    end
    return math.min(normalizedMax, normalizedCurrent + seconds * regenPerSecond)
end

return VitalsMath
