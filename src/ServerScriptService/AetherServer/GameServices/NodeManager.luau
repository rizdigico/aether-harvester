-- NodeManager
local NodeManager = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
local QuestService = require(game.ServerScriptService.AetherServer.GameServices.QuestService)
local AchievementService = require(game.ServerScriptService.AetherServer.GameServices.AchievementService)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local ItemsData = require(game.ReplicatedStorage.AetherShared.Data.Items)

local AetherWorld = Workspace:FindFirstChild("AetherWorld")
local IslandsFolder = AetherWorld and AetherWorld:FindFirstChild("Islands")

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
    return os.time() >= entry.cooldownUntil
end

function NodeManager.ProcessHarvest(player, node)
    local nodeType = NodeManager.GetNodeType(node)
    if not nodeType then
        return false, "Invalid node"
    end
    if not NodeManager.IsNodeAvailable(node) then
        return false, "Node is on cooldown"
    end

    -- Distance validation (P1: prevent harvesting from anywhere)
    local MAX_HARVEST_DISTANCE = 30
    local character = player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    local nodePivot = pcall(function()
        return node:GetPivot()
    end) and node:GetPivot()
    if hrp and nodePivot then
        local distance = (hrp.Position - nodePivot.Position).Magnitude
        if distance > MAX_HARVEST_DISTANCE then
            return false, "Too far from node"
        end
    end

    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "No player data"
    end

    -- Calculate yield
    local yieldAmount = math.random(nodeType.MinYield, nodeType.MaxYield)

    -- Apply harvest boost if player has it
    local boost = 1
    if PlayerDataService.GetItemCount(player, "harvest_boost") > 0 then
        boost = 1.5
    end

    yieldAmount = math.floor(yieldAmount * boost)

    -- Grant resources
    PlayerDataService.AddItem(player, nodeType.ResourceId, yieldAmount)

    -- Grant XP
    local xpGain = math.floor(nodeType.XP * boost)
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
    end

    -- Set cooldown
    activeNodes[node] = {
        type = nodeType,
        cooldownUntil = os.time() + nodeType.RespawnTime,
    }

    -- Notify client
    local Remotes = ReplicatedStorage.AetherShared.Remotes
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
            })
        end
    end

    return true, yieldAmount
end

function NodeManager.Initialize()
    print("[NodeManager] Initializing...")

    local Remotes = ReplicatedStorage.AetherShared.Remotes
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

            local success, result = NodeManager.ProcessHarvest(player, node)
            if not success then
                -- Notify error
                local ErrorRemote = Remotes:FindFirstChild("Error")
                if ErrorRemote then
                    ErrorRemote:FireClient(player, result)
                end
            end
        end)
    end

    -- Assign NodeId attributes so client raycast can identify nodes
    local nodes = NodeManager.GetAllNodes()
    for _, node in ipairs(nodes) do
        node:SetAttribute("NodeId", node.Name)
    end
    local count = #nodes
    print("[NodeManager] Discovered " .. count .. " resource nodes, NodeId attributes assigned")
end

return NodeManager
