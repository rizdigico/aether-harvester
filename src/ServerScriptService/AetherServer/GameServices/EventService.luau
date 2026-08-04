local EventService = {}
local RunService = game:GetService("RunService")

EventService.ActiveEvents = {}
EventService.EventIdCounter = 1

function EventService.Initialize()
    print("[EventService] Initializing...")

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
    local bonuses = {
        ["DoubleXP"] = 2.0,
        ["ResourceRush"] = 1.5,
        ["PetWeekend"] = 1.3,
        ["GuildWars"] = 1.0,
        ["HarvestFestival"] = 1.5,
    }
    return bonuses[eventType] or 1.0
end

return EventService
