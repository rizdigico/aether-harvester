--!strict
-- Engine-free upgrade arithmetic and purchase predicates.

local UpgradeMath = {}

local MAX_COST = 1000000000

function UpgradeMath.CalculateCost(baseCost: number, multiplier: number, currentLevel: number): number
    if
        type(baseCost) ~= "number"
        or type(multiplier) ~= "number"
        or type(currentLevel) ~= "number"
        or baseCost < 0
        or multiplier < 1
        or currentLevel < 0
        or currentLevel ~= math.floor(currentLevel)
    then
        return 0
    end

    local cost = math.floor(baseCost * math.pow(multiplier, currentLevel))
    return math.min(MAX_COST, math.max(0, cost))
end

function UpgradeMath.CanPurchase(currentLevel: number, maxLevel: number, balance: number, cost: number): boolean
    if
        type(currentLevel) ~= "number"
        or type(maxLevel) ~= "number"
        or type(balance) ~= "number"
        or type(cost) ~= "number"
    then
        return false
    end
    if currentLevel < 0 or maxLevel < 0 or currentLevel ~= math.floor(currentLevel) then
        return false
    end
    if currentLevel >= maxLevel or cost < 0 or balance < cost then
        return false
    end
    return true
end

return UpgradeMath
