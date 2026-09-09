--!strict
-- Engine-free skill catalog, progression gates, and effect arithmetic.

local SkillTreeRules = {}

SkillTreeRules.MAX_SKILL_LEVEL = 5

local CATALOG = {
    harvest_precision = {
        Id = "harvest_precision",
        Name = "Harvest Precision",
        Branch = "Harvesting",
        Description = "+5% harvest yield per rank",
        MaxLevel = 5,
        RequiredLevel = 1,
        Effect = { HarvestYield = 0.05 },
    },
    harvest_rhythm = {
        Id = "harvest_rhythm",
        Name = "Harvest Rhythm",
        Branch = "Harvesting",
        Description = "+4% harvest speed per rank",
        MaxLevel = 5,
        RequiredLevel = 5,
        Prerequisites = { { Id = "harvest_precision", Level = 2 } },
        Effect = { HarvestSpeed = 0.04 },
    },
    aether_reserves = {
        Id = "aether_reserves",
        Name = "Aether Reserves",
        Branch = "Vitality",
        Description = "+5 maximum energy per rank",
        MaxLevel = 5,
        RequiredLevel = 1,
        Effect = { MaxEnergy = 5 },
    },
    aether_recovery = {
        Id = "aether_recovery",
        Name = "Aether Recovery",
        Branch = "Vitality",
        Description = "+5% energy regeneration per rank",
        MaxLevel = 5,
        RequiredLevel = 10,
        Prerequisites = { { Id = "aether_reserves", Level = 2 } },
        Effect = { EnergyRegen = 0.05 },
    },
    tool_attunement = {
        Id = "tool_attunement",
        Name = "Tool Attunement",
        Branch = "Mastery",
        Description = "+5% tool output per rank",
        MaxLevel = 5,
        RequiredLevel = 1,
        Effect = { ToolPower = 0.05 },
    },
    efficient_strikes = {
        Id = "efficient_strikes",
        Name = "Efficient Strikes",
        Branch = "Mastery",
        Description = "-5% harvest energy cost per rank",
        MaxLevel = 5,
        RequiredLevel = 8,
        Prerequisites = { { Id = "tool_attunement", Level = 2 } },
        Effect = { EnergyEfficiency = 0.05 },
    },
}

local function isFiniteNumber(value: any): boolean
    return type(value) == "number" and value == value and value < math.huge and value > -math.huge
end

local function copy(value: any): any
    if type(value) ~= "table" then
        return value
    end
    local result = {}
    for key, child in pairs(value) do
        result[key] = copy(child)
    end
    return result
end

function SkillTreeRules.GetDefinition(skillId: any): any
    if type(skillId) ~= "string" then
        return nil
    end
    return CATALOG[skillId]
end

function SkillTreeRules.GetCatalog(): { [string]: any }
    local result: { [string]: any } = {}
    for skillId, definition in pairs(CATALOG) do
        result[skillId] = copy(definition)
    end
    return result
end

function SkillTreeRules.NormalizeLevels(raw: any): { [string]: number }
    local levels: { [string]: number } = {}
    if type(raw) ~= "table" then
        return levels
    end
    for skillId, definition in pairs(CATALOG) do
        local value = raw[skillId]
        if isFiniteNumber(value) then
            levels[skillId] = math.clamp(math.floor(value), 0, definition.MaxLevel)
        end
    end
    return levels
end

function SkillTreeRules.GetLevel(levels: any, skillId: any): number
    if type(levels) ~= "table" or type(skillId) ~= "string" then
        return 0
    end
    local definition = CATALOG[skillId]
    local value = levels[skillId]
    if not definition or not isFiniteNumber(value) then
        return 0
    end
    return math.clamp(math.floor(value), 0, definition.MaxLevel)
end

function SkillTreeRules.CanPurchase(skillId: any, levels: any, skillPoints: any, playerLevel: any): (boolean, string)
    local definition = SkillTreeRules.GetDefinition(skillId)
    if not definition then
        return false, "Invalid skill"
    end
    if not isFiniteNumber(skillPoints) or skillPoints < 1 then
        return false, "No skill points available"
    end
    if not isFiniteNumber(playerLevel) or playerLevel < definition.RequiredLevel then
        return false, "Player level is too low"
    end

    local currentLevel = SkillTreeRules.GetLevel(levels, skillId)
    if currentLevel >= definition.MaxLevel then
        return false, "Skill maxed out"
    end

    for _, prerequisite in ipairs(definition.Prerequisites or {}) do
        if SkillTreeRules.GetLevel(levels, prerequisite.Id) < prerequisite.Level then
            return false, "Prerequisite skill is not ready"
        end
    end
    return true, "Skill can be purchased"
end

function SkillTreeRules.GetEffectTotals(levels: any): { [string]: number }
    local normalized = SkillTreeRules.NormalizeLevels(levels)
    local totals: { [string]: number } = {}
    for skillId, definition in pairs(CATALOG) do
        local level = normalized[skillId] or 0
        for effectName, value in pairs(definition.Effect or {}) do
            if isFiniteNumber(value) and value > 0 then
                totals[effectName] = (totals[effectName] or 0) + value * level
            end
        end
    end
    return totals
end

return SkillTreeRules
