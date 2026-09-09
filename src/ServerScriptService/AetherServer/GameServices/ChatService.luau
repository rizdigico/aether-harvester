local ChatService = {}
local TextService = game:GetService("TextService")
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
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
            ChatMessageReceived:FireAllClients(chatMessage)
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
