local TutorialRules = require("../../src/ReplicatedStorage/AetherShared/Modules/TutorialRules")

local function expectEqual(actual, expected, message)
    assert(actual == expected, string.format("%s: expected %s, got %s", message, tostring(expected), tostring(actual)))
end

return {
    {
        name = "TutorialRules.NormalizeState",
        tests = {
            {
                name = "clamps malformed progress and preserves completion",
                fn = function()
                    local state = TutorialRules.NormalizeState({ Step = 99.8 })
                    expectEqual(state.Step, TutorialRules.GetStepCount(), "upper clamp")
                    expectEqual(state.Completed, true, "clamped completion")

                    state = TutorialRules.NormalizeState({ Step = -4, Completed = true })
                    expectEqual(state.Step, 0, "lower clamp")
                    expectEqual(state.Completed, true, "explicit completion")
                end,
            },
        },
    },
    {
        name = "TutorialRules.Advance",
        tests = {
            {
                name = "requires the current action and advances once per step",
                fn = function()
                    local state, advanced = TutorialRules.Advance(nil, "Harvest")
                    expectEqual(advanced, false, "out-of-order action")
                    expectEqual(state.Step, 0, "unchanged step")

                    state, advanced = TutorialRules.Advance(state, "Move")
                    expectEqual(advanced, true, "move action")
                    expectEqual(state.Step, 1, "next step")

                    state, advanced = TutorialRules.Advance(state, "Move")
                    expectEqual(advanced, false, "duplicate action")
                    expectEqual(state.Step, 1, "duplicate unchanged")
                end,
            },
            {
                name = "completes after every guided action",
                fn = function()
                    local state = TutorialRules.CreateState()
                    for _, action in ipairs({ "Move", "Harvest", "Upgrade", "Travel", "Pet" }) do
                        local nextState, advanced = TutorialRules.Advance(state, action)
                        expectEqual(advanced, true, action .. " accepted")
                        state = nextState
                    end
                    expectEqual(state.Step, TutorialRules.GetStepCount(), "completed step count")
                    expectEqual(state.Completed, true, "completed flag")

                    local _, advanced = TutorialRules.Advance(state, "Pet")
                    expectEqual(advanced, false, "completed tutorial is immutable")
                end,
            },
        },
    },
}
