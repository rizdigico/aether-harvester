-- Pure session accounting helpers shared by analytics and headless tests.
local SessionMetrics = {}

local function isFiniteNumber(value)
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

function SessionMetrics.GetElapsedSeconds(now, startedAt)
    if not isFiniteNumber(now) or not isFiniteNumber(startedAt) then
        return 0
    end
    return math.max(0, math.floor(now - startedAt))
end

function SessionMetrics.GetElapsedMinutes(now, startedAt)
    return math.floor(SessionMetrics.GetElapsedSeconds(now, startedAt) / 60)
end

return SessionMetrics
