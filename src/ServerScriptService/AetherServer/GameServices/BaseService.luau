--!strict
-- Server-authoritative personal base storage, placement, and rendering.

local BaseService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local ItemsData = require(ReplicatedStorage.AetherShared.Data.Items)
local BaseRules = require(ReplicatedStorage.AetherShared.Modules.BaseRules)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)

local baseFolder = Workspace:FindFirstChild("AetherPlayerBases")
if not baseFolder then
    baseFolder = Instance.new("Folder")
    baseFolder.Name = "AetherPlayerBases"
    baseFolder.Parent = Workspace
end

local baseModels: { [number]: Model } = {}

local function getRemotes(): Folder?
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    local remotes = shared and shared:FindFirstChild("Remotes")
    return if remotes and remotes:IsA("Folder") then remotes else nil
end

local function fireError(player: Player, message: string)
    local remotes = getRemotes()
    local errorRemote = remotes and remotes:FindFirstChild("Error")
    if errorRemote and errorRemote:IsA("RemoteEvent") then
        errorRemote:FireClient(player, message)
    end
end

local function getAnchor(userId: number): Vector3
    -- Stable hub slots keep bases separated while avoiding any client-provided
    -- world coordinate. Slots are only an address; placement stays grid-bound.
    local slot = userId % 64
    local x = (slot % 8 - 3.5) * 80
    local z = (math.floor(slot / 8) - 3.5) * 80
    return Vector3.new(x, 250, z)
end

local function getProfileBase(player: Player): any
    local data = PlayerDataService.GetData(player)
    if not data then
        return nil
    end
    data.Base = type(data.Base) == "table" and data.Base or { Level = 1, Decorations = {} }
    data.Base.Decorations = type(data.Base.Decorations) == "table" and data.Base.Decorations or {}
    return data.Base
end

local function findDecoration(base: any, decorationId: number): (number?, any)
    for index, decoration in ipairs(base.Decorations) do
        if type(decoration) == "table" and decoration.Id == decorationId then
            return index, decoration
        end
    end
    return nil, nil
end

local function isOccupied(base: any, x: number, z: number): boolean
    for _, decoration in ipairs(base.Decorations) do
        if type(decoration) == "table" and decoration.X == x and decoration.Z == z then
            return true
        end
    end
    return false
end

local function nextDecorationId(base: any): number
    local highest = 0
    for _, decoration in ipairs(base.Decorations) do
        if type(decoration) == "table" and type(decoration.Id) == "number" then
            highest = math.max(highest, math.floor(decoration.Id))
        end
    end
    return highest + 1
end

local function createPlatform(player: Player): Model
    local existing = baseModels[player.UserId]
    if existing and existing.Parent then
        return existing
    end

    local model = Instance.new("Model")
    model.Name = "Base_" .. tostring(player.UserId)
    model:SetAttribute("OwnerUserId", player.UserId)
    model.Parent = baseFolder

    local platform = Instance.new("Part")
    platform.Name = "BasePlatform"
    platform.Size = Vector3.new(64, 1, 64)
    platform.Position = getAnchor(player.UserId)
    platform.Color = Color3.fromRGB(47, 54, 77)
    platform.Material = Enum.Material.Slate
    platform.Anchored = true
    platform.CanCollide = true
    platform.Parent = model

    local marker = Instance.new("Part")
    marker.Name = "BaseMarker"
    marker.Size = Vector3.new(1, 1, 1)
    marker.Position = getAnchor(player.UserId) + Vector3.new(0, 3, 0)
    marker.Color = Color3.fromRGB(100, 220, 255)
    marker.Material = Enum.Material.Neon
    marker.Anchored = true
    marker.CanCollide = false
    marker.Transparency = 0.35
    marker.Parent = model

    baseModels[player.UserId] = model
    return model
end

