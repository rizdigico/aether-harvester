local GuildService = {}
local DataStoreService = game:GetService("DataStoreService")
local GuildDataStore = DataStoreService:GetDataStore("GuildData_v1")
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local GuildRules = require(game.ReplicatedStorage.AetherShared.Modules.GuildRules)

GuildService.Guilds = {}
GuildService.GuildIdCounter = 1
GuildService.PendingInvites = {}
GuildService.InviteLifetimeSeconds = 600

function GuildService.PruneExpiredInvites()
    local now = os.time()
    for userId, invite in pairs(GuildService.PendingInvites) do
        if type(invite) ~= "table" or type(invite.ExpiresAt) ~= "number" or invite.ExpiresAt <= now then
            GuildService.PendingInvites[userId] = nil
        end
    end
end

function GuildService.LoadGuilds()
    local success, guilds = pcall(function()
        return GuildDataStore:GetAsync("Guilds")
    end)
    if success then
        local sanitizedGuilds = {}
        local seenNames = {}
        local highestId = 0
        if type(guilds) == "table" then
            for guildId, rawGuild in pairs(guilds) do
                local normalized = GuildRules.NormalizeGuild(rawGuild, guildId)
                if normalized then
                    local normalizedName = string.lower(normalized.Name)
                    if not seenNames[normalizedName] then
                        sanitizedGuilds[guildId] = normalized
                        seenNames[normalizedName] = true
                        local numericId = tonumber(tostring(guildId):match("^GUILD_(%d+)$"))
                        if numericId and numericId > highestId then
                            highestId = numericId
                        end
                    end
                end
            end
        end
        GuildService.Guilds = sanitizedGuilds
        GuildService.GuildIdCounter = highestId + 1
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
            -- Rate limit: max one guild creation per 5 seconds per player
            if not RateLimiter.Check(player, "CreateGuild", 5) then
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
            if not RateLimiter.Check(player, "JoinGuild", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
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
            if not RateLimiter.Check(player, "LeaveGuild", 1) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            GuildService.LeaveGuild(player)
        end)
    end

    -- InviteToGuild: owner invites a target player by user id
    local InviteToGuild = Remotes:FindFirstChild("InviteToGuild")
    if InviteToGuild then
        InviteToGuild.OnServerEvent:Connect(function(player, targetUserId)
            if
                type(targetUserId) ~= "number"
                or targetUserId ~= targetUserId
                or targetUserId < 1
                or targetUserId ~= math.floor(targetUserId)
            then
                return
            end
            if not RateLimiter.Check(player, "InviteToGuild", 2) then
                return
            end
            AntiCheatService:CheckPlayer(player)
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
    -- VALIDATION: name length (3-24 chars), case-insensitive uniqueness, desc cap
    local normalizedGuildName = GuildRules.NormalizeName(guildName)
    if not normalizedGuildName then
        return nil, "Guild name must be 3-24 characters"
    end
    guildName = normalizedGuildName
    local normalizedName = string.lower(guildName)
    for _, existing in pairs(GuildService.Guilds) do
        if type(existing.Name) == "string" and string.lower(existing.Name) == normalizedName then
            return nil, "A guild with that name already exists"
        end
    end
    if type(description) == "string" and #description > 200 then
        description = description:sub(1, 200)
    end

    local existingGuild = GuildService.GetGuildByPlayer(player)
    if existingGuild then
        return nil, "Already in a guild"
    end
    if not PlayerDataService.GetData(player) then
        return nil, "Player data not found"
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
    GuildService.PruneExpiredInvites()
    if player == targetPlayer then
        return false, "You cannot invite yourself"
    end
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

    if not GuildRules.CanAddMember(#guild.Members) then
        return false, "Guild is full"
    end

    -- Check if target is already in a guild
    local targetData = PlayerDataService.GetData(targetPlayer)
    if not targetData then
        return false, "Player data not found"
    end
    if targetData and targetData.GuildId then
        return false, "Player already in a guild"
    end

    -- Store the invite server-side. The client notification is only a view of
    -- this record; a forged JoinGuild event cannot bypass the invite check.
    GuildService.PendingInvites[targetPlayer.UserId] = {
        GuildId = data.GuildId,
        InvitedBy = player.UserId,
        ExpiresAt = os.time() + GuildService.InviteLifetimeSeconds,
    }

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
    GuildService.PruneExpiredInvites()
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end
    if data and data.GuildId then
        return false, "Already in a guild"
    end

    local invite = GuildService.PendingInvites[player.UserId]
    if
        type(invite) ~= "table"
        or invite.GuildId ~= guildId
        or type(invite.ExpiresAt) ~= "number"
        or invite.ExpiresAt <= os.time()
    then
        GuildService.PendingInvites[player.UserId] = nil
        return false, "You need a current guild invite"
    end

    local guild = GuildService.Guilds[guildId]
    if not guild then
        return false, "Guild not found"
    end

    for _, memberId in ipairs(guild.Members) do
        if memberId == player.UserId then
            return false, "Already in guild"
        end
    end

    if not GuildRules.CanAddMember(#guild.Members) then
        GuildService.PendingInvites[player.UserId] = nil
        return false, "Guild is full"
    end

    -- Add member
    table.insert(guild.Members, player.UserId)

    -- Update player data
    if data then
        data.GuildId = guildId
        data.GuildRank = "Member"
    end
    GuildService.PendingInvites[player.UserId] = nil

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
    GuildService.PruneExpiredInvites()
    GuildService.PendingInvites[player.UserId] = nil
    local data = PlayerDataService.GetData(player)
    if not data or not data.GuildId then
        return false, "Not in a guild"
    end

    local guildId = data.GuildId
    local guild = GuildService.Guilds[guildId]
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
            GuildMemberLeft:FireAllClients(guildId, player.UserId)
        end
    end

    -- Delete empty guilds; otherwise transfer ownership so no guild is left
    -- permanently ownerless when its original owner departs.
    if guild.OwnerId == player.UserId then
        if #guild.Members == 0 then
            GuildService.Guilds[guildId] = nil
        else
            guild.OwnerId = guild.Members[1]
            local newOwner = game.Players:GetPlayerByUserId(guild.OwnerId)
            local newOwnerData = newOwner and PlayerDataService.GetData(newOwner)
            if newOwnerData then
                newOwnerData.GuildRank = "Owner"
            end
        end
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
