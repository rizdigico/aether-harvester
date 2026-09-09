--!strict
-- Pure guild rules shared by the server and offline tests.

local GuildRules = {}

GuildRules.MAX_MEMBERS = 30
GuildRules.MIN_NAME_LENGTH = 3
GuildRules.MAX_NAME_LENGTH = 24
GuildRules.MAX_DESCRIPTION_LENGTH = 200
GuildRules.MAX_LEVEL = 1000
GuildRules.MAX_XP = 1000000000000

local function isFiniteNumber(value: any): boolean
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

function GuildRules.IsValidUserId(value: any): boolean
    return isFiniteNumber(value) and value > 0 and value == math.floor(value)
end

function GuildRules.IsValidGuildId(value: any): boolean
    if type(value) ~= "string" then
        return false
    end
    local numericId = tonumber(value:match("^GUILD_(%d+)$"))
    return numericId ~= nil and numericId > 0 and numericId == math.floor(numericId)
end

function GuildRules.NormalizeName(value: any): string?
    if type(value) ~= "string" then
        return nil
    end
    local name = string.gsub(value, "^%s*(.-)%s*$", "%1")
    local nameLength = utf8.len(name) or 0
    if nameLength < GuildRules.MIN_NAME_LENGTH or nameLength > GuildRules.MAX_NAME_LENGTH then
        return nil
    end
    return name
end

function GuildRules.CanAddMember(memberCount: any): boolean
    return isFiniteNumber(memberCount)
        and memberCount >= 1
        and memberCount < GuildRules.MAX_MEMBERS
        and memberCount == math.floor(memberCount)
end

function GuildRules.HasMember(members: any, userId: any): boolean
    if type(members) ~= "table" or not GuildRules.IsValidUserId(userId) then
        return false
    end
    for _, memberId in ipairs(members) do
        if memberId == userId then
            return true
        end
    end
    return false
end

-- Convert persisted data into a bounded, canonical guild record. Invalid
-- records are discarded by the caller rather than being exposed to gameplay.
function GuildRules.NormalizeGuild(rawGuild: any, guildId: any): { [string]: any }?
    if type(rawGuild) ~= "table" or not GuildRules.IsValidGuildId(guildId) then
        return nil
    end

    local name = GuildRules.NormalizeName(rawGuild.Name)
    if not name then
        return nil
    end

    local members = {}
    local seenMembers = {}
    if type(rawGuild.Members) == "table" then
        for _, memberId in ipairs(rawGuild.Members) do
            if GuildRules.IsValidUserId(memberId) and not seenMembers[memberId] then
                seenMembers[memberId] = true
                table.insert(members, memberId)
                if #members >= GuildRules.MAX_MEMBERS then
                    break
                end
            end
        end
    end

    local ownerId = GuildRules.IsValidUserId(rawGuild.OwnerId) and rawGuild.OwnerId or members[1]
    if not GuildRules.IsValidUserId(ownerId) then
        return nil
    end
    if not seenMembers[ownerId] then
        if #members >= GuildRules.MAX_MEMBERS then
            return nil
        end
        table.insert(members, 1, ownerId)
    end

    local description = type(rawGuild.Description) == "string" and rawGuild.Description or ""
    description = description:sub(1, GuildRules.MAX_DESCRIPTION_LENGTH)

    local level = isFiniteNumber(rawGuild.Level) and math.floor(rawGuild.Level) or 1
    local xp = isFiniteNumber(rawGuild.XP) and math.floor(rawGuild.XP) or 0
    local createdAt = isFiniteNumber(rawGuild.CreatedAt) and math.floor(rawGuild.CreatedAt) or 0

    return {
        Id = guildId,
        Name = name,
        Description = description,
        OwnerId = ownerId,
        Members = members,
        Level = math.clamp(level, 1, GuildRules.MAX_LEVEL),
        XP = math.clamp(xp, 0, GuildRules.MAX_XP),
        CreatedAt = math.max(0, createdAt),
    }
end

return GuildRules
