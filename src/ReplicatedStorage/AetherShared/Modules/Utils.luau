local Utils = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Utility: Generate unique ID
function Utils.GenerateId()
    return math.random(100000, 999999) .. tostring(os.time()):sub(-4)
end

-- Utility: Format number with commas
function Utils.FormatNumber(num)
    local formatted = tostring(math.floor(num))
    local k = string.format("%03d", num % 1000)
    return formatted .. k
end

-- Utility: Calculate XP required for level
function Utils.CalculateXPRequired(level)
    return math.floor(100 * math.pow(1.5, level - 1))
end

-- Utility: Distance between two points
function Utils.GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Utility: Clamp value between min and max
function Utils.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Utility: Random chance (0.0 to 1.0)
function Utils.RandomChance(chance)
    return math.random() < chance
end

-- Utility: Shuffle table
function Utils.ShuffleTable(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

-- Utility: Deep clone table
function Utils.DeepClone(tbl)
    local clone = {}
    for k, v in pairs(tbl) do
        if type(v) == "table" then
            clone[k] = Utils.DeepClone(v)
        else
            clone[k] = v
        end
    end
    return clone
end

return Utils
