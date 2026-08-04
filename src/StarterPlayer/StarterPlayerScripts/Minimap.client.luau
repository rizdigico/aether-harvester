local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local playerGui = player.PlayerGui
local HUD = playerGui:WaitForChild("AetherUI"):WaitForChild("HUD")
local MinimapFrame = HUD:FindFirstChild("MinimapFrame")

-- Minimap configuration
local MINIMAP_CONFIG = {
    Size = 150,
    Scale = 0.05, -- How much world space maps to minimap
    UpdateInterval = 0.1,
}

local MinimapController = {}
local lastUpdate = 0

local initialized = false

function MinimapController:Initialize()
    if initialized then
        return
    end
    initialized = true
    print("[Minimap] Initializing...")

    if not MinimapFrame then
        warn("[Minimap] MinimapFrame not found in HUD")
        return
    end

    -- Create minimap background
    self:CreateMinimapBackground()

    -- Update loop
    RunService.Heartbeat:Connect(function(dt)
        lastUpdate += dt
        if lastUpdate >= MINIMAP_CONFIG.UpdateInterval then
            lastUpdate = 0
            self:UpdateMinimap()
        end
    end)

    -- Track character changes
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    end)

    print("[Minimap] Initialized")
end

function MinimapController:CreateMinimapBackground()
    if not MinimapFrame then
        return
    end

    -- Create circular mask
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = MinimapFrame

    -- Create background
    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    Background.BackgroundTransparency = 0.3
    Background.Parent = MinimapFrame

    -- Create player dot
    local PlayerDot = Instance.new("Frame")
    PlayerDot.Name = "PlayerDot"
    PlayerDot.Size = UDim2.new(0, 12, 0, 12)
    PlayerDot.Position = UDim2.new(0.5, -4, 0.5, -4)
    PlayerDot.BackgroundColor3 = Color3.new(0, 1, 0)
    PlayerDot.Parent = MinimapFrame

    local PlayerCorner = Instance.new("UICorner")
    PlayerCorner.CornerRadius = UDim.new(1, 0)
    PlayerCorner.Parent = PlayerDot
end

function MinimapController:UpdateMinimap()
    if not humanoidRootPart or not MinimapFrame then
        return
    end

    local position = humanoidRootPart.Position
    local minimapCenter = UDim2.new(0.5, 0, 0.5, 0)

    -- Convert world position to minimap position
    local worldOffset = Vector2.new(position.X, position.Z) * MINIMAP_CONFIG.Scale
    local minimapPos = UDim2.new(0.5, worldOffset.X, 0.5, worldOffset.Y)

    -- Update player dot position
    local PlayerDot = MinimapFrame:FindFirstChild("PlayerDot")
    if PlayerDot then
        PlayerDot.Position = minimapPos
    end

    -- Update rotation indicator
    local rotation = humanoidRootPart.Orientation.Y
    -- Could add rotation indicator here
end

function MinimapController:AddMarker(worldPosition, color, name)
    if not MinimapFrame then
        return
    end

    local Marker = Instance.new("Frame")
    Marker.Name = name or "Marker"
    Marker.Size = UDim2.new(0, 6, 0, 6)
    Marker.BackgroundColor3 = color or Color3.new(1, 0, 0)
    Marker.Parent = MinimapFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(1, 0)
    Corner.Parent = Marker

    -- Position will be updated in UpdateMinimap
    Marker:SetAttribute("WorldPosition", worldPosition)
end

-- Initialize
MinimapController:Initialize()

_G.MinimapController = MinimapController