local function createDecoration(player: Player, decoration: any)
    local model = baseModels[player.UserId] or createPlatform(player)
    local item = ItemsData.GetItem(decoration.ItemId)
    if not item or item.Type ~= "Decoration" then
        return
    end

    local part = Instance.new("Part")
    part.Name = "Decoration_" .. tostring(decoration.Id)
    part:SetAttribute("DecorationId", decoration.Id)
    part:SetAttribute("ItemId", decoration.ItemId)
    part.Anchored = true
    part.CanCollide = false
    part.Color = item.Color or Color3.fromRGB(100, 220, 255)
    part.Material = Enum.Material.Neon
    part.Position = getAnchor(player.UserId)
        + Vector3.new(decoration.X * BaseRules.GRID_SIZE, 2.5, decoration.Z * BaseRules.GRID_SIZE)
    part.Orientation = Vector3.new(0, decoration.Rotation, 0)

    if decoration.ItemId == "sky_lantern" then
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(2.5, 2.5, 2.5)
    elseif decoration.ItemId == "crystal_orb" then
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(3, 3, 3)
    elseif decoration.ItemId == "void_mirror" then
        part.Size = Vector3.new(1, 5, 3)
        part.Material = Enum.Material.Glass
        part.Transparency = 0.15
    elseif decoration.ItemId == "explorer_map" then
        part.Size = Vector3.new(4, 0.25, 3)
        part.Material = Enum.Material.Wood
    elseif decoration.ItemId == "aether_fountain" then
        part.Shape = Enum.PartType.Cylinder
        part.Size = Vector3.new(4, 2, 4)
    else
        part.Size = Vector3.new(3, 3, 3)
    end
    part.Parent = model
end

local function rebuild(player: Player)
    local model = createPlatform(player)
    for _, child in ipairs(model:GetChildren()) do
        if child:GetAttribute("DecorationId") ~= nil then
            child:Destroy()
        end
    end
    local base = getProfileBase(player)
    if not base then
        return
    end
    for _, decoration in ipairs(base.Decorations) do
        if type(decoration) == "table" then
            createDecoration(player, decoration)
        end
    end
end

function BaseService.OnPlayerAdded(player: Player)
    if getProfileBase(player) then
        rebuild(player)
    end
end

function BaseService.OnPlayerRemoving(player: Player)
    local model = baseModels[player.UserId]
    if model then
        model:Destroy()
        baseModels[player.UserId] = nil
    end
end

function BaseService.GetSnapshot(player: Player): { [string]: any }
    local base = getProfileBase(player)
    if not base then
        return { Level = 1, MaxDecorations = BaseRules.MAX_DECORATIONS, Decorations = {} }
    end
    local decorations = {}
    for index, decoration in ipairs(base.Decorations) do
        decorations[index] = {
            Id = decoration.Id,
            ItemId = decoration.ItemId,
            X = decoration.X,
            Z = decoration.Z,
            Rotation = decoration.Rotation,
        }
    end
    return {
        Level = base.Level or 1,
        MaxDecorations = BaseRules.MAX_DECORATIONS,
        Decorations = decorations,
    }
end

