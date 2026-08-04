--
-- DataStoreService.luau
-- Handles saving and loading player data for Aether Harvester Simulator
--

local DataStoreService = game:GetService("DataStoreService")

-- Define DataStores for different player data types
local PLAYER_DATA_STORE = DataStoreService:GetDataStore("PlayerDataStore")

-- Define player data keys
local PLAYER_DATA_KEYS = {
    Inventory = "inventory",
    Progression = "progression",
    Creatures = "creatures",
    Quests = "quests",
    Trading = "trading",
}

-- Function to save player data
local function savePlayerData(player: Player, data: table)
    local success, err = pcall(function()
        local playerData = PLAYER_DATA_STORE:GetAsync(player.UserId)
        if playerData == nil then
            playerData = {}
        end
        -- Merge new data with existing data
        for key, value in pairs(data) do
            playerData[PLAYER_DATA_KEYS[key]] = value
        end
        -- Save updated data
        PLAYER_DATA_STORE:SetAsync(player.UserId, playerData)
    end)

    if not success then
        warn("Failed to save player data: " .. tostring(err))
    end
end

-- Function to load player data
local function loadPlayerData(player: Player)
    local success, err = pcall(function()
        local playerData = PLAYER_DATA_STORE:GetAsync(player.UserId)
        if playerData == nil then
            playerData = {}
        end
        return playerData
    end)

    if not success then
        warn("Failed to load player data: " .. tostring(err))
        return {}
    end
    return playerData
end

-- Function to delete player data (e.g., for testing)
local function deletePlayerData(player: Player)
    local success, err = pcall(function()
        PLAYER_DATA_STORE:RemoveAsync(player.UserId)
    end)

    if not success then
        warn("Failed to delete player data: " .. tostring(err))
    end
end

-- Event listener for when a player joins
local function onPlayerAdded(player: Player)
    -- Load player data when they join
    local playerData = loadPlayerData(player)
    player:SetAttribute("PlayerData", playerData)

    -- Save player data when they leave
    player.CharacterAdded:Connect(function()
        player.CharacterRemoving:Connect(function()
            -- Example: Save data on character removal
            -- In a real implementation, you would save data on specific actions
        end)
    end)

    -- Example: Save data on player disconnect
    player.CharacterRemoving:Connect(function()
        -- This is a placeholder; actual saving should be done on specific actions
    end)
end

-- Connect to player added event
game.Players.PlayerAdded:Connect(onPlayerAdded)

-- Load existing players
for _, player in ipairs(game.Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Export functions for use by other modules
return {
    savePlayerData = savePlayerData,
    loadPlayerData = loadPlayerData,
    deletePlayerData = deletePlayerData,
}
