--
-- Events.luau
-- Event system module for Aether Harvester Simulator
--

local Events = {}

-- Constants
local EVENT_DURATION = 3600 -- 1 hour in seconds
local MAX_PARTICIPANTS = 50
local EVENT_RANGE = 100 -- studs

--[[
    EVENT STRUCTURE:
    {
        name = "EventName",
        displayName = "Display Name",
        description = "Event description.",
        type = Enum.EventType,
        category = Enum.EventCategory,
        startTime = os.time(),
        endTime = os.time(),
        location = Vector3.new(0, 0, 0),
        participants = {
            {
                player = nil,
                joinedAt = os.time()
            }
        },
        rewards = {
            {
                type = Enum.RewardType,
                value = 100,
                itemName = "ItemName",
                quantity = 5,
                currency = "Gold",
                xp = 1000
            }
        },
        status = "scheduled",
        requirements = {
            {
                type = Enum.RequirementType,
                value = 5,
                itemName = "ItemName",
                level = 3
            }
        }
    }
]]

-- Event type enum
local EventType = Enum.create("EventType", {
    Combat = 1,
    Crafting = 2,
    Exploration = 3,
    Social = 4,
    Survival = 5,
    PvP = 6
})

-- Event category enum
local EventCategory = Enum.create("EventCategory", {
    Daily = 1,
    Weekly = 2,
    Monthly = 3,
    Special = 4
})

-- Initialize event system
function Events.New()
    return {
        events = {},
        participants = {}
    }
end

-- Create a new event
function Events:CreateEvent(eventData)
    if not eventData then
        warn("No event data provided.")
        return false
    end
    
    -- Validate event data
    if not eventData.name or not eventData.displayName or not eventData.description then
        warn("Invalid event data.")
        return false
    end
    
    -- Set default values
    eventData.startTime = eventData.startTime or os.time()
    eventData.endTime = eventData.startTime + EVENT_DURATION
    eventData.location = eventData.location or Vector3.new(0, 0, 0)
    eventData.status = eventData.status or "scheduled"
    eventData.participants = eventData.participants or {}
    eventData.rewards = eventData.rewards or {}
    eventData.requirements = eventData.requirements or {}
    
    -- Add event to the list
    table.insert(self.events, eventData)
    
    return true, "Event created successfully."
end

-- Schedule an event
function Events:ScheduleEvent(eventName, startTime, duration)
    local event = self:GetEvent(eventName)
    if not event then
        warn(string.format("Event %s not found.", eventName))
        return false, string.format("Event %s not found.", eventName)
    end
    
    -- Set event time
    event.startTime = startTime or os.time()
    event.endTime = event.startTime + (duration or EVENT_DURATION)
    event.status = "scheduled"
    
    return true, "Event scheduled successfully."
end

-- Start an event
function Events:StartEvent(eventName)
    local event = self:GetEvent(eventName)
    if not event then
        warn(string.format("Event %s not found.", eventName))
        return false, string.format("Event %s not found.", eventName)
    end
    
    -- Check if event is scheduled
    if event.status ~= "scheduled" then
        return false, "Event is not scheduled."
    end
    
    -- Check if event time has arrived
    if os.time() < event.startTime then
        return false, "Event has not started yet."
    end
    
    -- Start event
    event.status = "active"
    
    -- Notify players
    self:NotifyPlayers(eventName)
    
    return true, "Event started successfully."
end

-- End an event
function Events:EndEvent(eventName)
    local event = self:GetEvent(eventName)
    if not event then
        warn(string.format("Event %s not found.", eventName))
        return false, string.format("Event %s not found.", eventName)
    end
    
    -- Check if event is active
    if event.status ~= "active" then
        return false, "Event is not active."
    end
    
    -- Check if event time has passed
    if os.time() > event.endTime then
        event.status = "completed"
    else
        return false, "Event has not ended yet."
    end
    
    -- Distribute rewards
    self:DistributeRewards(eventName)
    
    -- Notify players
    self:NotifyPlayers(eventName)
    
    return true, "Event ended successfully."
end

