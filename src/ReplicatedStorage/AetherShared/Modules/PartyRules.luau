--!strict
-- Pure party rules shared by the server and offline tests.

local PartyRules = {}

PartyRules.MAX_MEMBERS = 4
PartyRules.INVITE_LIFETIME_SECONDS = 120

function PartyRules.IsValidUserId(value: any): boolean
    return type(value) == "number" and value == value and value < math.huge and value > 0 and value == math.floor(value)
end

function PartyRules.CanAddMember(memberCount: any): boolean
    return type(memberCount) == "number"
        and memberCount == memberCount
        and memberCount >= 1
        and memberCount < PartyRules.MAX_MEMBERS
        and memberCount == math.floor(memberCount)
end

function PartyRules.IsInviteActive(invite: any, partyId: any, now: any): boolean
    return type(invite) == "table"
        and type(invite.PartyId) == "string"
        and invite.PartyId == partyId
        and type(invite.ExpiresAt) == "number"
        and type(now) == "number"
        and invite.ExpiresAt > now
end

return PartyRules
