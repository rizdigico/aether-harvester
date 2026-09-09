local GuildRules = require("../../src/ReplicatedStorage/AetherShared/Modules/GuildRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "GuildRules.NormalizeName",
        tests = {
            {
                name = "trims and bounds guild names",
                fn = function()
                    expectEqual(GuildRules.NormalizeName("  Aether  "), "Aether", "trimmed name")
                    expectEqual(GuildRules.NormalizeName("ab"), nil, "short name")
                    expectEqual(GuildRules.NormalizeName(string.rep("x", 25)), nil, "long name")
                end,
            },
        },
    },
    {
        name = "GuildRules.CanAddMember",
        tests = {
            {
                name = "enforces the thirty-player cap",
                fn = function()
                    expectEqual(GuildRules.CanAddMember(1), true, "one member")
                    expectEqual(GuildRules.CanAddMember(29), true, "twenty-nine members")
                    expectEqual(GuildRules.CanAddMember(30), false, "full guild")
                    expectEqual(GuildRules.CanAddMember(0), false, "empty guild")
                end,
            },
        },
    },
    {
        name = "GuildRules.NormalizeGuild",
        tests = {
            {
                name = "deduplicates members and keeps a valid owner",
                fn = function()
                    local guild = GuildRules.NormalizeGuild({
                        Name = "Aether",
                        OwnerId = 99,
                        Members = { 4, 4, "bad", 99 },
                        Description = string.rep("d", 210),
                        Level = 0,
                        XP = -10,
                    }, "GUILD_7")
                    assert(guild ~= nil, "guild should normalize")
                    expectEqual(guild.Id, "GUILD_7", "canonical id")
                    expectEqual(#guild.Members, 2, "deduplicated members")
                    expectEqual(guild.Members[1], 4, "first member retained")
                    expectEqual(guild.Members[2], 99, "owner retained")
                    expectEqual(guild.Level, 1, "level floor")
                    expectEqual(guild.XP, 0, "xp floor")
                    expectEqual(#guild.Description, 200, "description cap")
                end,
            },
            {
                name = "rejects malformed guild records",
                fn = function()
                    expectEqual(GuildRules.NormalizeGuild({}, "GUILD_1"), nil, "missing name")
                    expectEqual(GuildRules.NormalizeGuild({ Name = "Aether", Members = {} }, "bad"), nil, "bad id")
                end,
            },
        },
    },
}
