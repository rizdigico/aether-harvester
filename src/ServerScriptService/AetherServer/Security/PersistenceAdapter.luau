-- PersistenceAdapter keeps local, unpublished Studio runs deterministic without
-- weakening the published-server persistence path. Roblox rejects DataStore
-- access from a local place file, so the adapter is intentionally selected only
-- when Studio reports PlaceId == 0.
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")

local PersistenceAdapter = {}
local localDataStores = {}
local localOrderedStores = {}
local warnedDataStores = {}
local warnedOrderedStores = {}
local MAX_LOCAL_ENTRIES = 1024

local function cloneValue(value)
    if type(value) ~= "table" then
        return value
    end

    local copy = {}
    for key, nestedValue in pairs(value) do
        copy[key] = cloneValue(nestedValue)
    end
    return copy
end

local function isOfflineStudio()
    return RunService:IsStudio() and game.PlaceId == 0
end

local function warnOnce(registry, name, kind)
    if not registry[name] then
        registry[name] = true
        warn(
            string.format(
                "[PersistenceAdapter] Using bounded in-memory %s for unpublished local Studio: %s",
                kind,
                name
            )
        )
    end
end

local function countEntries(store)
    local count = 0
    for _ in pairs(store) do
        count += 1
    end
    return count
end

local function getMemoryDataStore(name)
    local storage = localDataStores[name]
    if not storage then
        storage = {}
        localDataStores[name] = storage
    end
    warnOnce(warnedDataStores, name, "DataStore")

    return {
        GetAsync = function(_, key)
            return cloneValue(storage[key])
        end,
        SetAsync = function(_, key, value)
            if storage[key] == nil and countEntries(storage) >= MAX_LOCAL_ENTRIES then
                return false
            end
            storage[key] = cloneValue(value)
            return true
        end,
        UpdateAsync = function(_, key, transform)
            local current = cloneValue(storage[key])
            local nextValue = transform(current)
            if nextValue == nil then
                return cloneValue(current)
            end
            if storage[key] == nil and countEntries(storage) >= MAX_LOCAL_ENTRIES then
                return cloneValue(current)
            end
            storage[key] = cloneValue(nextValue)
            return cloneValue(nextValue)
        end,
        RemoveAsync = function(_, key)
            storage[key] = nil
            return true
        end,
    }
end

local function getMemoryOrderedDataStore(name)
    local storage = localOrderedStores[name]
    if not storage then
        storage = {}
        localOrderedStores[name] = storage
    end
    warnOnce(warnedOrderedStores, name, "OrderedDataStore")

    return {
        SetAsync = function(_, key, value)
            if storage[key] == nil and countEntries(storage) >= MAX_LOCAL_ENTRIES then
                return false
            end
            if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
                return false
            end
            storage[tostring(key)] = value
            return true
        end,
        GetSortedAsync = function(_, isAscending, pageSize, minValue, maxValue)
            local entries = {}
            for key, value in pairs(storage) do
                if (minValue == nil or value >= minValue) and (maxValue == nil or value <= maxValue) then
                    table.insert(entries, { key = key, value = value })
                end
            end
            table.sort(entries, function(left, right)
                if left.value == right.value then
                    return left.key < right.key
                end
                if isAscending then
                    return left.value < right.value
                end
                return left.value > right.value
            end)

            local limit = type(pageSize) == "number" and math.max(1, math.floor(pageSize)) or 100
            local page = {}
            for index = 1, math.min(limit, #entries) do
                page[index] = entries[index]
            end

            return {
                GetCurrentPage = function()
                    return page
                end,
                IsFinished = true,
                AdvanceToNextPageAsync = function()
                    return false
                end,
            }
        end,
    }
end

function PersistenceAdapter.IsOfflineStudio()
    return isOfflineStudio()
end

function PersistenceAdapter.GetDataStore(name)
    assert(type(name) == "string" and name ~= "", "PersistenceAdapter requires a DataStore name")
    if isOfflineStudio() then
        return getMemoryDataStore(name)
    end
    return DataStoreService:GetDataStore(name)
end

function PersistenceAdapter.GetOrderedDataStore(name)
    assert(type(name) == "string" and name ~= "", "PersistenceAdapter requires an OrderedDataStore name")
    if isOfflineStudio() then
        return getMemoryOrderedDataStore(name)
    end
    return DataStoreService:GetOrderedDataStore(name)
end

return PersistenceAdapter
