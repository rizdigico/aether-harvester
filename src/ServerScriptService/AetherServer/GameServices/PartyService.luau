--!strict
-- Session-only, server-authoritative party lifecycle.

local PartyService = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local PartyRules = require(ReplicatedStorage.AetherShared.Modules.PartyRules)

PartyService.Parties = {}
PartyService.Membership = {}
PartyService.PendingInvites = {}
PartyService.PartyIdCounter = 0

local function getRemotes(): Folder?
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    local remotes = shared and shared:FindFirstChild("Remotes")
    return if remotes and remotes:IsA("Folder") then remotes else nil
end

local function fireError(player: Player, message: string)
    local remotes = getRemotes()
    local errorRemote = remotes and remotes:FindFirstChild("Error")
    if errorRemote and errorRemote:IsA("RemoteEvent") then
        errorRemote:FireClient(player, message)
    end
end

local function containsMember(party: { Members: { number } }, userId: number): boolean
    for _, memberId in ipairs(party.Members) do
        if memberId == userId then
            return true
        end
    end
    return false
end

local function removeMember(party: { Members: { number } }, userId: number): boolean
    for index, memberId in ipairs(party.Members) do
        if memberId == userId then
            table.remove(party.Members, index)
            return true
        end
    end
    return false
end

local function getParty(player: Player): { Id: string, OwnerId: number, Members: { number } }?
    local partyId = PartyService.Membership[player.UserId]
    if type(partyId) ~= "string" then
        return nil
    end
    local party = PartyService.Parties[partyId]
    if type(party) ~= "table" then
        PartyService.Membership[player.UserId] = nil
        return nil
    end
    return party
end

local function snapshot(party: { Id: string, OwnerId: number, Members: { number } }): { [string]: any }
    local members = {}
    for index, userId in ipairs(party.Members) do
        local player = Players:GetPlayerByUserId(userId)
        members[index] = {
            UserId = userId,
            Name = player and player.Name or "Offline",
            DisplayName = player and player.DisplayName or "Offline",
            IsOwner = userId == party.OwnerId,
        }
    end
    return {
        Id = party.Id,
        OwnerId = party.OwnerId,
        MaxMembers = PartyRules.MAX_MEMBERS,
        Members = members,
    }
end

local function emptySnapshot(): { [string]: any }
    return {
        Id = nil,
        OwnerId = nil,
        MaxMembers = PartyRules.MAX_MEMBERS,
        Members = {},
    }
end

local function notify(party: { Id: string, OwnerId: number, Members: { number } })
    local remotes = getRemotes()
    local updated = remotes and remotes:FindFirstChild("PartyUpdated")
    if not updated or not updated:IsA("RemoteEvent") then
        return
    end
    local payload = snapshot(party)
    for _, userId in ipairs(party.Members) do
        local player = Players:GetPlayerByUserId(userId)
        if player then
            updated:FireClient(player, payload)
        end
    end
end

function PartyService.PruneExpiredInvites()
    local now = os.time()
    for userId, invite in pairs(PartyService.PendingInvites) do
        if type(invite) ~= "table" or type(invite.ExpiresAt) ~= "number" or invite.ExpiresAt <= now then
            PartyService.PendingInvites[userId] = nil
        end
    end
end

function PartyService.GetSnapshot(player: Player): { [string]: any }
    local party = getParty(player)
    return party and snapshot(party) or emptySnapshot()
end

function PartyService.CreateParty(player: Player): (boolean, string)
    if getParty(player) then
        return false, "You are already in a party"
    end

    PartyService.PartyIdCounter += 1
    local partyId = string.format("PARTY_%d_%d", player.UserId, PartyService.PartyIdCounter)
    local party = {
        Id = partyId,
        OwnerId = player.UserId,
        Members = { player.UserId },
        CreatedAt = os.time(),
    }
    PartyService.Parties[partyId] = party
    PartyService.Membership[player.UserId] = partyId
    notify(party)
    return true, "Party created"
end

