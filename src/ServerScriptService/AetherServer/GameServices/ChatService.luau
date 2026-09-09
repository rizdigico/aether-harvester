local ChatService = {}
local TextService = game:GetService("TextService")
local Players = game:GetService("Players")
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local WorldManager = require(game.ServerScriptService.AetherServer.GameServices.WorldManager)
local GuildService = require(game.ServerScriptService.AetherServer.GameServices.GuildService)
ChatService.Channels = {
    { Id = "global", Name = "Global", Description = "Global chat for all players" },
    { Id = "island", Name = "Island", Description = "Chat with players on your island" },
    { Id = "guild", Name = "Guild", Description = "Chat with your guild members" },
    { Id = "party", Name = "Party", Description = "Chat with your party" },
    { Id = "trade", Name = "Trade", Description = "Looking for trades" },
}

ChatService.MessageHistory = {}
ChatService.MessageIdCounter = 1

function ChatService.Initialize()
    print("[ChatService] Initializing...")

    -- Setup chat channels
    ChatService:SetupChannels()
end

function ChatService:SetupChannels()
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- Send message remote
    local SendMessage = Remotes:FindFirstChild("SendChatMessage")
    if SendMessage then
        SendMessage.OnServerEvent:Connect(function(player, channelId, message)
            if not RateLimiter.Check(player, "SendChatMessage", 0.75) then
                return
            end
            if type(channelId) ~= "string" or type(message) ~= "string" then
                return
            end
            ChatService:HandleMessage(player, channelId, message)
        end)
    end

    -- History is restricted to channels whose membership is global by design.
    -- Scoped history needs a per-message scope snapshot before it can be safe.
    local GetChatHistory = Remotes:FindFirstChild("GetChatHistory")
    if GetChatHistory then
        GetChatHistory.OnServerInvoke = function(player, channelId, limit)
            if not RateLimiter.Check(player, "GetChatHistory", 0.5) then
                return {}
            end
            if channelId ~= "global" and channelId ~= "trade" then
                return {}
            end
            local requestedLimit = type(limit) == "number" and limit or 50
            if requestedLimit ~= requestedLimit then
                requestedLimit = 50
            end
            return ChatService.GetHistory(channelId, math.clamp(math.floor(requestedLimit), 1, 100))
        end
    end
end

local function getRecipients(player, channelId)
    if channelId == "global" or channelId == "trade" then
        return Players:GetPlayers()
    end

    if channelId == "island" then
        local islandId = WorldManager.GetPlayerIsland(player)
        local recipients = {}
        for _, recipient in ipairs(Players:GetPlayers()) do
            if WorldManager.GetPlayerIsland(recipient) == islandId then
                table.insert(recipients, recipient)
            end
        end
        return recipients
    end

    if channelId == "guild" then
        local guild = GuildService.GetGuildByPlayer(player)
        if not guild or type(guild.Members) ~= "table" then
            return {}
        end
        local memberIds = {}
        for _, memberId in ipairs(guild.Members) do
            memberIds[memberId] = true
        end
        local recipients = {}
        for _, recipient in ipairs(Players:GetPlayers()) do
            if memberIds[recipient.UserId] then
                table.insert(recipients, recipient)
            end
        end
        return recipients
    end

    -- Party membership is not implemented yet; do not leak party messages
    -- to unrelated players while that system is unavailable.
    return {}
end

function ChatService:HandleMessage(player, channelId, message)
    -- Validate message
    if not message or message == "" then
        return
    end
    if #message > 200 then
        message = message:sub(1, 200)
    end

    local ok, filteredMessage = pcall(function()
        local filterResult = TextService:FilterStringAsync(message, player.UserId, Enum.TextFilterContext.PublicChat)
        return filterResult:GetNonChatStringForBroadcastAsync()
    end)
    if not ok or type(filteredMessage) ~= "string" or filteredMessage == "" then
        return
    end
    message = filteredMessage

    -- Check channel access
    local channel = ChatService:GetChannel(channelId)
    if not channel then
        return
    end

    if channelId == "party" then
        return
    end
    if channelId == "guild" and not GuildService.GetGuildByPlayer(player) then
        return
    end
    if channelId == "island" and not WorldManager.GetPlayerIsland(player) then
        return
    end

    -- Create message
    local chatMessage = {
        Id = "MSG_" .. ChatService.MessageIdCounter,
        Channel = channelId,
        PlayerId = player.UserId,
        PlayerName = player.Name,
        Message = message,
        Timestamp = os.time(),
    }
    ChatService.MessageIdCounter += 1

    -- Store in history
    table.insert(ChatService.MessageHistory, chatMessage)

    -- Keep only last 1000 messages
    while #ChatService.MessageHistory > 1000 do
        table.remove(ChatService.MessageHistory, 1)
    end

    -- Broadcast to channel
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local ChatMessageReceived = Remotes:FindFirstChild("ChatMessageReceived")
        if ChatMessageReceived then
            for _, recipient in ipairs(getRecipients(player, channelId)) do
                ChatMessageReceived:FireClient(recipient, chatMessage)
            end
        end
    end

    print("[ChatService] " .. player.Name .. " [" .. channelId .. "]: " .. message)
end

function ChatService:GetChannel(channelId)
    for _, channel in ipairs(ChatService.Channels) do
        if channel.Id == channelId then
            return channel
        end
    end
    return nil
end

function ChatService.GetChannels()
    return ChatService.Channels
end

function ChatService.GetHistory(channelId, limit)
    limit = limit or 50
    local history = {}
    local count = 0

    for i = #ChatService.MessageHistory, 1, -1 do
        local msg = ChatService.MessageHistory[i]
        if msg.Channel == channelId then
            table.insert(history, msg)
            count += 1
            if count >= limit then
                break
            end
        end
    end

    return history
end

return ChatService
