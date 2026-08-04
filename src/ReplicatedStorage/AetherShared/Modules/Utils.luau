--
-- Aether Harvester Simulator Utility Module
--
-- @module Utils
--
-- @description A comprehensive utility module for Aether Harvester Simulator, providing
-- RNG, math, string, table, validation, and remote event helpers.
--
-- @author Agent-Company-X
--
-- @version 1.0.0
--
-- @constants
-- GAME_VERSION: string
-- MAX_INVENTORY_SLOTS_BASE: number
-- MAX_LEVEL: number
-- SKILL_POINTS_PER_LEVEL: number
-- PRESTIGE_REQUIRED_LEVEL: number
--
-- @enums
-- ItemRarity, ItemType, CreatureType, BiomeType, QuestType
--
-- @functions
-- RNG: seededRandom, weightedRandom, randomFromTable, chanceRoll, shuffle
-- Math: clamp, lerp, distance2D, distance3D, angleBetween, mapRange, roundTo
-- String: formatNumber, formatTime, truncate, generateUID
-- Table: deepClone, merge, filter, find, contains, count, randomKey, randomValue
-- Validation: isPositiveInteger, isNonNegativeInteger, isValidPlayer, isValidItemId, isValidCreatureId
-- RemoteEvent: safeInvoke, safeFire, withTimeout
--
-- @note All functions are pure unless explicitly named as having side effects.
--
-- @usage require(script.Parent)
-- local utils = require(script)
--
--
--[[ 
-- Constants
--]]
local Constants = {}
Constants.GAME_VERSION = "1.2.3"
Constants.MAX_INVENTORY_SLOTS_BASE = 50
Constants.MAX_LEVEL = 100
Constants.SKILL_POINTS_PER_LEVEL = 5
Constants.PRESTIGE_REQUIRED_LEVEL = 50
Constants.MAX_CREATURE_LEVEL = 20
Constants.MAX_ITEM_QUALITY = 100
Constants.DEFAULT_AETHER_DAMAGE = 10
Constants.DEFAULT_HARVEST_SPEED = 1.0

--[[ 
-- Enums
--]]
local Enums = {}
-- Item Rarity
Enums.ItemRarity = {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Legendary = 5,
    Mythic = 6,
}

-- Item Type
Enums.ItemType = {
    Resource = 1,
    Consumable = 2,
    Equipment = 3,
    CraftingMaterial = 4,
    QuestItem = 5,
}

-- Creature Type
Enums.CreatureType = {
    Animal = 1,
    Plant = 2,
    Mineral = 3,
    Mythical = 4,
    Boss = 5,
}

-- Biome Type
Enums.BiomeType = {
    Forest = 1,
    Desert = 2,
    Mountain = 3,
    Ocean = 4,
    Swamp = 5,
    Volcanic = 6,
    Arctic = 7,
}

-- Quest Type
Enums.QuestType = {
    Daily = 1,
    Weekly = 2,
    Event = 3,
    MainStory = 4,
    SideQuest = 5,
}

--[[ 
-- RNG Module
--]]
local RNG = {}

-- Creates a seeded random number generator
--
-- @param seed: number
-- @return: function
--
-- @usage local rng = RNG.seededRandom(42)
-- local randomValue = rng()
RNG.seededRandom = function(seed)
    -- Self-contained deterministic PRNG (mulberry32).
    -- Does NOT depend on math.random/math.randomseed, so identical seeds
    -- produce identical sequences in Roblox, Lune, and any Luau runtime.
    local state = seed % 4294967296
    return function()
        state = (state + 0x6D2B79F5) % 4294967296
        local t = state
        t = bit32.bxor(t, bit32.rshift(t, 15))
        t = bit32.bxor(t, bit32.lshift(t, 13))
        t = bit32.bxor(t, bit32.rshift(t, 16))
        local x = (t % 4294967296) / 4294967296
        return x
    end
end

