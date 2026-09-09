--!strict
-- Server-authoritative equipped-tool and durability handling.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local ItemsData = require(ReplicatedStorage.AetherShared.Data.Items)
local ToolRules = require(ReplicatedStorage.AetherShared.Modules.ToolRules)
local SkillTreeService = require(game.ServerScriptService.AetherServer.GameServices.SkillTreeService)

local ToolService = {}
local initialized = false

type ToolSnapshot = {
    EquippedTool: string?,
    Durability: number,
    MaxDurability: number,
    Tools: { string },
}

local function getRemotes()
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    return shared and shared:FindFirstChild("Remotes")
end

local function getData(player)
    return PlayerDataService.GetData(player)
end

local function getOwnedToolIds(data)
    local result = {}
    if not data then
        return result
    end
    for itemId, count in pairs(data.Inventory or {}) do
        local definition = ItemsData.GetItem(itemId)
        if definition and definition.Type == "Tool" and type(count) == "number" and count >= 1 then
            table.insert(result, itemId)
        end
    end
    table.sort(result)
    return result
end

local function getToolDefinition(player, toolId)
    local data = getData(player)
    if not data or type(toolId) ~= "string" then
        return nil
    end
    if (data.Inventory and data.Inventory[toolId] or 0) < 1 then
        return nil
    end
    local definition = ItemsData.GetItem(toolId)
    if not definition or definition.Type ~= "Tool" then
        return nil
    end
    return definition
end

local function getSnapshot(player): ToolSnapshot?
    local data = getData(player)
    if not data then
        return nil
    end
    local toolId = data.EquippedTool
    local definition = getToolDefinition(player, toolId)
    if not definition then
        toolId = ToolRules.DEFAULT_TOOL_ID
        definition = getToolDefinition(player, toolId)
    end
    if not definition then
        return { EquippedTool = nil, Durability = 0, MaxDurability = 0, Tools = getOwnedToolIds(data) }
    end
    data.EquippedTool = toolId
    data.ToolDurability = data.ToolDurability or {}
    local maxDurability = definition.Durability or 1
    local durability = ToolRules.NormalizeDurability(data.ToolDurability[toolId], maxDurability)
    data.ToolDurability[toolId] = durability
    return {
        EquippedTool = toolId,
        Durability = durability,
        MaxDurability = maxDurability,
        Tools = getOwnedToolIds(data),
    }
end

local function notifyTool(player)
    local snapshot = getSnapshot(player)
    local remotes = getRemotes()
    local toolUpdated = remotes and remotes:FindFirstChild("ToolUpdated")
    if snapshot and toolUpdated and toolUpdated:IsA("RemoteEvent") then
        toolUpdated:FireClient(player, snapshot)
    end
    return snapshot
end

function ToolService.GetSnapshot(player)
    return getSnapshot(player)
end

function ToolService.RepairTool(player, toolId)
    local data = getData(player)
    local definition = getToolDefinition(player, toolId)
    if not data or not definition then
        return false, "You do not own that tool"
    end

    data.ToolDurability = data.ToolDurability or {}
    local maximum = math.max(1, math.floor(definition.Durability or 1))
    local current = ToolRules.NormalizeDurability(data.ToolDurability[toolId], maximum)
    local balance = data.Currency and data.Currency.AetherShards or 0
    local canRepair, cost, reason = ToolRules.CanRepair(current, maximum, definition.Value, balance)
    if not canRepair then
        return false, reason
    end
    if not PlayerDataService.RemoveCurrency(player, "AetherShards", cost) then
        return false, "Not enough currency"
    end
    data.ToolDurability[toolId] = maximum
    local snapshot = if data.EquippedTool == toolId then notifyTool(player) else nil
    return true, "Tool repaired", snapshot
end

function ToolService.GetEquippedDefinition(player)
    local snapshot = getSnapshot(player)
    return snapshot and snapshot.EquippedTool and ItemsData.GetItem(snapshot.EquippedTool) or nil
