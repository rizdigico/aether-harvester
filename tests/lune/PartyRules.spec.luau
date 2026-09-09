local PartyRules = require("../../src/ReplicatedStorage/AetherShared/Modules/PartyRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "PartyRules.IsValidUserId",
        tests = {
            {
                name = "accepts positive integer ids only",
                fn = function()
                    expectEqual(PartyRules.IsValidUserId(42), true, "valid id")
                    expectEqual(PartyRules.IsValidUserId(0), false, "zero")
                    expectEqual(PartyRules.IsValidUserId(1.5), false, "fraction")
                    expectEqual(PartyRules.IsValidUserId("42"), false, "string")
                end,
            },
        },
    },
    {
        name = "PartyRules.CanAddMember",
        tests = {
            {
                name = "allows slots below the four-player cap",
                fn = function()
                    expectEqual(PartyRules.CanAddMember(1), true, "one member")
                    expectEqual(PartyRules.CanAddMember(3), true, "three members")
                    expectEqual(PartyRules.CanAddMember(4), false, "full")
                    expectEqual(PartyRules.CanAddMember(0), false, "empty party")
                end,
            },
        },
    },
    {
        name = "PartyRules.IsInviteActive",
        tests = {
            {
                name = "requires matching party and unexpired time",
                fn = function()
                    local invite = { PartyId = "PARTY_1_1", ExpiresAt = 100 }
                    expectEqual(PartyRules.IsInviteActive(invite, "PARTY_1_1", 99), true, "active")
                    expectEqual(PartyRules.IsInviteActive(invite, "PARTY_2_1", 99), false, "wrong party")
                    expectEqual(PartyRules.IsInviteActive(invite, "PARTY_1_1", 100), false, "expired")
                end,
            },
        },
    },
}
