--!strict
-- Pure event multipliers shared by server gameplay and offline tests.

local EventMath = {}

local BONUSES: { [string]: number } = {
    DoubleXP = 2.0,
    ResourceRush = 1.5,
    PetWeekend = 1.3,
    GuildWars = 1.0,
    HarvestFestival = 1.5,
}

local YIELD_EVENTS: { [string]: boolean } = {
    ResourceRush = true,
    HarvestFestival = true,
}

local XP_EVENTS: { [string]: boolean } = {
    DoubleXP = true,
}

function EventMath.GetBonus(eventType: any): number
    if type(eventType) ~= "string" then
        return 1.0
    end
    return BONUSES[eventType] or 1.0
end

local function getMultiplier(activeEvents: any, allowedEvents: { [string]: boolean }): number
    if type(activeEvents) ~= "table" then
        return 1.0
    end

    local multiplier = 1.0
    for _, event in pairs(activeEvents) do
        if type(event) == "table" and event.Active == true and allowedEvents[event.Type] then
            multiplier *= EventMath.GetBonus(event.Type)
        end
    end
    return multiplier
end

function EventMath.GetYieldMultiplier(activeEvents: any): number
    return getMultiplier(activeEvents, YIELD_EVENTS)
end

function EventMath.GetXPMultiplier(activeEvents: any): number
    return getMultiplier(activeEvents, XP_EVENTS)
end

return EventMath
