--
-- PlayerDataService.lua
-- Handles player profile creation, initial setup, tutorial tracking, and data validation.
--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

-- DataStore setup
local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

-- Constants
local DEFAULT_INVENTORY = {
    ["StarterPickaxe"] = 1,
    ["StarterTorch"] = 1,
    ["StarterHealthPotion"] = 3
}

local HUB_ISLAND_ID = "HubIsland"
local TUTORIAL_QUEST_ID = "TutorialQuest"

-- Module exports
local PlayerDataService = {}

-- Private functions
local function createDefaultProfile(player)
    local profile = {
        Character = nil,
        Inventory = table.clone(DEFAULT_INVENTORY),
        Stats = {
            Level = 1,
            Experience = 0,
            Health = 100,
            MaxHealth = 100
        },
        Tutorial = {
            CompletedSteps = {},
            QuestCompleted = false
        },
        FastTravel = {
            Cooldowns = {},
            UnlockedIslands = {HUB_ISLAND_ID}
        },
        LastSpawnPoint = HUB_ISLAND_ID
    }
    
    return profile
end

local function validateProfileData(data)
    -- Validate required fields
    if not data.Character or not data.Inventory or not data.Stats or not data.Tutorial or not data.FastTravel then
        warn("Invalid profile data: missing required fields")
        return false
    end
    
    -- Validate inventory
    for item, count in pairs(data.Inventory) do
        if typeof(count) ~= "number" or count < 0 then
            warn("Invalid inventory data for item: " .. item)
            return false
        end
    end
    
    -- Validate stats
    if typeof(data.Stats.Level) ~= "number" or data.Stats.Level < 1 then
        warn("Invalid level in stats")
        return false
    end
    
    if typeof(data.Stats.Experience) ~= "number" or data.Stats.Experience < 0 then
        warn("Invalid experience in stats")
        return false
    end
    
    if typeof(data.Stats.Health) ~= "number" or data.Stats.Health < 0 then
        warn("Invalid health in stats")
        return false
    end
    
    if typeof(data.Stats.MaxHealth) ~= "number" or data.Stats.MaxHealth <= 0 then
        warn("Invalid max health in stats")
        return false
    end
    
    -- Validate tutorial
    if typeof(data.Tutorial.CompletedSteps) ~= "table" then
        warn("Invalid tutorial data: CompletedSteps must be a table")
        return false
    end
    
    if typeof(data.Tutorial.QuestCompleted) ~= "boolean" then
        warn("Invalid tutorial data: QuestCompleted must be a boolean")
        return false
    end
    
    -- Validate fast travel
    if typeof(data.FastTravel.Cooldowns) ~= "table" then
        warn("Invalid fast travel data: Cooldowns must be a table")
        return false
    end
    
    if typeof(data.FastTravel.UnlockedIslands) ~= "table" then
        warn("Invalid fast travel data: UnlockedIslands must be a table")
        return false
    end
    
    return true
end

local function saveProfile(player, profile)
    local success, err = pcall(function()
        local data = PlayerDataStore:GetAsync(player.UserId)
        if not data then
            data = {}
        end
        data[player.UserId] = profile
        PlayerDataStore:SetAsync(player.UserId, data)
    end)
    
    if not success then
        warn("Failed to save profile: " .. err)
        return false
    end
    return true
end

local function loadProfile(player)
    local success, err = pcall(function()
        local data = PlayerDataStore:GetAsync(player.UserId)
        if not data then
            return nil
        end
        
        local profile = data[player.UserId]
        if not profile then
            return nil
        end
        
        if not validateProfileData(profile) then
            warn("Invalid profile data for player: " .. player.UserId)
            return nil
        end
        
        return profile
    end)
    
    if not success then
        warn("Failed to load profile: " .. err)
        return nil
    end
    return err
end

-- Public functions
function PlayerDataService:Initialize()
    Players.PlayerAdded:Connect(function(player)
        player:WaitForChild("PlayerGui")
        
        -- Load existing profile or create new one
        local profile = loadProfile(player)
        if not profile then
            profile = createDefaultProfile(player)
            saveProfile(player, profile)
        end
        
        -- Assign initial spawn point
        self:AssignSpawnPoint(player, HUB_ISLAND_ID)
        
        -- Trigger tutorial
        self:TriggerTutorial(player)
        
        -- Grant default inventory
        self:GrantDefaultInventory(player)
        
        -- Send welcome message and first quest
        self:SendWelcomeMessage(player)
        self:AssignFirstQuest(player)
    end)
end

function PlayerDataService:AssignSpawnPoint(player, islandId)
    local profile = loadProfile(player)
    if not profile then
        warn("Failed to assign spawn point: invalid profile")
        return
    end
    
    profile.LastSpawnPoint = islandId
    saveProfile(player, profile)
    
    -- TODO: Implement actual spawn logic
    print("Spawn point assigned to " .. player.Name .. " on island: " .. islandId)
end

function PlayerDataService:TriggerTutorial(player)
    local profile = loadProfile(player)
    if not profile then
        warn("Failed to trigger tutorial: invalid profile")
        return
    end
    
    -- Check if tutorial is already completed
    if profile.Tutorial.QuestCompleted then
        return
    end
    
    -- Fire tutorial event
    local tutorialEvent = ReplicatedStorage:WaitForChild("TutorialEvents"):WaitForChild("TutorialTriggered")
    tutorialEvent:FireClient(player)
    
    -- Log tutorial start
    print("Tutorial triggered for player: " .. player.Name)
end

function PlayerDataService:GrantDefaultInventory(player)
    local profile = loadProfile(player)
    if not profile then
        warn("Failed to grant default inventory: invalid profile")
        return
    end
    
    -- Fire inventory grant event
    local inventoryEvent = ReplicatedStorage:WaitForChild("InventoryEvents"):WaitForChild("GrantDefaultItems")
    inventoryEvent:FireClient(player, profile.Inventory)
    
    -- Log inventory grant
    print("Default inventory granted to player: " .. player.Name)
end

function PlayerDataService:SendWelcomeMessage(player)
    local welcomeMessage = "Welcome to Aether Harvester Simulator! You have been granted starter tools and a tutorial quest."
    print(welcomeMessage)
    
    -- TODO: Implement client-side welcome message display
end

function PlayerDataService:AssignFirstQuest(player)
    local profile = loadProfile(player)
    if not profile then
        warn("Failed to assign first quest: invalid profile")
        return
    end
    
    -- Fire quest assignment event
    local questEvent = ReplicatedStorage:WaitForChild("QuestEvents"):WaitForChild("AssignFirstQuest")
    questEvent:FireClient(player, TUTORIAL_QUEST_ID)
    
    -- Log quest assignment
    print("First quest assigned to player: " .. player.Name)
end

-- Return module
PlayerDataService.__index = PlayerDataService
return setmetatable(PlayerDataService, {__call = function(self, ...) return self:Initialize(...) end})