function BaseService.PlaceDecoration(
    player: Player,
    itemId: string,
    x: number,
    z: number,
    rotation: number
): (boolean, string)
    if not BaseRules.IsValidCoordinate(x) or not BaseRules.IsValidCoordinate(z) then
        return false, "Base coordinates must be whole grid cells from -7 to 7"
    end
    if not BaseRules.IsValidRotation(rotation) then
        return false, "Rotation must be 0, 90, 180, or 270"
    end
    local item = ItemsData.GetItem(itemId)
    if not item or item.Type ~= "Decoration" then
        return false, "That item is not a base decoration"
    end
    local base = getProfileBase(player)
    if not base then
        return false, "Player data not found"
    end
    if not BaseRules.CanPlace(#base.Decorations) then
        return false, "Base decoration limit reached"
    end
    if isOccupied(base, x, z) then
        return false, "That base cell is already occupied"
    end
    if PlayerDataService.GetItemCount(player, itemId) < 1 then
        return false, "You do not own that decoration"
    end
    if not PlayerDataService.RemoveItem(player, itemId, 1) then
        return false, "Could not consume the decoration"
    end

    local decoration = {
        Id = nextDecorationId(base),
        ItemId = itemId,
        X = x,
        Z = z,
        Rotation = rotation,
    }
    table.insert(base.Decorations, decoration)
    createDecoration(player, decoration)
    return true, "Decoration placed"
end

function BaseService.RemoveDecoration(player: Player, decorationId: number): (boolean, string)
    local base = getProfileBase(player)
    if not base then
        return false, "Player data not found"
    end
    local index, decoration = findDecoration(base, decorationId)
    if not index or not decoration then
        return false, "Decoration not found"
    end
    if not PlayerDataService.AddItem(player, decoration.ItemId, 1) then
        return false, "Could not return the decoration to inventory"
    end
    table.remove(base.Decorations, index)
    local model = baseModels[player.UserId]
    local rendered = model and model:FindFirstChild("Decoration_" .. tostring(decorationId))
    if rendered then
        rendered:Destroy()
    end
    return true, "Decoration returned to inventory"
end

function BaseService.VisitBase(player: Player): (boolean, string)
    local model = createPlatform(player)
    local platform = model:FindFirstChild("BasePlatform")
    if not platform or not platform:IsA("BasePart") then
        return false, "Base platform unavailable"
    end
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart") then
        return false, "Character is not ready"
    end
    root.CFrame = CFrame.new(platform.Position + Vector3.new(0, 5, 10), platform.Position)
    return true, "Arrived at your Aether Base"
end

function BaseService.Initialize()
    print("[BaseService] Initializing...")
    local remotes = getRemotes()
    if not remotes then
        return
    end

    local getBase = remotes:FindFirstChild("GetBase")
    if getBase and getBase:IsA("RemoteFunction") then
        getBase.OnServerInvoke = function(player: Player)
            if not RateLimiter.Check(player, "GetBase", 0.5) then
                return { Level = 1, MaxDecorations = BaseRules.MAX_DECORATIONS, Decorations = {} }
            end
            return BaseService.GetSnapshot(player)
        end
    end

    local place = remotes:FindFirstChild("PlaceDecoration")
    if place and place:IsA("RemoteEvent") then
        place.OnServerEvent:Connect(function(player: Player, itemId: any, x: any, z: any, rotation: any)
            if not RateLimiter.Check(player, "PlaceDecoration", 0.5) then
                return
            end
            if
                type(itemId) ~= "string"
                or #itemId > 64
                or type(x) ~= "number"
                or type(z) ~= "number"
                or type(rotation) ~= "number"
            then
                fireError(player, "Invalid base placement payload")
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = BaseService.PlaceDecoration(player, itemId, x, z, rotation)
            if not success then
                fireError(player, message)
                return
            end
            local updated = remotes:FindFirstChild("BaseUpdated")
            if updated and updated:IsA("RemoteEvent") then
                updated:FireClient(player, BaseService.GetSnapshot(player))
            end
        end)
    end

    local remove = remotes:FindFirstChild("RemoveDecoration")
    if remove and remove:IsA("RemoteEvent") then
        remove.OnServerEvent:Connect(function(player: Player, decorationId: any)
            if not RateLimiter.Check(player, "RemoveDecoration", 0.5) then
                return
            end
            if type(decorationId) ~= "number" or decorationId ~= math.floor(decorationId) or decorationId <= 0 then
                fireError(player, "Invalid decoration id")
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = BaseService.RemoveDecoration(player, decorationId)
            if not success then
                fireError(player, message)
                return
            end
            local updated = remotes:FindFirstChild("BaseUpdated")
            if updated and updated:IsA("RemoteEvent") then
                updated:FireClient(player, BaseService.GetSnapshot(player))
            end
        end)
    end

    local visit = remotes:FindFirstChild("VisitBase")
    if visit and visit:IsA("RemoteEvent") then
        visit.OnServerEvent:Connect(function(player: Player)
            if not RateLimiter.Check(player, "VisitBase", 2) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = BaseService.VisitBase(player)
            if not success then
                fireError(player, message)
            end
        end)
    end

    print("[BaseService] Initialized")
end

return BaseService
