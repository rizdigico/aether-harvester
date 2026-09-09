local AnalyticsService = {}
AnalyticsService.Events = {}
AnalyticsService.PlayerStats = {}

function AnalyticsService.Initialize()
    print("[AnalyticsService] Initializing...")

    -- Track player join/leave
    game.Players.PlayerAdded:Connect(function(player)
        AnalyticsService:TrackEvent("player_joined", player.UserId, {
            Username = player.Name,
            Timestamp = os.time(),
        })
    end)

    game.Players.PlayerRemoving:Connect(function(player)
        AnalyticsService:TrackEvent("player_left", player.UserId, {
            Playtime = os.time()
                - (
                    AnalyticsService.PlayerStats[player.UserId]
                        and AnalyticsService.PlayerStats[player.UserId].JoinTime
                    or os.time()
                ),
        })
    end)
end

function AnalyticsService:TrackEvent(eventName, playerId, data)
    local event = {
        Name = eventName,
        PlayerId = playerId,
        Data = data or {},
        Timestamp = os.time(),
    }

    table.insert(AnalyticsService.Events, event)

    -- Keep only last 10000 events
    while #AnalyticsService.Events > 10000 do
        table.remove(AnalyticsService.Events, 1)
    end

    -- In production, this would send to an analytics service
    -- For now, just log important events
    if eventName == "player_joined" or eventName == "purchase" or eventName == "level_up" then
        print("[Analytics] " .. eventName .. " - Player: " .. playerId)
    end
end

function AnalyticsService:TrackPlayerAction(player, action, data)
    if not AnalyticsService.PlayerStats[player.UserId] then
        AnalyticsService.PlayerStats[player.UserId] = {
            JoinTime = os.time(),
            Actions = {},
        }
    end

    local stats = AnalyticsService.PlayerStats[player.UserId]
    stats.Actions[action] = (stats.Actions[action] or 0) + 1

    self:TrackEvent("player_action", player.UserId, {
        Action = action,
        Count = stats.Actions[action],
        Data = data,
    })
end

function AnalyticsService.GetPlayerStats(playerId)
    return AnalyticsService.PlayerStats[playerId]
end

function AnalyticsService.GetEventCount(eventName)
    local count = 0
    for _, event in ipairs(AnalyticsService.Events) do
        if event.Name == eventName then
            count += 1
        end
    end
    return count
end

return AnalyticsService
