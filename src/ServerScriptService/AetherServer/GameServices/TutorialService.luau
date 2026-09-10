-- Server-owned first-five-minutes progression. Tutorial state is persisted in
-- the player profile, but it never grants currency or items by itself.
local TutorialService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local TutorialRules = require(ReplicatedStorage.AetherShared.Modules.TutorialRules)

local Remotes

local function snapshotFor(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return nil
    end

    local state = TutorialRules.NormalizeState(data.Tutorial)
    data.Tutorial = state
    local step = TutorialRules.GetStep(state.Step)
    return {
        Step = state.Step,
        TotalSteps = TutorialRules.GetStepCount(),
        Completed = state.Completed,
        Action = step and step.Action or nil,
        Title = step and step.Title or "Expedition ready",
        Body = step and step.Body or "Your first expedition is complete. Keep exploring.",
        Progress = state.Step,
    }
end

function TutorialService.GetSnapshot(player)
    return snapshotFor(player)
end

function TutorialService.Sync(player)
    local snapshot = snapshotFor(player)
    local updated = Remotes and Remotes:FindFirstChild("TutorialUpdated")
    if snapshot and updated then
        updated:FireClient(player, snapshot)
    end
    return snapshot
end

function TutorialService.MarkAction(player, action)
    if not TutorialRules.IsKnownAction(action) then
        return false
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false
    end

    local nextState, advanced = TutorialRules.Advance(data.Tutorial, action)
    if not advanced then
        return false
    end
    data.Tutorial = nextState
    TutorialService.Sync(player)
    print(
        string.format(
            "[TutorialService] %s advanced to step %d/%d via %s",
            player.Name,
            nextState.Step,
            TutorialRules.GetStepCount(),
            action
        )
    )
    return true
end

function TutorialService.OnPlayerAdded(player)
    TutorialService.Sync(player)
end

function TutorialService.OnPlayerRemoving(_player)
    -- The state lives in PlayerDataService and is saved by its leave hook.
end

function TutorialService.Initialize()
    print("[TutorialService] Initializing...")
    Remotes = ReplicatedStorage.AetherShared.Remotes
    if not Remotes then
        return
    end

    local tutorialAction = Remotes:FindFirstChild("TutorialAction")
    if tutorialAction then
        tutorialAction.OnServerEvent:Connect(function(player, action)
            if type(action) == "string" then
                TutorialService.MarkAction(player, action)
            end
        end)
    end

    local getTutorial = Remotes:FindFirstChild("GetTutorial")
    if getTutorial then
        getTutorial.OnServerInvoke = function(player)
            return TutorialService.GetSnapshot(player)
        end
    end

    print("[TutorialService] Initialized with " .. TutorialRules.GetStepCount() .. " guided steps")
end

return TutorialService
