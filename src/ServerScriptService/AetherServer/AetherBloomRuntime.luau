--!strict
-- Installs the Roblox-native companion for the verified Godot Bloom v2 asset.
-- This keeps the world visibly authored from the same asset spec while the
-- Studio GLB import remains a separately verified, human-visible operation.

local Workspace = game:GetService("Workspace")
local AetherBloomFactory = require(game.ReplicatedStorage.AetherShared.Modules.AetherBloomFactory)

local AetherBloomRuntime = {}

function AetherBloomRuntime.Initialize()
    local world = Workspace:FindFirstChild("AetherWorld")
    local islands = world and world:FindFirstChild("Islands")
    local island = islands and islands:FindFirstChild("CrystalSpires")
    if not island then
        warn("[AetherBloomRuntime] CrystalSpires is unavailable")
        return false
    end

    local content = island:FindFirstChild("GeneratedContent")
    if not content then
        content = Instance.new("Folder")
        content.Name = "GeneratedContent"
        content.Parent = island
    end

    if content:FindFirstChild("AetherBloom_GodotV2") then
        return true
    end

    local topPlatform = island:FindFirstChild("TopPlatform")
    if not topPlatform or not topPlatform:IsA("BasePart") then
        warn("[AetherBloomRuntime] CrystalSpires top platform is unavailable")
        return false
    end

    local origin = topPlatform.CFrame * CFrame.new(-14, topPlatform.Size.Y / 2 + 0.1, -14)
    AetherBloomFactory.Create(content, origin)
    print("[AetherBloomRuntime] Installed Godot v2 native companion on CrystalSpires")
    return true
end

return AetherBloomRuntime