-- Participate in an event
function Events:Participate(eventName, player)
    local event = self:GetEvent(eventName)
    if not event then
        warn(string.format("Event %s not found.", eventName))
        return false, string.format("Event %s not found.", eventName)
    end
    
    -- Check if event is active
    if event.status ~= "active" then
        return false, "Event is not active."
    end
    
    -- Check if player already participated
    for _, participant in ipairs(event.participants) do
        if participant.player == player then
            return false, "Player already participated in this event."
        end
    end
    
    -- Check if player meets requirements
    for _, requirement in ipairs(event.requirements or {}) do
        if requirement.type == Enum.RequirementType.Item then
            local inventory = player:GetAttribute("Inventory") or Inventory.New()
            if inventory:GetItemCount(requirement.itemName) < requirement.value then
                return false, string.format("Player does not meet requirement: %d %s needed.", requirement.value, requirement.itemName)
            end
        elseif requirement.type == Enum.RequirementType.Level then
            local progression = player:GetAttribute("Progression") or Progression.New()
            if progression:GetLevel() < requirement.value then
                return false, string.format("Player does not meet requirement: level %d needed.", requirement.value)
            end
        end
    end
    
    -- Add player to participants
    table.insert(event.participants, {
        player = player,
        joinedAt = os.time()
    })
    
    return true, "Player participated in event successfully."
end

-- Distribute rewards for an event
function Events:DistributeRewards(eventName)
    local event = self:GetEvent(eventName)
    if not event then
        warn(string.format("Event %s not found.", eventName))
        return false
    end
    
    -- Check if event is completed
    if event.status ~= "completed" then
        warn(string.format("Event %s is not completed.", eventName))
        return false
    end
    
    -- Distribute rewards to participants
    for _, participant in ipairs(event.participants) do
        local rewards = event.rewards or {}
        for _, reward in ipairs(rewards) do
            local inventory = participant.player:GetAttribute("Inventory") or Inventory.New()
            
            if reward.type == Enum.RewardType.Currency then
                inventory:AddCurrency(reward.currency, reward.value)
            elseif reward.type == Enum.RewardType.XP then
                local progression = participant.player:GetAttribute("Progression") or Progression.New()
                progression:AddXP(reward.value)
            elseif reward.type == Enum.RewardType.Item then
                inventory:AddItem(reward.itemName, reward.quantity)
            end
        end
    end
    
    return true
end

-- Get event by name
function Events:GetEvent(eventName)
    for _, event in ipairs(self.events) do
        if event.name == eventName then
            return event
        end
    end
    return nil
end

-- Get all events
function Events:GetAllEvents()
    return self.events
end

-- Get active events
function Events:GetActiveEvents()
    local activeEvents = {}
    for _, event in ipairs(self.events) do
        if event.status == "active" then
            table.insert(activeEvents, event)
        end
    end
    return activeEvents
end

-- Get events by type
function Events:GetEventsByType(eventType)
    local events = {}
    for _, event in ipairs(self.events) do
        if event.type == eventType then
            table.insert(events, event)
        end
    end
    return events
end

-- Get events by category
function Events:GetEventsByCategory(eventCategory)
    local events = {}
    for _, event in ipairs(self.events) do
        if event.category == eventCategory then
            table.insert(events, event)
        end
    end
    return events
end

-- Get events by status
function Events:GetEventsByStatus(status)
    local events = {}
    for _, event in ipairs(self.events) do
        if event.status == status then
            table.insert(events, event)
        end
    end
    return events
end

-- Check if player is in event range
function Events:IsPlayerInEventRange(player, event)
    if not player.Character or not event.location then
        return false
    end
    
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then
        return false
    end
    
    local distance = (rootPart.Position - event.location).Magnitude
    return distance <= EVENT_RANGE
end

-- Notify players about event status
function Events:NotifyPlayers(eventName)
    local event = self:GetEvent(eventName)
    if not event then
        warn(string.format("Event %s not found.", eventName))
        return false
    end
    
    local message = string.format("Event %s status: %s", event.displayName, event.status)
    
    -- Notify all players
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            local leaderboard = player.Character:FindFirstChildOfClass("ScreenGui"):FindFirstChild("Leaderboard")
            if leaderboard then
                local textLabel = leaderboard:FindFirstChild("TextLabel")
                if textLabel then
                    textLabel.Text = message
                end
            end
        end
    end
    
    return true
end

-- Get participants for an event
function Events:GetParticipants(eventName)
    local event = self:GetEvent(eventName)
    if not event then
        warn(string.format("Event %s not found.", eventName))
        return nil
    end
    return event.participants or {}
end

return Events