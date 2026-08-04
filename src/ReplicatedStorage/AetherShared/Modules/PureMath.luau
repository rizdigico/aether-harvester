--!strict
-- Pure Luau domain helpers for Aether Harvester.
-- NO Roblox engine dependencies: unit-testable under Lune and TestEZ.
-- Used by game services AND by headless sims/tests.

local PureMath = {}

-- XP required to advance from `level` (base 100, growth 1.5)
function PureMath.XPRequiredForLevel(level: number): number
    return math.floor(100 * math.pow(1.5, level - 1))
end

-- Clamp value into [min, max]
function PureMath.Clamp(value: number, min: number, max: number): number
    return math.max(min, math.min(max, value))
end

-- Format an integer with thousands separators (e.g. 1234567 -> "1,234,567")
function PureMath.FormatNumber(value: number): string
    local parts = tostring(math.floor(value + 0.5))
    local result = ""
    local count = 0
    for i = #parts, 1, -1 do
        result = parts:sub(i, i) .. result
        count += 1
        if count % 3 == 0 and i ~= 1 then
            result = "," .. result
        end
    end
    return result
end

-- Deterministic PRNG (mulberry32): same seed -> same sequence everywhere.
export type RNG = () -> number
function PureMath.SeededRNG(seed: number): RNG
    local state = seed % 4294967296
    return function(): number
        state = (state + 0x6D2B79F5) % 4294967296
        local t = state
        t = bit32.bxor(t, bit32.rshift(t, 15))
        t = bit32.bxor(t, bit32.lshift(t, 13))
        t = bit32.bxor(t, bit32.rshift(t, 16))
        return (t % 4294967296) / 4294967296
    end
end

-- Shuffle a table in place using a seeded RNG (deterministic).
function PureMath.Shuffle<T>(tbl: { T }, rng: RNG): { T }
    for i = #tbl, 2, -1 do
        local j = 1 + math.floor(rng() * i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

return PureMath
