local EventService = {}
local EventMath = require(game.ReplicatedStorage.AetherShared.Modules.EventMath)
EventService.ActiveEvents = {}
EventService.EventIdCounter = 1

function EventService.Initialize()
    print("[EventService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    local GetActiveEvents = Remotes and Remotes:FindFirstChild("GetActiveEvents")
    if GetActiveEvents then
        GetActiveEvents.OnServerInvoke = function(_player)
            return EventService.GetActiveEvents()
        end
    end

    -- Start event loop (background task so Initialize returns immediately)
    task.spawn(function()
        EventService:StartEventLoop()
    end)
end

function EventService:StartEventLoop()
    -- Check for events every 5 minutes
    while true do
        task.wait(300)
        self:CheckAndStartEvents()
    end
end

function EventService:CheckAndStartEvents()
    -- 30% chance to start a new event
    if math.random() < 0.3 then
        self:StartRandomEvent()
    end
end

function EventService:StartRandomEvent()
    local eventTypes = {
        "DoubleXP",
        "ResourceRush",
        "PetWeekend",
        "GuildWars",
        "HarvestFestival",
    }

    local eventType = eventTypes[math.random(1, #eventTypes)]
    local eventId = "EVENT_" .. EventService.EventIdCounter
    EventService.EventIdCounter += 1

    local event = {
        Id = eventId,
        Type = eventType,
        StartTime = os.time(),
        Duration = 3600, -- 1 hour
        Active = true,
    }

    EventService.ActiveEvents[eventId] = event

    -- Notify all players
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local EventStarted = Remotes:FindFirstChild("EventStarted")
        if EventStarted then
            EventStarted:FireAllClients(event)
        end
    end

    print("[EventService] Event started: " .. eventType)

    -- End event after duration
    task.delay(event.Duration, function()
        event.Active = false
        EventService.ActiveEvents[eventId] = nil

        if Remotes then
            local EventEnded = Remotes:FindFirstChild("EventEnded")
            if EventEnded then
                EventEnded:FireAllClients(eventId)
            end
        end

        print("[EventService] Event ended: " .. eventType)
    end)
end

function EventService.GetActiveEvents()
    local events = {}
    for _, event in pairs(EventService.ActiveEvents) do
        if event.Active then
            table.insert(events, event)
        end
    end
    return events
end

function EventService.GetEventBonus(eventType)
    return EventMath.GetBonus(eventType)
end

-- True if at least one event is currently active
function EventService.IsEventActive()
    return next(EventService.ActiveEvents) ~= nil
end

-- Combined gameplay multiplier from all active events (1.0 if none).
-- Only yield-affecting events contribute (ResourceRush, HarvestFestival).
function EventService.GetActiveYieldMultiplier()
    return EventMath.GetYieldMultiplier(EventService.ActiveEvents)
end

-- Combined XP multiplier from all active XP-affecting events.
function EventService.GetActiveXPMultiplier()
    return EventMath.GetXPMultiplier(EventService.ActiveEvents)
end

return EventService