function PartyService.InvitePlayer(player: Player, target: Player): (boolean, string)
    PartyService.PruneExpiredInvites()
    if player == target then
        return false, "You cannot invite yourself"
    end

    local party = getParty(player)
    if not party or not containsMember(party, player.UserId) then
        return false, "Create or join a party first"
    end
    if not PartyRules.CanAddMember(#party.Members) then
        return false, "Party is full"
    end
    if getParty(target) then
        return false, "Player is already in a party"
    end
    if PartyService.PendingInvites[target.UserId] then
        return false, "Player already has a pending party invite"
    end

    local invite = {
        PartyId = party.Id,
        InvitedBy = player.UserId,
        ExpiresAt = os.time() + PartyRules.INVITE_LIFETIME_SECONDS,
    }
    PartyService.PendingInvites[target.UserId] = invite

    local remotes = getRemotes()
    local inviteRemote = remotes and remotes:FindFirstChild("PartyInvite")
    if inviteRemote and inviteRemote:IsA("RemoteEvent") then
        inviteRemote:FireClient(target, party.Id, player.UserId, player.DisplayName)
    end
    return true, "Party invite sent"
end

function PartyService.RespondToInvite(player: Player, partyId: string, accepted: boolean): (boolean, string)
    PartyService.PruneExpiredInvites()
    local invite = PartyService.PendingInvites[player.UserId]
    if not PartyRules.IsInviteActive(invite, partyId, os.time()) then
        PartyService.PendingInvites[player.UserId] = nil
        return false, "Party invite expired or is no longer valid"
    end
    PartyService.PendingInvites[player.UserId] = nil

    if not accepted then
        return true, "Party invite declined"
    end
    if getParty(player) then
        return false, "You are already in a party"
    end

    local party = PartyService.Parties[partyId]
    if type(party) ~= "table" or not PartyRules.CanAddMember(#party.Members) then
        return false, "Party is no longer available"
    end
    table.insert(party.Members, player.UserId)
    PartyService.Membership[player.UserId] = party.Id
    notify(party)
    return true, "Joined party"
end

function PartyService.LeaveParty(player: Player): (boolean, string)
    local party = getParty(player)
    if not party then
        return false, "You are not in a party"
    end

    removeMember(party, player.UserId)
    PartyService.Membership[player.UserId] = nil
    if #party.Members == 0 then
        PartyService.Parties[party.Id] = nil
    else
        if party.OwnerId == player.UserId then
            party.OwnerId = party.Members[1]
        end
        notify(party)
    end

    local remotes = getRemotes()
    local updated = remotes and remotes:FindFirstChild("PartyUpdated")
    if updated and updated:IsA("RemoteEvent") then
        updated:FireClient(player, emptySnapshot())
    end
    return true, "Left party"
end

function PartyService.KickMember(player: Player, targetUserId: number): (boolean, string)
    local party = getParty(player)
    if not party or party.OwnerId ~= player.UserId then
        return false, "Only the party owner can remove members"
    end
    if targetUserId == player.UserId or not containsMember(party, targetUserId) then
        return false, "Party member not found"
    end

    removeMember(party, targetUserId)
    PartyService.Membership[targetUserId] = nil
    local target = Players:GetPlayerByUserId(targetUserId)
    local remotes = getRemotes()
    local updated = remotes and remotes:FindFirstChild("PartyUpdated")
    if target and updated and updated:IsA("RemoteEvent") then
        updated:FireClient(target, emptySnapshot())
    end
    notify(party)
    return true, "Player removed from party"
end

function PartyService.OnPlayerRemoving(player: Player)
    PartyService.PendingInvites[player.UserId] = nil
    local party = getParty(player)
    if party then
        PartyService.LeaveParty(player)
    end
end

local function withError(player: Player, action: () -> (boolean, string))
    AntiCheatService:CheckPlayer(player)
    local success, message = action()
    if not success then
        fireError(player, message)
    end
end

function PartyService.Initialize()
    print("[PartyService] Initializing...")
    local remotes = getRemotes()
    if not remotes then
        return
    end

    local getPartyRemote = remotes:FindFirstChild("GetParty")
    if getPartyRemote and getPartyRemote:IsA("RemoteFunction") then
        getPartyRemote.OnServerInvoke = function(player: Player)
            if not RateLimiter.Check(player, "GetParty", 0.5) then
                return emptySnapshot()
            end
            return PartyService.GetSnapshot(player)
        end
    end

    local createParty = remotes:FindFirstChild("CreateParty")
    if createParty and createParty:IsA("RemoteEvent") then
        createParty.OnServerEvent:Connect(function(player: Player)
            if RateLimiter.Check(player, "CreateParty", 2) then
                withError(player, function()
                    return PartyService.CreateParty(player)
                end)
            end
        end)
    end

    local inviteToParty = remotes:FindFirstChild("InviteToParty")
    if inviteToParty and inviteToParty:IsA("RemoteEvent") then
        inviteToParty.OnServerEvent:Connect(function(player: Player, targetUserId: any)
            if not RateLimiter.Check(player, "InviteToParty", 2) or not PartyRules.IsValidUserId(targetUserId) then
                return
            end
            local target = Players:GetPlayerByUserId(targetUserId)
            if not target then
                fireError(player, "Player not found")
                return
            end
            withError(player, function()
                return PartyService.InvitePlayer(player, target)
            end)
        end)
    end

    local respondInvite = remotes:FindFirstChild("RespondPartyInvite")
    if respondInvite and respondInvite:IsA("RemoteEvent") then
        respondInvite.OnServerEvent:Connect(function(player: Player, partyId: any, accepted: any)
            if not RateLimiter.Check(player, "RespondPartyInvite", 1) then
                return
            end
            if type(partyId) ~= "string" or #partyId > 64 or type(accepted) ~= "boolean" then
                return
            end
            withError(player, function()
                return PartyService.RespondToInvite(player, partyId, accepted)
            end)
        end)
    end

    local leaveParty = remotes:FindFirstChild("LeaveParty")
    if leaveParty and leaveParty:IsA("RemoteEvent") then
        leaveParty.OnServerEvent:Connect(function(player: Player)
            if RateLimiter.Check(player, "LeaveParty", 1) then
                withError(player, function()
                    return PartyService.LeaveParty(player)
                end)
            end
        end)
    end

    local kickMember = remotes:FindFirstChild("KickPartyMember")
    if kickMember and kickMember:IsA("RemoteEvent") then
        kickMember.OnServerEvent:Connect(function(player: Player, targetUserId: any)
            if not RateLimiter.Check(player, "KickPartyMember", 1) or not PartyRules.IsValidUserId(targetUserId) then
                return
            end
            withError(player, function()
                return PartyService.KickMember(player, targetUserId)
            end)
        end)
    end

    print("[PartyService] Initialized")
end

return PartyService
