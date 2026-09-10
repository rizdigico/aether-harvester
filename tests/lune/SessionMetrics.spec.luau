local SessionMetrics = require("../../src/ReplicatedStorage/AetherShared/Modules/SessionMetrics")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "SessionMetrics.GetElapsedSeconds",
        tests = {
            {
                name = "returns bounded elapsed seconds",
                fn = function()
                    expectEqual(SessionMetrics.GetElapsedSeconds(125.9, 60.1), 65, "elapsed seconds")
                    expectEqual(SessionMetrics.GetElapsedSeconds(10, 20), 0, "backwards time")
                    expectEqual(SessionMetrics.GetElapsedSeconds(nil, 20), 0, "invalid now")
                end,
            },
        },
    },
    {
        name = "SessionMetrics.GetElapsedMinutes",
        tests = {
            {
                name = "floors partial minutes",
                fn = function()
                    expectEqual(SessionMetrics.GetElapsedMinutes(360, 0), 6, "whole minutes")
                    expectEqual(SessionMetrics.GetElapsedMinutes(419, 60), 5, "partial minute")
                end,
            },
        },
    },
}
