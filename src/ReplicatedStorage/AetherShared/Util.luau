--!strict
-- Shared math/validation utilities to be covered by unit tests.
-- Placeholder module - real AetherShared utilities will be migrated here
-- from the live game during the revamp.

export type Vector3Tuple = { x: number, y: number, z: number }

local Util = {}

-- Clamp a value between min and max
function Util.clamp(value: number, min: number, max: number): number
    return math.max(min, math.min(max, value))
end

-- Safe division returning fallback when divisor is zero
function Util.safeDivide(numerator: number, denominator: number, fallback: number): number
    if denominator == 0 then
        return fallback
    end
    return numerator / denominator
end

return Util