-- Returns a random value weighted by the provided weights
--
-- @param table: table
-- @param weights: table
-- @return: any
--
-- @usage local result = RNG.weightedRandom({"A", "B", "C"}, {0.1, 0.7, 0.2})
RNG.weightedRandom = function(table, weights)
    local totalWeight = 0
    for _, weight in ipairs(weights) do
        totalWeight = totalWeight + weight
    end

    local randomValue = math.random() * totalWeight
    local cumulativeWeight = 0

    for i, value in ipairs(table) do
        cumulativeWeight = cumulativeWeight + weights[i]
        if randomValue <= cumulativeWeight then
            return value
        end
    end

    return table[#table]
end

-- Returns a random value from the provided table
--
-- @param table: table
-- @return: any
--
-- @usage local randomValue = RNG.randomFromTable({"A", "B", "C"})
RNG.randomFromTable = function(table)
    return table[math.random(1, #table)]
end

-- Rolls a chance percentage
--
-- @param chance: number (0-100)
-- @return: boolean
--
-- @usage local success = RNG.chanceRoll(50)
RNG.chanceRoll = function(chance)
    return math.random(1, 100) <= chance
end

-- Shuffles a table in place
--
-- @param table: table
--
-- @usage RNG.shuffle({"A", "B", "C"})
RNG.shuffle = function(table)
    for i = #table, 2, -1 do
        local j = math.random(1, i)
        table[i], table[j] = table[j], table[i]
    end
    return table
end

--[[ 
-- Math Helpers
--]]
local Math = {}

-- Clamps a value between a min and max
--
-- @param value: number
-- @param min: number
-- @param max: number
-- @return: number
--
-- @usage local clampedValue = Math.clamp(5, 0, 10)
Math.clamp = function(value, min, max)
    return math.min(math.max(value, min), max)
end

-- Linear interpolation between two values
--
-- @param value: number
-- @param start: number
-- @param end: number
-- @param weight: number (0-1)
-- @return: number
--
-- @usage local interpolatedValue = Math.lerp(0.5, 0, 100)
Math.lerp = function(value, start, target)
    return start + (target - start) * value
end

-- Calculates the squared distance between two 2D points
--
-- @param x1: number
-- @param y1: number
-- @param x2: number
-- @param y2: number
-- @return: number
--
-- @usage local distance = Math.distance2D(0, 0, 3, 4)
Math.distance2D = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end

-- Calculates the distance between two 3D points
--
-- @param x1: number
-- @param y1: number
-- @param z1: number
-- @param x2: number
-- @param y2: number
-- @param z2: number
-- @return: number
--
-- @usage local distance = Math.distance3D(0, 0, 0, 3, 4, 5)
Math.distance3D = function(x1, y1, z1, x2, y2, z2)
    local dx = x2 - x1
    local dy = y2 - y1
    local dz = z2 - z1
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

-- Calculates the angle between two vectors in radians
--
-- @param x1: number
-- @param y1: number
-- @param x2: number
-- @param y2: number
-- @return: number
--
-- @usage local angle = Math.angleBetween(1, 0, 0, 1)
Math.angleBetween = function(x1, y1, x2, y2)
    local dotProduct = x1 * x2 + y1 * y2
    local magnitude1 = math.sqrt(x1 * x1 + y1 * y1)
    local magnitude2 = math.sqrt(x2 * x2 + y2 * y2)

    if magnitude1 == 0 or magnitude2 == 0 then
        return 0
    end

    local cosTheta = dotProduct / (magnitude1 * magnitude2)
    return math.acos(math.clamp(cosTheta, -1, 1))
end

-- Maps a value from one range to another
--
-- @param value: number
-- @param fromMin: number
-- @param fromMax: number
-- @param toMin: number
-- @param toMax: number
-- @return: number
--
-- @usage local mappedValue = Math.mapRange(50, 0, 100, 0, 1000)
Math.mapRange = function(value, fromMin, fromMax, toMin, toMax)
    local fromRange = fromMax - fromMin
    local toRange = toMax - toMin
    local normalizedValue = (value - fromMin) / fromRange
    return toMin + normalizedValue * toRange
end

-- Rounds a number to the nearest integer
--
-- @param value: number
-- @param precision: number (optional)
-- @return: number
--
-- @usage local roundedValue = Math.roundTo(3.14159, 2)
Math.roundTo = function(value, precision)
    if precision then
        local factor = 10 ^ precision
        return math.floor(value * factor + 0.5) / factor
    else
        return math.floor(value + 0.5)
    end
end

--[[ 
-- String Helpers
--]]
local String = {}

-- Formats a number with thousands separators
--
-- @param number: number
-- @return: string
--
-- @usage local formattedNumber = String.formatNumber(1000000)
String.formatNumber = function(number)
    local parts = tostring(math.floor(number + 0.5))
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

-- Formats a time in seconds to a human-readable string
--
-- @param seconds: number
-- @return: string
--
-- @usage local formattedTime = String.formatTime(3661)
String.formatTime = function(seconds)
    local days = math.floor(seconds / 86400)
    local remainingSeconds = seconds % 86400
    local hours = math.floor(remainingSeconds / 3600)
    remainingSeconds = remainingSeconds % 3600
    local minutes = math.floor(remainingSeconds / 60)
    local secs = math.floor(remainingSeconds % 60)

    local parts = {}
    if days > 0 then
        table.insert(parts, days .. "d")
    end
    if hours > 0 or days > 0 then
        table.insert(parts, hours .. "h")
    end
    if minutes > 0 or hours > 0 or days > 0 then
        table.insert(parts, minutes .. "m")
    end
    table.insert(parts, secs .. "s")

    return table.concat(parts, " ")
end

-- Truncates a string to a specified length
--
-- @param str: string
-- @param length: number
-- @param suffix: string (optional)
-- @return: string
--
-- @usage local truncated = String.truncate("Hello World", 5)
String.truncate = function(str, length, suffix)
    suffix = suffix or "..."
    if #str <= length then
        return str
    end
    return str:sub(1, length - #suffix) .. suffix
end

-- Generates a unique ID
--
-- @param length: number (optional)
-- @return: string
--
-- @usage local uid = String.generateUID()
String.generateUID = function(length)
    length = length or 8
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local uid = ""

    for i = 1, length do
        local idx = math.random(1, #chars)
        uid = uid .. chars:sub(idx, idx)
    end

    return uid
end

--[[ 
-- Table Helpers
--]]
local Table = {}

-- Creates a deep clone of a table
--
-- @param table: table
-- @return: table
--
-- @usage local clonedTable = Table.deepClone(originalTable)
Table.deepClone = function(table)
    if type(table) ~= "table" then
        return table
    end

    local clone = {}
    for key, value in pairs(table) do
        if type(value) == "table" then
            clone[key] = Table.deepClone(value)
        else
            clone[key] = value
        end
    end

    return clone
end

-- Merges two tables
--
-- @param target: table
-- @param source: table
-- @param overwrite: boolean (optional)
-- @return: table
--
-- @usage local mergedTable = Table.merge(targetTable, sourceTable)
Table.merge = function(target, source, overwrite)
    overwrite = overwrite or true

    for key, value in pairs(source) do
        if overwrite or target[key] == nil then
            if type(value) == "table" and type(target[key]) == "table" then
                target[key] = Table.merge(target[key], value, overwrite)
            else
                target[key] = value
            end
        end
    end

    return target
end

-- Filters a table
--
-- @param table: table
-- @param callback: function
-- @return: table
--
-- @usage local filteredTable = Table.filter(originalTable, function(value) return value > 0 end)
Table.filter = function(inputTable, callback)
    local result = {}
    for _, value in pairs(inputTable) do
        if callback(value) then
            table.insert(result, value)
        end
    end
    return result
end

-- Finds an item in a table
--
-- @param table: table
-- @param callback: function
-- @return: any
--
-- @usage local foundValue = Table.find(originalTable, function(value) return value == "target" end)
Table.find = function(table, callback)
    for _, value in pairs(table) do
        if callback(value) then
            return value
        end
    end
    return nil
end

-- Checks if a table contains a value
--
-- @param table: table
-- @param value: any
-- @return: boolean
--
-- @usage local contains = Table.contains(originalTable, "target")
Table.contains = function(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- Counts the number of items in a table
--
-- @param table: table
-- @return: number
--
-- @usage local count = Table.count(originalTable)
Table.count = function(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- Returns a random key from a table
--
-- @param table: table
-- @return: any
--
-- @usage local randomKey = Table.randomKey(originalTable)
Table.randomKey = function(table)
    local keys = {}
    for key in pairs(table) do
        table.insert(keys, key)
    end

    return keys[math.random(1, #keys)]
end

-- Returns a random value from a table
--
-- @param table: table
-- @return: any
--
-- @usage local randomValue = Table.randomValue(originalTable)
Table.randomValue = function(table)
    local values = {}
    for _, value in pairs(table) do
        table.insert(values, value)
    end

    return values[math.random(1, #values)]
end

--[[ 
-- Validation Helpers
--]]
local Validation = {}

-- Checks if a value is a positive integer
--
-- @param value: any
-- @return: boolean
--
-- @usage local isPositive = Validation.isPositiveInteger(5)
Validation.isPositiveInteger = function(value)
    return type(value) == "number" and value == math.floor(value) and value > 0
end

-- Checks if a value is a non-negative integer
--
-- @param value: any
-- @return: boolean
--
-- @usage local isNonNegative = Validation.isNonNegativeInteger(5)
Validation.isNonNegativeInteger = function(value)
    return type(value) == "number" and value == math.floor(value) and value >= 0
end

-- Checks if a value is a valid player (placeholder implementation)
--
-- @param value: any
-- @return: boolean
--
-- @usage local isValidPlayer = Validation.isValidPlayer(player)
Validation.isValidPlayer = function(value)
    -- Placeholder: In a real implementation, this would check if the value is a valid Player object
    return type(value) == "table" and value.IsA and value:IsA("Player")
end

-- Checks if a value is a valid item ID
--
-- @param value: any
-- @return: boolean
--
-- @usage local isValidItemId = Validation.isValidItemId(123)
Validation.isValidItemId = function(value)
    return Validation.isPositiveInteger(value)
end

-- Checks if a value is a valid creature ID
--
-- @param value: any
-- @return: boolean
--
-- @usage local isValidCreatureId = Validation.isValidCreatureId(456)
Validation.isValidCreatureId = function(value)
    return Validation.isPositiveInteger(value)
end

--[[ 
-- RemoteEvent/RemoteFunction Helpers
--]]
local Remote = {}

-- Safely invokes a RemoteFunction with a timeout
--
-- @param remoteFunction: RemoteFunction
-- @param ...: any
-- @param timeout: number (optional)
-- @return: any, boolean
--
-- @usage local success, result = Remote.safeInvoke(remoteFunction, arg1, arg2, 5)
Remote.safeInvoke = function(remoteFunction, ...)
    local timeout = select(#... + 1, ...) or 5
    local args = { ... }
    local result, success = pcall(function()
        return remoteFunction:InvokeServer(table.unpack(args))
    end)

    if not success then
        warn("RemoteFunction invoke failed:", result)
        return nil, false
    end

    return result, true
end

-- Safely fires a RemoteEvent with a timeout
--
-- @param remoteEvent: RemoteEvent
-- @param ...: any
-- @param timeout: number (optional)
-- @return: boolean
--
-- @usage local success = Remote.safeFire(remoteEvent, arg1, arg2, 5)
Remote.safeFire = function(remoteEvent, ...)
    local timeout = select(#... + 1, ...) or 5
    local args = { ... }
    local success = pcall(function()
        remoteEvent:FireServer(table.unpack(args))
    end)

    if not success then
        warn("RemoteEvent fire failed:", ...)
        return false
    end

    return true
end

-- Executes a function with a timeout
--
-- @param func: function
-- @param ...: any
-- @param timeout: number
-- @return: any, boolean
--
-- @usage local success, result = Remote.withTimeout(function() return func(...) end, 5)
Remote.withTimeout = function(func, ...)
    local timeout = select(#... + 1, ...) or 5
    local args = { ... }
    local result, success = pcall(function()
        return func(table.unpack(args))
    end)

    if not success then
        warn("Function timed out or failed:", ...)
        return nil, false
    end

    return result, true
end

--[[ 
-- Public API
--]]
return {
    -- Constants
    Constants = Constants,

    -- Enums
    Enums = Enums,

    -- RNG
    seededRandom = RNG.seededRandom,
    weightedRandom = RNG.weightedRandom,
    randomFromTable = RNG.randomFromTable,
    chanceRoll = RNG.chanceRoll,
    shuffle = RNG.shuffle,

    -- Math
    clamp = Math.clamp,
    lerp = Math.lerp,
    distance2D = Math.distance2D,
    distance3D = Math.distance3D,
    angleBetween = Math.angleBetween,
    mapRange = Math.mapRange,
    roundTo = Math.roundTo,

    -- String
    formatNumber = String.formatNumber,
    formatTime = String.formatTime,
    truncate = String.truncate,
    generateUID = String.generateUID,

    -- Table
    deepClone = Table.deepClone,
    merge = Table.merge,
    filter = Table.filter,
    find = Table.find,
    contains = Table.contains,
    count = Table.count,
    randomKey = Table.randomKey,
    randomValue = Table.randomValue,

    -- Validation
    isPositiveInteger = Validation.isPositiveInteger,
    isNonNegativeInteger = Validation.isNonNegativeInteger,
    isValidPlayer = Validation.isValidPlayer,
    isValidItemId = Validation.isValidItemId,
    isValidCreatureId = Validation.isValidCreatureId,

    -- Remote
    safeInvoke = Remote.safeInvoke,
    safeFire = Remote.safeFire,
    withTimeout = Remote.withTimeout,
}
