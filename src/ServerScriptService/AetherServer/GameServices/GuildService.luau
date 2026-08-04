local GuildService = {}
local DataStoreService = game:GetService("DataStoreService")
local GuildDataStore = DataStoreService:GetDataStore("GuildData_v1")
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

GuildService.Guilds = {}
GuildService.GuildIdCounter = 1

function GuildService.LoadGuilds()
    local success, guilds = pcall(function()
        return GuildDataStore:GetAsync("Guilds")
    end)
    if success and guilds then
        GuildService.Guilds = guilds or {}
    end
end

function GuildService.SaveGuilds()
    local success, err = pcall(function()
        GuildDataStore:SetAsync("Guilds", GuildService.Guilds)
    end)
    if not success then
        warn("[GuildService] Failed to save guilds: ", err)
    end
end

function GuildService.Initialize()
    GuildService.LoadGuilds()
    print("[GuildService] Initializing...")

    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    -- CreateGuild
    local CreateGuild = Remotes:FindFirstChild("CreateGuild")
    if CreateGuild then
        CreateGuild.OnServerEvent:Connect(function(player, guildName, description)
            if type(guildName) ~= "string" then
                return
            end
            local guildId, guild = GuildService.CreateGuild(player, guildName, description)
            if not guildId then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, guild or "Failed to create guild")
                end
            end
        end)
    end

    -- JoinGuild
    local JoinGuild = Remotes:FindFirstChild("JoinGuild")
    if JoinGuild then
        JoinGuild.OnServerEvent:Connect(function(player, guildId)
            if type(guildId) ~= "string" then
                return
            end
            local success, message = GuildService.JoinGuild(player, guildId)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Failed to join guild")
                end
            end
        end)
    end

    -- LeaveGuild
    local LeaveGuild = Remotes:FindFirstChild("LeaveGuild")
    if LeaveGuild then
        LeaveGuild.OnServerEvent:Connect(function(player)
            GuildService.LeaveGuild(player)
        end)
    end

    -- InviteToGuild: owner invites a target player by user id
    local InviteToGuild = Remotes:FindFirstChild("InviteToGuild")
    if InviteToGuild then
        InviteToGuild.OnServerEvent:Connect(function(player, targetUserId)
            if type(targetUserId) ~= "number" then
                return
            end
            local target = game.Players:GetPlayerByUserId(targetUserId)
            if not target then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, "Player not found")
                end
                return
            end
            local success, message = GuildService.InvitePlayer(player, target)
            if not success then
                local Error = Remotes:FindFirstChild("Error")
                if Error then
                    Error:FireClient(player, message or "Invite failed")
                end
            end
        end)
    end

    -- GetGuildInfo
    local GetGuildInfo = Remotes:FindFirstChild("GetGuildInfo")
    if GetGuildInfo then
        GetGuildInfo.OnServerInvoke = function(player)
            return GuildService.GetGuildByPlayer(player)
        end
    end

    print("[GuildService] Initialized")
end

function GuildService.CreateGuild(player, guildName, description)
    local existingGuild = GuildService:GetGuildByPlayer(player)
    if existingGuild then
        return nil, "Already in a guild"
    end

    local guildId = "GUILD_" .. GuildService.GuildIdCounter
    GuildService.GuildIdCounter += 1

    local guild = {
        Id = guildId,
        Name = guildName,
        Description = description or "",
        OwnerId = player.UserId,
        Members = { player.UserId },
        Level = 1,
        XP = 0,
        CreatedAt = os.time(),
    }

    GuildService.Guilds[guildId] = guild

    -- Update player data
    local data = PlayerDataService.GetData(player)
    if data then
        data.GuildId = guildId
        data.GuildRank = "Owner"
    end

    -- Notify client
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local GuildCreated = Remotes:FindFirstChild("GuildCreated")
        if GuildCreated then
            GuildCreated:FireClient(player, guild)
        end
    end

    print("[GuildService] Guild created: " .. guildName .. " by " .. player.Name)
    GuildService.SaveGuilds()
    return guildId, guild