end

function ToolService.EquipTool(player, toolId)
    local data = getData(player)
    local definition = getToolDefinition(player, toolId)
    local canEquip, message = ToolRules.CanEquip(toolId, data and data.Inventory and data.Inventory[toolId], definition)
    if not canEquip or not definition then
        return false, message
    end

    data.EquippedTool = toolId
    data.ToolDurability = data.ToolDurability or {}
    data.ToolDurability[toolId] = ToolRules.NormalizeDurability(data.ToolDurability[toolId], definition.Durability)
    return true, "Tool equipped", notifyTool(player)
end

function ToolService.CanHarvest(player)
    local definition = ToolService.GetEquippedDefinition(player)
    local snapshot = getSnapshot(player)
    if not definition or not snapshot then
        return false, "Equip a harvesting tool first"
    end
    if not ToolRules.CanUse(snapshot.Durability, snapshot.MaxDurability) then
        return false, "That tool is broken"
    end
    return true, "Tool ready"
end

function ToolService.ConsumeDurability(player)
    local data = getData(player)
    local snapshot = getSnapshot(player)
    if not data or not snapshot or not snapshot.EquippedTool then
        return false
    end
    if not ToolRules.CanUse(snapshot.Durability, snapshot.MaxDurability) then
        return false
    end
    data.ToolDurability[snapshot.EquippedTool] = snapshot.Durability - 1
    notifyTool(player)
    return true
end

function ToolService.GetHarvestYieldMultiplier(player)
    local definition = ToolService.GetEquippedDefinition(player)
    local skillBonus = math.clamp(SkillTreeService.GetEffectTotal(player, "ToolPower"), 0, 2)
    return ToolRules.GetYieldMultiplier(definition and definition.Power) * (1 + skillBonus)
end

function ToolService.GetHarvestCooldownMultiplier(player)
    local definition = ToolService.GetEquippedDefinition(player)
    local base = ToolRules.GetCooldownMultiplier(definition and definition.Speed)
    local skillBonus = math.clamp(SkillTreeService.GetEffectTotal(player, "HarvestSpeed"), 0, 1)
    return base / (1 + skillBonus)
end

function ToolService.Initialize()
    if initialized then
        return
    end
    initialized = true
    print("[ToolService] Initializing...")

    local remotes = getRemotes()
    local getTool = remotes and remotes:FindFirstChild("GetTool")
    if getTool and getTool:IsA("RemoteFunction") then
        getTool.OnServerInvoke = function(player)
            return ToolService.GetSnapshot(player)
        end
    end

    local equipTool = remotes and remotes:FindFirstChild("EquipTool")
    if equipTool and equipTool:IsA("RemoteEvent") then
        equipTool.OnServerEvent:Connect(function(player, toolId)
            if type(toolId) ~= "string" or not RateLimiter.Check(player, "EquipTool", 0.25) then
                return
            end
            local success, message = ToolService.EquipTool(player, toolId)
            if not success then
                local errorRemote = remotes:FindFirstChild("Error")
                if errorRemote and errorRemote:IsA("RemoteEvent") then
                    errorRemote:FireClient(player, message)
                end
            end
        end)
    end

    local repairTool = remotes and remotes:FindFirstChild("RepairTool")
    if repairTool and repairTool:IsA("RemoteEvent") then
        repairTool.OnServerEvent:Connect(function(player, toolId)
            if type(toolId) ~= "string" or not RateLimiter.Check(player, "RepairTool", 0.5) then
                return
            end
            local success, message = ToolService.RepairTool(player, toolId)
            if not success then
                local errorRemote = remotes and remotes:FindFirstChild("Error")
                if errorRemote and errorRemote:IsA("RemoteEvent") then
                    errorRemote:FireClient(player, message)
                end
            end
        end)
    end

    print("[ToolService] Initialized")
end

return ToolService
