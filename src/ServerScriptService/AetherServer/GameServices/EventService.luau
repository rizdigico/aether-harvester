--
-- EventService.luau
-- Manages scheduled in-game events, notifications, and rewards
--

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local DataStoreService = require(script.Parent.DataStoreService)

-- Define events (example structure)
local EVENTS = {
    ["WeeklyHarvestBonus"] = {
        name = "Weekly Harvest Bonus",
        description = "Harvest 20% more resources this week.",
        startTime = 0, -- Will be set dynamically
        endTime = 0, -- Will be set dynamically
        active = false,
        rewards = {
            xp = 500,
            items = {
                {
                    itemId = "HarvestingBoost",
                    quantity = 1,
                },
            },
        },
    },
    ["CreatureBattle"] = {
        name = "Creature Battle Tournament",
        description = "Test your creature skills in a battle tournament.",
        startTime = 0, -- Will be set dynamically
        endTime = 0, -- Will be set dynamically
        active = false,
        rewards = {
            xp = 1000,
            items = {
                {
                    itemId = "BattleReward",
                    quantity = 1,
                },
            },
        },
    },
}

-- Function to initialize events
local function initializeEvents()
    -- Set start and end times for events
    for eventId, eventData in pairs(EVENTS) do
        eventData.startTime = tick() + 3600 -- Start in 1 hour
        eventData.endTime = eventData.startTime + 86400 -- End in 24 hours
    end

    -- Start event timers
    startEventTimers()
end

-- Function to start event timers
local function startEventTimers()
    for eventId, eventData in pairs(EVENTS) do
        eventData.timer = RunService:CreateConnection(function()
            local currentTime = tick()
            if currentTime >= eventData.startTime and not eventData.active then
                eventData.active = true
                -- Notify players that the event has started
                notifyPlayersAboutEvent(eventId, "started")
            elseif currentTime >= eventData.endTime and eventData.active then
                eventData.active = false
                -- Notify players that the event has ended
                notifyPlayersAboutEvent(eventId, "ended")
            end
        end)
    end
end

-- Function to notify players about events
local function notifyPlayersAboutEvent(eventId: string, eventType: string)
    local eventData = EVENTS[eventId]
    if not eventData then
        warn("Event not found: " .. eventId)
        return
    end

    local message = ""
    if eventType == "started" then
        message = "Event started: " .. eventData.name .. "\n" .. eventData.description
    elseif eventType == "ended" then
        message = "Event ended: " .. eventData.name
    end

    -- Notify all players
    for _, player in ipairs(Players:GetPlayers()) do
        game:GetService("ReplicatedStorage"):FindFirstChild("EventNotification"):FireClient(player, eventId, message)
    end
end

-- Function to give event rewards to players
local function giveEventRewards(player: Player, eventId: string)
    local eventData = EVENTS[eventId]
    if not eventData then
        warn("Event not found: " .. eventId)
        return false, "Event not found."
    end

    if not eventData.active then
        return false, "Event is not active."
    end

    -- Give XP
    local xpReward = eventData.rewards.xp or 0
    if xpReward > 0 then
        local playerData = player:GetAttribute("PlayerData") or {}
        local progressionData = playerData.Progression or {}
        progressionData.xp = (progressionData.xp or 0) + xpReward
        playerData.Progression = progressionData
        DataStoreService.savePlayerData(player, {
            Progression = progressionData,
        })
    end

    -- Give items
    local itemsReward = eventData.rewards.items or {}
    for _, item in pairs(itemsReward) do
        local playerData = player:GetAttribute("PlayerData") or {}
        local inventoryData = playerData.Inventory or {}
        inventoryData[item.itemId] = (inventoryData[item.itemId] or 0) + item.quantity
        playerData.Inventory = inventoryData
        DataStoreService.savePlayerData(player, {
            Inventory = inventoryData,
        })
    end

    return true, "Event rewards given."
end

-- Function to handle remote events for event participation
local function handleEventParticipation(player: Player, eventId: string)
    local success, message = giveEventRewards(player, eventId)
    if success then
        game:GetService("ReplicatedStorage")
            :FindFirstChild("EventNotification")
            :FireClient(player, eventId, "rewards_received", message)
    else
        warn("Failed to give event rewards: " .. message)
    end
end

-- Initialize events
initializeEvents()

-- Connect to remote events
local eventNotification = game:GetService("ReplicatedStorage"):FindFirstChild("EventNotification")
if eventNotification then
    eventNotification.OnServerEvent:Connect(function(player, eventId, action)
        if action == "participate" then
            handleEventParticipation(player, eventId)
        end
    end)
end

-- Export functions for use by other modules
return {
    initializeEvents = initializeEvents,
    notifyPlayersAboutEvent = notifyPlayersAboutEvent,
    giveEventRewards = giveEventRewards,
}
