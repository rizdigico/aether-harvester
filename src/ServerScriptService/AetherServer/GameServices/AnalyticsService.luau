local AnalyticsService = {}
AnalyticsService.Events = {}
AnalyticsService.PlayerStats = {}
local Players = game:GetService("Players")
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local SessionMetrics = require(game.ReplicatedStorage.AetherShared.Modules.SessionMetrics)

local function ensurePlayerStats(player)
    local stats = AnalyticsService.PlayerStats[player.UserId]
    if not stats then
        stats = {
            JoinTime = os.time(),
            Actions = {},
        }
        AnalyticsService.PlayerStats[player.UserId] = stats
    end
    return stats
end

local function trackPlayerJoined(player)
    local stats = ensurePlayerStats(player)
    AnalyticsService:TrackEvent("player_joined", player.UserId, {
        Username = player.Name,
        Timestamp = stats.JoinTime,
    })
end

function AnalyticsService.Initialize()
    print("[AnalyticsService] Initializing...")

    -- Track player join/leave
    Players.PlayerAdded:Connect(trackPlayerJoined)

    -- ServerMain also handles players already present when a script reloads.
    -- Seed their sessions here so leave analytics and playtime remain correct.
    for _, player in ipairs(Players:GetPlayers()) do
        trackPlayerJoined(player)
    end
end

function AnalyticsService:TrackEvent(eventName, playerId, data)
    if type(eventName) ~= "string" or eventName == "" or #eventName > 64 then
        return false
    end
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
        print("[Analytics] " .. eventName .. " - Player: " .. tostring(playerId))
    end
    return true
end

function AnalyticsService:TrackPlayerAction(player, action, data)
    if type(action) ~= "string" or action == "" or #action > 64 then
        return false
    end

    local stats = ensurePlayerStats(player)
    stats.Actions[action] = (stats.Actions[action] or 0) + 1

    self:TrackEvent("player_action", player.UserId, {
        Action = action,
        Count = stats.Actions[action],
        Data = data,
    })
    return true
end

function AnalyticsService.OnPlayerRemoving(player)
    local stats = AnalyticsService.PlayerStats[player.UserId]
    local now = os.time()
    local playtimeSeconds = SessionMetrics.GetElapsedSeconds(now, stats and stats.JoinTime or now)
    local playtimeMinutes = SessionMetrics.GetElapsedMinutes(now, stats and stats.JoinTime or now)
    if playtimeMinutes > 0 then
        PlayerDataService.IncrementStat(player, "PlaytimeMinutes", playtimeMinutes)
    end
    AnalyticsService:TrackEvent("player_left", player.UserId, {
        Playtime = playtimeSeconds,
    })
    AnalyticsService.PlayerStats[player.UserId] = nil
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
