-- Pure tutorial progression rules shared by the server and tests.
local TutorialRules = {}

local STEPS = {
    {
        Action = "Move",
        Title = "Find your footing",
        Body = "Move around the island to reach the nearest resource node.",
    },
    {
        Action = "Harvest",
        Title = "Harvest Aether",
        Body = "Use the Harvest prompt or press E while looking at a resource node.",
    },
    {
        Action = "Upgrade",
        Title = "Improve your tool",
        Body = "Open the Skill Tree and spend a skill point on an upgrade after you level up.",
    },
    {
        Action = "Travel",
        Title = "Explore the sky",
        Body = "Travel to another island from the Map.",
    },
    {
        Action = "Pet",
        Title = "Bring a companion",
        Body = "Tame or equip a creature to finish your first expedition.",
    },
}

local KNOWN_ACTIONS = {}
for _, step in ipairs(STEPS) do
    KNOWN_ACTIONS[step.Action] = true
end

local function clampStep(value)
    if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
        return 0
    end
    return math.clamp(math.floor(value), 0, #STEPS)
end

function TutorialRules.GetStepCount()
    return #STEPS
end

function TutorialRules.GetStep(step)
    return STEPS[clampStep(step) + 1]
end

function TutorialRules.IsKnownAction(action)
    return type(action) == "string" and KNOWN_ACTIONS[action] == true
end

function TutorialRules.CreateState()
    return { Step = 0, Completed = false }
end

function TutorialRules.NormalizeState(raw)
    local step = clampStep(type(raw) == "table" and raw.Step or 0)
    local completed = type(raw) == "table" and raw.Completed == true or false
    if step >= #STEPS then
        step = #STEPS
        completed = true
    end
    return { Step = step, Completed = completed }
end

function TutorialRules.Advance(raw, action)
    local state = TutorialRules.NormalizeState(raw)
    if state.Completed or not TutorialRules.IsKnownAction(action) then
        return state, false
    end

    local expected = TutorialRules.GetStep(state.Step)
    if not expected or expected.Action ~= action then
        return state, false
    end

    state.Step += 1
    state.Completed = state.Step >= #STEPS
    return state, true
end

return TutorialRules
