local LeaderboardService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)

LeaderboardService.Leaderboards = {
    ["Level"] = {},
    ["Wealth"] = {},
    ["Pets"] = {},
    ["Quests"] = {},
}

local CATEGORIES = { "Level", "Wealth", "Pets", "Quests" }

local function isCategory(category)
    return type(category) == "string" and LeaderboardService.Leaderboards[category] ~= nil
end

function LeaderboardService.Initialize()
    print("[LeaderboardService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- GetLeaderboard: fetch top players for a category
    local GetLeaderboard = Remotes:FindFirstChild("GetLeaderboard")
    if GetLeaderboard then
        GetLeaderboard.OnServerInvoke = function(player, category, count)
            if not RateLimiter.Check(player, "GetLeaderboard", 0.5) then
                return {}
            end
            if not isCategory(category) then
                return {}
            end
            local requestedCount = type(count) == "number" and count or 10
            if requestedCount ~= requestedCount then
                requestedCount = 10
            end
            return LeaderboardService.GetTopPlayers(category, requestedCount)
        end
    end

    -- RequestLeaderboard: push leaderboard updates to the client
    local RequestLeaderboard = Remotes:FindFirstChild("RequestLeaderboard")
    if RequestLeaderboard then
        RequestLeaderboard.OnServerEvent:Connect(function(player, category)
            if not RateLimiter.Check(player, "RequestLeaderboard", 0.5) then
                return
            end
            if not isCategory(category) then
                return
            end
            local LeaderboardUpdated = Remotes:FindFirstChild("LeaderboardUpdated")
            if LeaderboardUpdated then
                LeaderboardUpdated:FireClient(player, category, LeaderboardService.GetTopPlayers(category, 10))
            end
        end)
    end

    -- Keep the in-server view current without refreshing on every mutation.
    -- A later global OrderedDataStore adapter can consume the same snapshots.
    task.spawn(function()
        while true do
            task.wait(30)
            for _, player in ipairs(game.Players:GetPlayers()) do
                LeaderboardService.UpdateAll(player)
            end
        end
    end)

    print("[LeaderboardService] Initialized")
end

function LeaderboardService.UpdateLeaderboard(player, category)
    if not isCategory(category) then
        return
    end
    local data = PlayerDataService.GetData(player)
    if not data then
        return
    end

    local value = 0
    if category == "Level" then
        value = data.Level or 1
    elseif category == "Wealth" then
        value = data.Currency and (data.Currency.AetherShards or 0) or 0
    elseif category == "Pets" then
        value = data.PetInventory and #data.PetInventory or 0
    elseif category == "Quests" then
        if data.Quests then
            for _ in pairs(data.Quests) do
                value += 1
            end
        end
    end

    local leaderboard = LeaderboardService.Leaderboards[category]

    -- Remove old entry
    for i, entry in ipairs(leaderboard) do
        if entry.PlayerId == player.UserId then
            table.remove(leaderboard, i)
            break
        end
    end

    -- Add new entry
    table.insert(leaderboard, {
        PlayerId = player.UserId,
        PlayerName = player.Name,
        Value = value,
    })

    -- Sort leaderboard
    table.sort(leaderboard, function(a, b)
        if a.Value == b.Value then
            return a.PlayerId < b.PlayerId
        end
        return a.Value > b.Value
    end)

    -- Keep top 100
    while #leaderboard > 100 do
        table.remove(leaderboard)
    end
end

function LeaderboardService.UpdateAll(player)
    for _, category in ipairs(CATEGORIES) do
        LeaderboardService.UpdateLeaderboard(player, category)
    end
end

function LeaderboardService.GetTopPlayers(category, count)
    if not isCategory(category) then
        return {}
    end
    local leaderboard = LeaderboardService.Leaderboards[category]

    count = type(count) == "number" and count or 10
    if count ~= count then
        count = 10
    end
    count = math.clamp(math.floor(count), 1, 100)
    local topPlayers = {}
    for i = 1, math.min(count, #leaderboard) do
        table.insert(topPlayers, leaderboard[i])
    end
    return topPlayers
end

function LeaderboardService.GetPlayerRank(player, category)
    if not isCategory(category) then
        return -1
    end
    local leaderboard = LeaderboardService.Leaderboards[category]

    for i, entry in ipairs(leaderboard) do
        if entry.PlayerId == player.UserId then
            return i
        end
    end
    return -1
end

function LeaderboardService.RemovePlayer(player)
    for _, leaderboard in pairs(LeaderboardService.Leaderboards) do
        for index = #leaderboard, 1, -1 do
            if leaderboard[index].PlayerId == player.UserId then
                table.remove(leaderboard, index)
            end
        end
    end
end

return LeaderboardService