end

function GuildService.InvitePlayer(player, targetPlayer)
    local data = PlayerDataService.GetData(player)
    if not data or not data.GuildId then
        return false, "Not in a guild"
    end

    local guild = GuildService.Guilds[data.GuildId]
    if not guild then
        return false, "Guild not found"
    end

    if guild.OwnerId ~= player.UserId then
        return false, "Only owner can invite"
    end

    -- Check if target is already in a guild
    local targetData = PlayerDataService.GetData(targetPlayer)
    if targetData and targetData.GuildId then
        return false, "Player already in a guild"
    end

    -- Send invite
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local GuildInvite = Remotes:FindFirstChild("GuildInvite")
        if GuildInvite then
            GuildInvite:FireClient(targetPlayer, data.GuildId, guild.Name)
        end
    end

    GuildService.SaveGuilds()
    return true, "Invite sent"
end

function GuildService.JoinGuild(player, guildId)
    local data = PlayerDataService.GetData(player)
    if data and data.GuildId then
        return false, "Already in a guild"
    end

    local guild = GuildService.Guilds[guildId]
    if not guild then
        return false, "Guild not found"
    end

    -- Add member
    table.insert(guild.Members, player.UserId)

    -- Update player data
    if data then
        data.GuildId = guildId
        data.GuildRank = "Member"
    end

    -- Notify guild members
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local GuildMemberJoined = Remotes:FindFirstChild("GuildMemberJoined")
        if GuildMemberJoined then
            GuildMemberJoined:FireAllClients(guildId, player.UserId, player.Name)
        end
    end

    print("[GuildService] " .. player.Name .. " joined guild: " .. guild.Name)
    GuildService.SaveGuilds()
    return true, "Joined guild"
end

function GuildService.LeaveGuild(player)
    local data = PlayerDataService.GetData(player)
    if not data or not data.GuildId then
        return false, "Not in a guild"
    end

    local guild = GuildService.Guilds[data.GuildId]
    if not guild then
        return false, "Guild not found"
    end

    -- Remove member
    for i, memberId in ipairs(guild.Members) do
        if memberId == player.UserId then
            table.remove(guild.Members, i)
            break
        end
    end

    -- Clear player data
    data.GuildId = nil
    data.GuildRank = nil

    -- Notify guild members
    local Remotes = game.ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local GuildMemberLeft = Remotes:FindFirstChild("GuildMemberLeft")
        if GuildMemberLeft then
            GuildMemberLeft:FireAllClients(data.GuildId, player.UserId)
        end
    end

    -- Delete guild if owner left and no members
    if guild.OwnerId == player.UserId and #guild.Members == 0 then
        GuildService.Guilds[data.GuildId] = nil
        GuildService.SaveGuilds()
    end

    print("[GuildService] " .. player.Name .. " left guild")
    GuildService.SaveGuilds()
    return true, "Left guild"
end

function GuildService.GetGuildByPlayer(player)
    local data = PlayerDataService.GetData(player)
    if not data or not data.GuildId then
        return nil
    end
    return GuildService.Guilds[data.GuildId]
end

function GuildService.GetGuild(guildId)
    return GuildService.Guilds[guildId]
end

function GuildService.AddXP(guildId, amount)
    local guild = GuildService.Guilds[guildId]
    if not guild then
        return
    end

    guild.XP = (guild.XP or 0) + amount

    -- Check for level up
    local xpRequired = GuildService.CalculateXPRequired(guild.Level)
    while guild.XP >= xpRequired do
        guild.XP -= xpRequired
        guild.Level += 1
        print("[GuildService] Guild " .. guild.Name .. " leveled up to " .. guild.Level)
    end
end

function GuildService.CalculateXPRequired(level)
    return math.floor(500 * math.pow(1.2, level - 1))
end

return GuildService
