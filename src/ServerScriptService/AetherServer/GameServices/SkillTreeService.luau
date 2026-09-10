--!strict
-- Server-authoritative skill purchases and effect access.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local SkillTreeRules = require(ReplicatedStorage.AetherShared.Modules.SkillTreeRules)
local TutorialService = require(game.ServerScriptService.AetherServer.GameServices.TutorialService)

local SkillTreeService = {}
local initialized = false

local function getRemotes(): Folder?
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    local remotes = shared and shared:FindFirstChild("Remotes")
    return if remotes and remotes:IsA("Folder") then remotes else nil
end

local function getData(player: Player): any
    return PlayerDataService.GetData(player)
end

function SkillTreeService.GetSnapshot(player: Player): { [string]: any }
    local data = getData(player)
    local levels = SkillTreeRules.NormalizeLevels(data and data.Skills)
    return {
        Catalog = SkillTreeRules.GetCatalog(),
        Levels = levels,
        SkillPoints = data and math.max(0, math.floor(data.SkillPoints or 0)) or 0,
        PlayerLevel = data and math.max(1, math.floor(data.Level or 1)) or 1,
    }
end

function SkillTreeService.GetEffectTotal(player: Player, effectName: string): number
    if type(effectName) ~= "string" then
        return 0
    end
    local data = getData(player)
    local totals = SkillTreeRules.GetEffectTotals(data and data.Skills)
    return math.max(0, totals[effectName] or 0)
end

function SkillTreeService.PurchaseSkill(player: Player, skillId: string): (boolean, string, number?)
    local data = getData(player)
    if not data then
        return false, "Player data is still loading"
    end
    data.Skills = SkillTreeRules.NormalizeLevels(data.Skills)
    local canPurchase, reason = SkillTreeRules.CanPurchase(skillId, data.Skills, data.SkillPoints, data.Level)
    if not canPurchase then
        return false, reason
    end

    data.SkillPoints -= 1
    local definition = SkillTreeRules.GetDefinition(skillId)
    local nextLevel = (data.Skills[skillId] or 0) + 1
    data.Skills[skillId] = math.min(definition.MaxLevel, nextLevel)
    TutorialService.MarkAction(player, "Upgrade")
    return true, "Skill purchased", data.Skills[skillId]
end

function SkillTreeService.Initialize()
    if initialized then
        return
    end
    initialized = true
    print("[SkillTreeService] Initializing...")

    local remotes = getRemotes()
    local getSkillTree = remotes and remotes:FindFirstChild("GetSkillTree")
    if getSkillTree and getSkillTree:IsA("RemoteFunction") then
        getSkillTree.OnServerInvoke = function(player)
            return SkillTreeService.GetSnapshot(player)
        end
    end

    local purchaseSkill = remotes and remotes:FindFirstChild("PurchaseSkill")
    if purchaseSkill and purchaseSkill:IsA("RemoteEvent") then
        purchaseSkill.OnServerEvent:Connect(function(player, skillId)
            if type(skillId) ~= "string" or not RateLimiter.Check(player, "PurchaseSkill", 0.5) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message, level = SkillTreeService.PurchaseSkill(player, skillId)
            if not success then
                local errorRemote = remotes and remotes:FindFirstChild("Error")
                if errorRemote and errorRemote:IsA("RemoteEvent") then
                    errorRemote:FireClient(player, message)
                end
                return
            end

            local skillPurchased = remotes and remotes:FindFirstChild("SkillPurchased")
            if skillPurchased and skillPurchased:IsA("RemoteEvent") then
                skillPurchased:FireClient(player, skillId, level, SkillTreeService.GetSnapshot(player))
            end
        end)
    end

    print("[SkillTreeService] Initialized with server-owned skill catalog")
end

return SkillTreeService
