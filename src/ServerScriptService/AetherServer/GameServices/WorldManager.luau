-- WorldManager
local WorldManager = {}
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local QuestService = require(game.ServerScriptService.AetherServer.GameServices.QuestService)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AetherWorld = Workspace:FindFirstChild("AetherWorld")
local IslandsFolder = AetherWorld and AetherWorld:FindFirstChild("Islands")

-- Island definitions (id -> {name, spawnOffset, biome})
WorldManager.IslandDefs = {
    SpawnIsland = { Name = "Spawn Island", Biome = "Safe", SpawnOffset = Vector3.new(0, 5, 0) },
    CloudGardens = { Name = "Cloud Gardens", Biome = "Meadow", SpawnOffset = Vector3.new(0, 5, 0) },
    StormPeaks = { Name = "Storm Peaks", Biome = "Mountain", SpawnOffset = Vector3.new(0, 5, 0) },
    VoidRifts = { Name = "Void Rifts", Biome = "Void", SpawnOffset = Vector3.new(0, 5, 0) },
    CrystalCanyons = { Name = "Crystal Canyons", Biome = "Crystal", SpawnOffset = Vector3.new(0, 5, 0) },
    AncientRuins = { Name = "Ancient Ruins", Biome = "Ruins", SpawnOffset = Vector3.new(0, 5, 0) },
    FloatingMarket = { Name = "Floating Market", Biome = "Town", SpawnOffset = Vector3.new(0, 5, 0) },
    CrystalSpires = { Name = "Crystal Spires", Biome = "Crystal", SpawnOffset = Vector3.new(0, 5, 0) },
    EmberPeaks = { Name = "Ember Peaks", Biome = "Volcanic", SpawnOffset = Vector3.new(0, 5, 0) },
    VerdantIsle = { Name = "Verdant Isle", Biome = "Forest", SpawnOffset = Vector3.new(0, 5, 0) },
    SkySanctum = { Name = "Sky Sanctum", Biome = "Sky", SpawnOffset = Vector3.new(0, 5, 0) },
}

local playerIslands = {}

function WorldManager.GetIslandInstance(islandId)
    if not IslandsFolder then
        return nil
    end
    return IslandsFolder:FindFirstChild(islandId)
end

function WorldManager.GetIslandDef(islandId)
    return WorldManager.IslandDefs[islandId]
end

function WorldManager.GetPlayerIsland(player)
    return playerIslands[player.UserId] or "SkySanctum"
end

function WorldManager.TeleportPlayerToIsland(player, islandId)
    local island = WorldManager.GetIslandInstance(islandId)
    if not island then
        warn("[WorldManager] Island not found: " .. islandId)
        return false
    end

    local character = player.Character
    if not character then
        return false
    end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return false
    end

    -- Find a good spawn point on the island
    local spawnPos = island:GetPivot().Position
    local spawnLoc = island:FindFirstChildOfClass("SpawnLocation")
    if spawnLoc then
        spawnPos = spawnLoc.Position
    end

    root.CFrame = CFrame.new(
        spawnPos
            + (
                WorldManager.IslandDefs[islandId] and WorldManager.IslandDefs[islandId].SpawnOffset
                or Vector3.new(0, 5, 0)
            )
    )

    playerIslands[player.UserId] = islandId

    -- Discovery is durable and unique per island. Respawns and repeated
    -- teleports must not inflate the explorer quest or zone statistic.
    local data = PlayerDataService.GetData(player)
    if data then
        data.VisitedIslands = data.VisitedIslands or {}
        if data.VisitedIslands[islandId] ~= true then
            data.VisitedIslands[islandId] = true
            data.Stats = data.Stats or {}
            data.Stats.ZonesDiscovered = (data.Stats.ZonesDiscovered or 0) + 1
            QuestService.UpdateProgress(player, "Visit", islandId, 1)
        end
    end

    -- Update HUD
    local Remotes = ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local UpdateHUD = Remotes:FindFirstChild("UpdateHUD")
        if UpdateHUD then
            UpdateHUD:FireClient(player, {
                Island = WorldManager.GetIslandDef(islandId) and WorldManager.GetIslandDef(islandId).Name or islandId,
            })
        end
    end

    return true
end

function WorldManager.Initialize()
    print("[WorldManager] Initializing...")

    -- Count real islands
    local count = 0
    if IslandsFolder then
        for _, island in ipairs(IslandsFolder:GetChildren()) do
            if WorldManager.IslandDefs[island.Name] then
                count += 1
            end
        end
    end
    print("[WorldManager] Registered " .. count .. " playable islands")

    -- Handle character spawning
    local function onCharacterAdded(player, _character)
        task.wait(0.5)
        local islandId = playerIslands[player.UserId] or "SkySanctum"
        print("[WorldManager] onCharacterAdded -> " .. islandId)
        local ok = WorldManager.TeleportPlayerToIsland(player, islandId)
        print("[WorldManager] teleport result: " .. tostring(ok))
    end

    Players.PlayerAdded:Connect(function(player)
        playerIslands[player.UserId] = "SkySanctum"
        player.CharacterAdded:Connect(function(character)
            onCharacterAdded(player, character)
        end)
        -- If character already exists
        if player.Character then
            onCharacterAdded(player, player.Character)
        end
    end)

    -- Process players already in the game (Studio play mode, script reloads)
    for _, player in ipairs(Players:GetPlayers()) do
        playerIslands[player.UserId] = "SkySanctum"
        player.CharacterAdded:Connect(function(character)
            onCharacterAdded(player, character)
        end)
        if player.Character then
            onCharacterAdded(player, player.Character)
        end
    end

    Players.PlayerRemoving:Connect(function(player)
        playerIslands[player.UserId] = nil
    end)

    -- Change island remote
    local Remotes = ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local ChangeIsland = Remotes:FindFirstChild("ChangeIsland")
        if ChangeIsland then
            ChangeIsland.OnServerEvent:Connect(function(player, islandId)
                if not RateLimiter.Check(player, "ChangeIsland", 1) then
                    return
                end
                if type(islandId) ~= "string" then
                    return
                end
                -- Validate: island must be a registered playable island with a live instance
                if not WorldManager.IslandDefs[islandId] then
                    return
                end
                if not WorldManager.GetIslandInstance(islandId) then
                    return
                end
                WorldManager.TeleportPlayerToIsland(player, islandId)
            end)
        end
    end
end

return WorldManager
