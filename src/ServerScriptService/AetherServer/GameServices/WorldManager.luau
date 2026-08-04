--
-- WorldManager.lua
-- Handles island registry, spawn point management, fast-travel system, and island state tracking.
--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

-- DataStore setup
local WorldDataStore = DataStoreService:GetDataStore("WorldDataStore")

-- Constants
local ISLAND_REGISTRY = {
    ["HubIsland"] = {
        Name = "Central Hub",
        Biome = "Urban",
        SpawnPoint = Vector3.new(0, 10, 0),
        Unlocked = true,
        MaxPlayers = 50,
        CurrentPlayers = 0,
        Events = {},
    },

    ["ForestIsland"] = {
        Name = "Whispering Woods",
        Biome = "Forest",
        SpawnPoint = Vector3.new(100, 5, 100),
        Unlocked = false,
        MaxPlayers = 20,
        CurrentPlayers = 0,
        Events = {
            {
                Name = "Autumn Festival",
                StartTime = 1633040000, -- Oct 1, 2021
                EndTime = 1635728000, -- Oct 31, 2021
                Active = false,
            },
        },
    },

    ["MountainIsland"] = {
        Name = "Peak Haven",
        Biome = "Mountain",
        SpawnPoint = Vector3.new(-50, 20, -50),
        Unlocked = false,
        MaxPlayers = 15,
        CurrentPlayers = 0,
        Events = {},
    },

    ["OceanIsland"] = {
        Name = "Tidecaller's Reef",
        Biome = "Ocean",
        SpawnPoint = Vector3.new(0, 0, -100),
        Unlocked = false,
        MaxPlayers = 10,
        CurrentPlayers = 0,
        Events = {
            {
                Name = "Moonlit Tides",
                StartTime = 1630000000, -- Sep 1, 2021
                EndTime = 1632640000, -- Sep 30, 2021
                Active = false,
            },
        },
    },

    ["VolcanoIsland"] = {
        Name = "Ember Peak",
        Biome = "Volcanic",
        SpawnPoint = Vector3.new(50, 15, 50),
        Unlocked = false,
        MaxPlayers = 8,
        CurrentPlayers = 0,
        Events = {},
    },

    ["MinorIsland1"] = {
        Name = "Hidden Cove",
        Biome = "Coastal",
        SpawnPoint = Vector3.new(-100, 2, -100),
        Unlocked = false,
        MaxPlayers = 5,
        CurrentPlayers = 0,
        Events = {},
    },
}

-- Module exports
local WorldManager = {}

-- Private functions
local function loadWorldData()
    local success, err = pcall(function()
        local data = WorldDataStore:GetAsync("WorldState")
        if not data then
            data = {}
        end

        -- Merge with default registry
        for islandId, islandData in pairs(ISLAND_REGISTRY) do
            if not data[islandId] then
                data[islandId] = islandData
            else
                -- Merge existing data with defaults
                for key, value in pairs(islandData) do
                    if typeof(data[islandId][key]) == "nil" then
                        data[islandId][key] = value
                    end
                end
            end
        end

        WorldDataStore:SetAsync("WorldState", data)
        return data
    end)

    if not success then
        warn("Failed to load world data: " .. err)
        return nil
    end

    return err
end

local function saveWorldData()
    local success, err = pcall(function()
        WorldDataStore:SetAsync("WorldState", ISLAND_REGISTRY)
    end)

    if not success then
        warn("Failed to save world data: " .. err)
        return false
    end
    return true
end

local function checkIslandEvent(islandId, currentTime)
    local island = ISLAND_REGISTRY[islandId]
    if not island then
        return false
    end

    for _, event in pairs(island.Events) do
        if currentTime >= event.StartTime and currentTime <= event.EndTime then
            event.Active = true
            return true
        end
    end

    return false
end

-- Public functions
function WorldManager:Initialize()
    -- Load world data
    ISLAND_REGISTRY = loadWorldData() or ISLAND_REGISTRY

    -- Setup player connections
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            local humanoid = character:WaitForChild("Humanoid")

            -- Check for island events on spawn
            local currentTime = os.time()
            for islandId, island in pairs(ISLAND_REGISTRY) do
                if checkIslandEvent(islandId, currentTime) then
                    -- TODO: Notify player about active events
                    print("Player " .. player.Name .. " spawned on island with active event: " .. island.Name)
                end
            end
        end)
    end)

    -- Setup periodic checks for events
    local eventCheckConnection = RunService.Heartbeat:Connect(function()
        local currentTime = os.time()

        for islandId, island in pairs(ISLAND_REGISTRY) do
            if checkIslandEvent(islandId, currentTime) then
                -- Event is active, check if it was previously inactive
                local eventActive = false
                for _, event in pairs(island.Events) do
                    if event.Active then
                        eventActive = true
                        break
                    end
                end

                if not eventActive then
                    -- TODO: Notify players about new active event
                    print("New event active on island: " .. island.Name)
                end
            end
        end
    end)

    -- Clean up connection on shutdown
    game:GetService("RunService"):BindToClose(function()
        eventCheckConnection:Disconnect()
    end)
end

function WorldManager:GetSpawnPoint(islandId)
    local island = ISLAND_REGISTRY[islandId]
    if not island then
        warn("Island not found: " .. islandId)
        return nil
    end

    return island.SpawnPoint
end

function WorldManager:IsIslandUnlocked(islandId)
    local island = ISLAND_REGISTRY[islandId]
    if not island then
        warn("Island not found: " .. islandId)
        return false
    end

    return island.Unlocked
end

function WorldManager:UnlockIsland(islandId)
    local island = ISLAND_REGISTRY[islandId]
    if not island then
        warn("Island not found: " .. islandId)
        return false
    end

    island.Unlocked = true
    saveWorldData()
    return true
end

function WorldManager:GetIslandInfo(islandId)
    local island = ISLAND_REGISTRY[islandId]
    if not island then
        warn("Island not found: " .. islandId)
        return nil
    end

    return island
end

function WorldManager:GetPlayerCount(islandId)
    local island = ISLAND_REGISTRY[islandId]
    if not island then
        warn("Island not found: " .. islandId)
        return 0
    end

    return island.CurrentPlayers
end

function WorldManager:UpdatePlayerCount(islandId, delta)
    local island = ISLAND_REGISTRY[islandId]
    if not island then
        warn("Island not found: " .. islandId)
        return false
    end

    island.CurrentPlayers = math.clamp(island.CurrentPlayers + delta, 0, island.MaxPlayers)
    saveWorldData()
    return true
end

function WorldManager:CanFastTravel(player, islandId)
    -- Check if island is unlocked
    if not self:IsIslandUnlocked(islandId) then
        return false, "Island not unlocked"
    end

    -- Check cooldowns
    local profile = PlayerDataService:LoadProfile(player)
    if not profile then
        return false, "Failed to load player profile"
    end

    local cooldown = profile.FastTravel.Cooldowns[islandId]
    if cooldown and cooldown > os.time() then
        return false, "Fast travel cooldown active"
    end

    -- Check player count
    if self:GetPlayerCount(islandId) >= ISLAND_REGISTRY[islandId].MaxPlayers then
        return false, "Island at maximum capacity"
    end

    return true, "Can fast travel"
end

-- Return module
WorldManager.__index = WorldManager
return setmetatable(WorldManager, {
    __call = function(self, ...)
        return self:Initialize(...)
    end,
})
