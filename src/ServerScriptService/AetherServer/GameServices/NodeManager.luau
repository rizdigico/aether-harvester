-- NodeManager
local NodeManager = {}

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
local QuestService = require(game.ServerScriptService.AetherServer.GameServices.QuestService)
local AchievementService = require(game.ServerScriptService.AetherServer.GameServices.AchievementService)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local EventService = require(game.ServerScriptService.AetherServer.GameServices.EventService)
local PetService = require(game.ServerScriptService.AetherServer.GameServices.PetService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local MonetizationService = require(game.ServerScriptService.AetherServer.GameServices.MonetizationService)
local UpgradeService = require(game.ServerScriptService.AetherServer.GameServices.UpgradeService)
local PlayerVitalsService = require(game.ServerScriptService.AetherServer.GameServices.PlayerVitalsService)
local ToolService = require(game.ServerScriptService.AetherServer.GameServices.ToolService)
local SkillTreeService = require(game.ServerScriptService.AetherServer.GameServices.SkillTreeService)
local TutorialService = require(game.ServerScriptService.AetherServer.GameServices.TutorialService)
local AetherWorld = Workspace:FindFirstChild("AetherWorld")
local IslandsFolder = AetherWorld and AetherWorld:FindFirstChild("Islands")
local MAX_HARVEST_DISTANCE = 30

-- Node config: prefix -> {resourceId, baseYield, minYield, maxYield, respawnTime, xp}
NodeManager.NodeTypes = {
    AetherNode = { ResourceId = "aether_shard", MinYield = 1, MaxYield = 3, RespawnTime = 30, XP = 10 },
    CrystalNode = { ResourceId = "crystal_fragment", MinYield = 1, MaxYield = 2, RespawnTime = 45, XP = 15 },
    OreNode = { ResourceId = "volcanic_ore", MinYield = 1, MaxYield = 2, RespawnTime = 60, XP = 25 },
    HerbNode = { ResourceId = "ancient_wood", MinYield = 1, MaxYield = 3, RespawnTime = 40, XP = 12 },
    Tree = { ResourceId = "ancient_wood", MinYield = 1, MaxYield = 3, RespawnTime = 50, XP = 10 },
    Rock = { ResourceId = "aether_shard", MinYield = 1, MaxYield = 2, RespawnTime = 35, XP = 8 },
}

local activeNodes = {} -- node instance -> {type, cooldownUntil}

local function getRemotes()
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    return shared and shared:FindFirstChild("Remotes")
end

local function notifyError(player, message)
    local remotes = getRemotes()
    local errorRemote = remotes and remotes:FindFirstChild("Error")
    if errorRemote then
        errorRemote:FireClient(player, message)
    end
end

local function getHarvestCooldown(player)
    return UpgradeService.GetHarvestCooldown(player) * ToolService.GetHarvestCooldownMultiplier(player)
end

local function getPromptParent(node)
    for _, childName in ipairs({ "Base", "Core", "ResourceNode_1" }) do
        local child = node:FindFirstChild(childName, true)
        if child and child:IsA("BasePart") then
            return child
        end
    end
    return node:FindFirstChildWhichIsA("BasePart", true)
end

local function setNodeAvailable(node, available)
    if not node or not node.Parent then
        return
    end
    node:SetAttribute("HarvestAvailable", available)
    local prompt = node:FindFirstChild("HarvestPrompt", true)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.Enabled = available
    end
end

local function scheduleRespawn(node, nodeType)
    task.delay(nodeType.RespawnTime, function()
        local entry = activeNodes[node]
        if not node.Parent or not entry or entry.type ~= nodeType then
            return
        end
        activeNodes[node] = nil
        setNodeAvailable(node, true)
    end)
end

function NodeManager.GetAllNodes()
    local nodes = {}
    if not IslandsFolder then
        return nodes
    end
    for _, child in ipairs(IslandsFolder:GetChildren()) do
        if child:IsA("Model") and NodeManager.NodeTypes[child.Name:match("^%a+")] then
            table.insert(nodes, child)
        end
    end
    return nodes
end

function NodeManager.GetNodeType(node)
    if not node then
        return nil
    end
    local prefix = node.Name:match("^%a+")
    return NodeManager.NodeTypes[prefix]
end

function NodeManager.IsNodeAvailable(node)
    local entry = activeNodes[node]
    if not entry then
        return true
    end
    if os.time() >= entry.cooldownUntil then
        activeNodes[node] = nil
        setNodeAvailable(node, true)
        return true
    end
    return false
end

function NodeManager.ProcessHarvest(player, node)
    if
        typeof(node) ~= "Instance"
        or not node:IsA("Model")
        or not IslandsFolder
        or not node:IsDescendantOf(IslandsFolder)
    then
        return false, "Invalid node"
    end

    local nodeType = NodeManager.GetNodeType(node)
    if not nodeType then
        return false, "Invalid node"
    end
    if not NodeManager.IsNodeAvailable(node) then
        return false, "Node is on cooldown"
    end

    -- Distance validation (P1: prevent harvesting from anywhere). A missing
    -- character/root is also rejected; otherwise a client could harvest while
    -- its avatar is not in the world at all.
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not hrp or not hrp:IsA("BasePart") then
        return false, "Character is not ready"
    end
    local pivotOk, nodePivot = pcall(function()
        return node:GetPivot()
    end)
    if not pivotOk or not nodePivot then
        return false, "Invalid node position"
    end
    local distance = (hrp.Position - nodePivot.Position).Magnitude
    if distance > MAX_HARVEST_DISTANCE then
        return false, "Too far from node"
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "No player data"
    end

    local toolReady, toolError = ToolService.CanHarvest(player)
    if not toolReady then
        return false, toolError
    end

    local harvestEnergyCost = PlayerVitalsService.GetHarvestEnergyCost(player)
    local spentEnergy, energyError = PlayerVitalsService.ConsumeEnergy(player, harvestEnergyCost)
    if not spentEnergy then
        return false, energyError
    end

    -- Calculate yield
    local yieldAmount = math.random(nodeType.MinYield, nodeType.MaxYield)

    -- Apply harvest boost if player has it
    local boost = 1
    if PlayerDataService.GetItemCount(player, "harvest_boost") > 0 then
        boost = 1.5
    end

    -- Apply equipped-pet HarvestPower bonus (PetService.GetPetBonuses, PetService.luau:292-304).
    -- Handles the no-pet case gracefully: GetPetBonuses returns 0s when nothing is equipped.
    local petBonuses = PetService.GetPetBonuses(player)
    local harvestPower = petBonuses and petBonuses.HarvestPower or 0
    local petMultiplier = 1 + harvestPower / 100

    local harvestComfortMultiplier = MonetizationService.GetHarvestMultiplier(player)
    local upgradeMultiplier = UpgradeService.GetHarvestYieldMultiplier(player)
    local skillMultiplier = 1 + math.clamp(SkillTreeService.GetEffectTotal(player, "HarvestYield"), 0, 2)
    yieldAmount = math.floor(
        yieldAmount
            * boost
            * harvestComfortMultiplier
            * EventService.GetActiveYieldMultiplier()
            * petMultiplier
            * upgradeMultiplier
            * skillMultiplier
            * ToolService.GetHarvestYieldMultiplier(player)
    )

    -- Grant resources. Do not put a node reward into the currency wallet:
    -- resources are inventory items and are consumed by crafting/trading.
    if not PlayerDataService.AddItem(player, nodeType.ResourceId, yieldAmount) then
        PlayerVitalsService.RestoreEnergy(player, harvestEnergyCost)
        return false, "Unable to grant resource"
    end

    if not ToolService.ConsumeDurability(player) then
        PlayerDataService.RemoveItem(player, nodeType.ResourceId, yieldAmount)
        PlayerVitalsService.RestoreEnergy(player, harvestEnergyCost)
        return false, "Unable to use equipped tool"
    end

    -- Grant XP
    local xpGain = math.floor(nodeType.XP * boost * harvestComfortMultiplier * EventService.GetActiveXPMultiplier())
    ProgressionService.AddXP(player, xpGain)

    -- Track stats
    PlayerDataService.IncrementStat(player, "HarvestCount", 1)

    -- Check achievements after harvest
    if AchievementService.CheckAllAchievements then
        AchievementService.CheckAllAchievements(player)
    end

    -- Anti-cheat heartbeat (wired: previously dead code)
    if AntiCheatService and AntiCheatService.CheckPlayer then
        AntiCheatService:CheckPlayer(player)
    end

    -- Update quests
    if QuestService.UpdateProgress then
        QuestService.UpdateProgress(player, "Harvest", nodeType.ResourceId, yieldAmount)
        QuestService.UpdateProgress(player, "Collect", nodeType.ResourceId, yieldAmount)
    end
    TutorialService.MarkAction(player, "Harvest")

    -- Set cooldown
    activeNodes[node] = {
        type = nodeType,
        cooldownUntil = os.time() + nodeType.RespawnTime,
    }
    setNodeAvailable(node, false)
    scheduleRespawn(node, nodeType)

    -- Notify client
    local Remotes = getRemotes()
    if Remotes then
        local NodeHarvested = Remotes:FindFirstChild("NodeHarvested")
        if NodeHarvested then
            NodeHarvested:FireClient(player, node.Name, { [nodeType.ResourceId] = yieldAmount })
        end

        local UpdateHUD = Remotes:FindFirstChild("UpdateHUD")
        if UpdateHUD then
            UpdateHUD:FireClient(player, {
                XP = data.XP,
                Level = data.Level,
                Currency = data.Currency,
                Energy = data.Energy,
                MaxEnergy = data.MaxEnergy,
            })
        end
    end

    return true, yieldAmount
end

function NodeManager.Initialize()
    print("[NodeManager] Initializing...")

    local Remotes = getRemotes()
    if not Remotes then
        return
    end

    local HarvestResource = Remotes:FindFirstChild("HarvestResource")
    if HarvestResource then
        HarvestResource.OnServerEvent:Connect(function(player, nodeRef)
            -- Accept node instance or node name
            local node = nodeRef
            if type(nodeRef) == "string" then
                node = nil
                if IslandsFolder then
                    node = IslandsFolder:FindFirstChild(nodeRef)
                end
            end
            if not node then
                return
            end

            -- Rate limit: max one harvest per second per player
            if not RateLimiter.Check(player, "HarvestResource", getHarvestCooldown(player)) then
                return
            end

            local success, result = NodeManager.ProcessHarvest(player, node)
            if not success then
                notifyError(player, result)
            end
        end)
    end

    -- Assign NodeId attributes and server-owned ProximityPrompts so the same
    -- interaction works for keyboard, touch, controller, and accessibility
    -- users. The prompt calls the same validated server path as the RemoteEvent.
    local nodes = NodeManager.GetAllNodes()
    for _, node in ipairs(nodes) do
        node:SetAttribute("NodeId", node.Name)
        if node:GetAttribute("HarvestAvailable") == nil then
            node:SetAttribute("HarvestAvailable", true)
        end

        local promptParent = getPromptParent(node)
        if promptParent then
            local prompt = promptParent:FindFirstChild("HarvestPrompt")
            if not prompt then
                prompt = Instance.new("ProximityPrompt")
                prompt.Name = "HarvestPrompt"
                prompt.ActionText = "Harvest"
                prompt.ObjectText = node.Name:gsub("_%d+$", "")
                prompt.KeyboardKeyCode = Enum.KeyCode.E
                prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
                prompt.HoldDuration = 0.15
                prompt.MaxActivationDistance = 18
                prompt.RequiresLineOfSight = false
                prompt.Parent = promptParent
                prompt.Triggered:Connect(function(player)
                    if not RateLimiter.Check(player, "HarvestResource", getHarvestCooldown(player)) then
                        return
                    end
                    local success, result = NodeManager.ProcessHarvest(player, node)
                    if not success then
                        notifyError(player, result)
                    end
                end)
            end
            setNodeAvailable(node, node:GetAttribute("HarvestAvailable") ~= false)
        end
    end
    local count = #nodes
    print("[NodeManager] Discovered " .. count .. " resource nodes, NodeId attributes assigned")
end

return NodeManager
