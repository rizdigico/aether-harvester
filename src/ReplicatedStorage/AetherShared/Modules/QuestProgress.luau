--!strict
-- Pure quest-progression math for Aether Harvester.
-- NO Roblox engine dependencies: unit-testable under Lune and TestEZ.
-- Mirrors the objective-accumulation + completion logic previously embedded in
-- QuestService.UpdateProgress so it can be unit-tested headlessly.
--
-- Conventions (shared with QuestService):
--   * Objectives are an array (1..N); progressTable[i] tracks objective i.
--   * An objective is met when progress >= objective.Amount (default 1).
--   * `completed` is true only when EVERY objective is met.
--   * `done`/`total` are clamped sums (progress never exceeds its Amount), used
--     by the UI to render "X / Y" without showing over-completion.

local QuestProgress = {}

export type Objective = {
    Type: string?,
    ItemId: string?,
    CreatureId: string?,
    CreatureRarity: string?,
    IslandId: string?,
    Action: string?,
    Amount: number?,
}

export type QuestDef = {
    Objectives: { Objective }?,
}

export type ProgressResult = {
    completed: boolean,
    done: number,
    total: number,
}

-- Does an objective match the event being reported?
-- Mirrors QuestService.UpdateProgress's inline matching (Harvest/Collect by
-- ItemId, Tame/Defeat by CreatureId, DefeatRarity by CreatureRarity, and a
-- permissive fallback for Visit/unknown types).
function QuestProgress.MatchesObjective(objective: Objective, objectiveType: string, target: string?): boolean
    if objective.Type ~= objectiveType then
        return false
    end

    if objectiveType == "Harvest" or objectiveType == "Collect" then
        return objective.ItemId == nil or objective.ItemId == target
    elseif objectiveType == "Tame" or objectiveType == "Defeat" then
        return objective.CreatureId == nil or objective.CreatureId == target
    elseif objectiveType == "DefeatRarity" then
        return objective.CreatureRarity ~= nil and objective.CreatureRarity == target
    else
        -- Visit, Guild, Craft, Deliver, and unknown types count by type only.
        return true
    end
end

-- Compute quest completion + clamped progress summary.
function QuestProgress.ComputeQuestProgress(questDef: QuestDef?, progressTable: { number }?): ProgressResult
    local objectives = questDef and questDef.Objectives or {}
    local done = 0
    local total = 0
    local completed = true

    for i, objective in ipairs(objectives) do
        local amount = objective.Amount or 1
        local raw = progressTable and progressTable[i] or 0
        total += amount
        done += math.min(raw, amount)
        if raw < amount then
            completed = false
        end
    end

    return { completed = completed, done = done, total = total }
end

-- Clamp a single objective's progress display value to its Amount.
function QuestProgress.ClampObjectiveProgress(progress: number?, amount: number?): number
    return math.min(progress or 0, amount or 1)
end

return QuestProgress
