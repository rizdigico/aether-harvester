--!strict
-- WorldBuilder: deterministic recreation of Workspace.AetherWorld
-- Generated from artifacts/recovery/Workspace_AetherWorld_FULL.json
-- Regenerate with scripts/assets/rebuild-world.py when the dump changes.

local AetherWorld = Instance.new("Folder")
AetherWorld.Name = "AetherWorld"

local function createPart(props)
    local part = Instance.new("Part")
    part.Name = props.Name
    part.Size = props.Size
    part.CFrame = props.CFrame
    part.Color = props.Color
    part.Material = props.Material
    part.Anchored = props.Anchored
    part.CanCollide = props.CanCollide
    part.Parent = props.Parent
    return part
end

local function createModel(name, attrs, parent)
    local model = Instance.new("Model")
    model.Name = name
    for k, v in pairs(attrs or {}) do
        model:SetAttribute(k, v)
    end
    model.Parent = parent
    return model
end

local Islands = Instance.new("Folder")
Islands.Name = "Islands"
Islands.Parent = AetherWorld
local Islands_FloatingMarket = createModel("FloatingMarket", nil, Islands)
createPart({
    Name = "Tier1",
    Size = Vector3.new(68, 8, 68),
    CFrame = CFrame.new(200, 73, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Cap",
    Size = Vector3.new(74, 1.2, 74),
    CFrame = CFrame.new(200, 81.6, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.666667, 0.490196, 0.294118),
    Material = Enum.Material.WoodPlanks,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Counter1",
    Size = Vector3.new(6, 1.2, 4),
    CFrame = CFrame.new(222, 82.8, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.333333, 0.196078),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallLamp1",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(226, 88.4, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.784314, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallPost1",
    Size = Vector3.new(1, 4, 1),
    CFrame = CFrame.new(226, 84.2, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Skirt2",
    Size = Vector3.new(41.82, 8, 41.82),
    CFrame = CFrame.new(200, 15, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallLamp3",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(226, 88.4, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.784314, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallCanopy1",
    Size = Vector3.new(16, 1.5, 16),
    CFrame = CFrame.new(226, 87, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.235294, 0.235294),
    Material = Enum.Material.Fabric,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "CenterPost",
    Size = Vector3.new(1.5, 7, 1.5),
    CFrame = CFrame.new(200, 85.7, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallLamp4",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(174, 88.4, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.784314, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallCanopy2",
    Size = Vector3.new(16, 1.5, 16),
    CFrame = CFrame.new(174, 87, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.862745, 0.666667, 0.156863),
    Material = Enum.Material.Fabric,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Counter2",
    Size = Vector3.new(6, 1.2, 4),
    CFrame = CFrame.new(178, 82.8, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.333333, 0.196078),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Crate1",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(212, 80.2, -118, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.411765, 0.235294),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Tier4",
    Size = Vector3.new(20, 10, 20),
    CFrame = CFrame.new(200, 42, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Barrel1",
    Size = Vector3.new(3, 4, 3),
    CFrame = CFrame.new(186, 80.4, -84, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Crate2",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(215, 80.3, -120, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "CenterLamp",
    Size = Vector3.new(3, 1.2, 3),
    CFrame = CFrame.new(200, 89.8, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.862745, 0.470588),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Counter3",
    Size = Vector3.new(6, 1.2, 4),
    CFrame = CFrame.new(222, 82.8, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.333333, 0.196078),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallPost3",
    Size = Vector3.new(1, 4, 1),
    CFrame = CFrame.new(226, 84.2, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Tier3",
    Size = Vector3.new(36, 12, 36),
    CFrame = CFrame.new(200, 53, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallPost2",
    Size = Vector3.new(1, 4, 1),
    CFrame = CFrame.new(174, 84.2, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Counter4",
    Size = Vector3.new(6, 1.2, 4),
    CFrame = CFrame.new(178, 82.8, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.333333, 0.196078),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallLamp2",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(174, 88.4, 26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.784314, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(28.4376, 8, 28.4376),
    CFrame = CFrame.new(200, 8, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallCanopy4",
    Size = Vector3.new(16, 1.5, 16),
    CFrame = CFrame.new(174, 87, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.470588, 0.784314),
    Material = Enum.Material.Fabric,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "TopPlatform",
    Size = Vector3.new(82, 4, 82),
    CFrame = CFrame.new(200, 79, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.411765, 0.235294),
    Material = Enum.Material.WoodPlanks,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Tier2",
    Size = Vector3.new(52, 10, 52),
    CFrame = CFrame.new(200, 64, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallCanopy3",
    Size = Vector3.new(16, 1.5, 16),
    CFrame = CFrame.new(226, 87, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.627451, 0.352941),
    Material = Enum.Material.Fabric,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Tip",
    Size = Vector3.new(8, 12, 8),
    CFrame = CFrame.new(200, 32, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(61.5, 8, 61.5),
    CFrame = CFrame.new(200, 22, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "MarketSign",
    Size = Vector3.new(10, 2, 0.6),
    CFrame = CFrame.new(200, 91, -100, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.411765, 0.235294),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
createPart({
    Name = "StallPost4",
    Size = Vector3.new(1, 4, 1),
    CFrame = CFrame.new(174, 84.2, -26, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.156863, 0.109804, 0.0784314),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_FloatingMarket,
})
local Islands_FloatingMarket_SpawnLocation = Instance.new("SpawnLocation")
Islands_FloatingMarket_SpawnLocation.Name = "SpawnLocation"
Islands_FloatingMarket_SpawnLocation.Parent = Islands_FloatingMarket
local Islands_AetherNode_1 = createModel("AetherNode_1", nil, Islands)
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(8, 146, 19.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_1,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(16, 146, 12.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_1,
})
createPart({
    Name = "Base",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(10, 144, 10.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.784314, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_1,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(20, 146, 25.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_1,
})
local Islands_EmberPeaks = createModel("EmberPeaks", nil, Islands)
createPart({
    Name = "Tip",
    Size = Vector3.new(8, 12, 8),
    CFrame = CFrame.new(100, 42, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.0980392, 0.0862745, 0.0784314),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Tier3",
    Size = Vector3.new(32, 12, 32),
    CFrame = CFrame.new(100, 63, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.215686, 0.176471, 0.156863),
    Material = Enum.Material.Basalt,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "TopPlatform",
    Size = Vector3.new(72, 4, 72),
    CFrame = CFrame.new(100, 89, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.27451, 0.215686, 0.188235),
    Material = Enum.Material.Basalt,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Tier1",
    Size = Vector3.new(60, 8, 60),
    CFrame = CFrame.new(100, 83, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.188235, 0.164706),
    Material = Enum.Material.Basalt,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
local Islands_EmberPeaks_SpawnLocation = Instance.new("SpawnLocation")
Islands_EmberPeaks_SpawnLocation.Name = "SpawnLocation"
Islands_EmberPeaks_SpawnLocation.Parent = Islands_EmberPeaks
createPart({
    Name = "Skirt2",
    Size = Vector3.new(36.72, 8, 36.72),
    CFrame = CFrame.new(100, 25, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Tier4",
    Size = Vector3.new(18, 10, 18),
    CFrame = CFrame.new(100, 52, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.0980392, 0.0862745, 0.0784314),
    Material = Enum.Material.Basalt,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Tier2",
    Size = Vector3.new(46, 10, 46),
    CFrame = CFrame.new(100, 74, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.215686, 0.176471, 0.156863),
    Material = Enum.Material.Basalt,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Vent1",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(120, 90.4, 218, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.705882, 0.235294),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Vent2",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(78, 90.4, 184, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.470588, 0.156863),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Rock2",
    Size = Vector3.new(6, 5, 8),
    CFrame = CFrame.new(126, 91.3, 176, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.0980392, 0.0862745, 0.0784314),
    Material = Enum.Material.CrackedLava,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "LavaPool",
    Size = Vector3.new(30, 1, 30),
    CFrame = CFrame.new(100, 90.8, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.470588, 0.156863),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(24.9696, 8, 24.9696),
    CFrame = CFrame.new(100, 18, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Rock1",
    Size = Vector3.new(8, 6, 6),
    CFrame = CFrame.new(76, 91.5, 222, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.215686, 0.176471, 0.156863),
    Material = Enum.Material.CrackedLava,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(54, 8, 54),
    CFrame = CFrame.new(100, 32, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
createPart({
    Name = "Rock3",
    Size = Vector3.new(7, 5, 5),
    CFrame = CFrame.new(118, 91.5, 194, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.215686, 0.176471, 0.156863),
    Material = Enum.Material.Basalt,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_EmberPeaks,
})
local Islands_SkySanctum = createModel("SkySanctum", nil, Islands)
local Islands_SkySanctum_PlatformLight = Instance.new("PointLight")
Islands_SkySanctum_PlatformLight.Name = "PlatformLight"
Islands_SkySanctum_PlatformLight.Parent = Islands_SkySanctum
createPart({
    Name = "Skirt3",
    Size = Vector3.new(31.212, 8, 31.212),
    CFrame = CFrame.new(0, 62, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "GrassCap",
    Size = Vector3.new(82, 1.5, 82),
    CFrame = CFrame.new(0, 140.7, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.345098, 0.509804, 0.313726),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Tier1",
    Size = Vector3.new(70, 8, 70),
    CFrame = CFrame.new(0, 130, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.294118, 0.333333, 0.352941),
    Material = Enum.Material.Granite,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Rune1",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(41, 145, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Beacon",
    Size = Vector3.new(3, 18, 3),
    CFrame = CFrame.new(0, 152, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Rune4",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(-28.9914, 145, 28.9914, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Rune8",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(28.9914, 145, -28.9914, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Tier4",
    Size = Vector3.new(20, 12, 20),
    CFrame = CFrame.new(0, 98, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.176471, 0.203922, 0.235294),
    Material = Enum.Material.Granite,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(67.5, 8, 67.5),
    CFrame = CFrame.new(0, 76, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Tier2",
    Size = Vector3.new(50, 10, 50),
    CFrame = CFrame.new(0, 121, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.294118, 0.333333, 0.352941),
    Material = Enum.Material.Granite,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "GlowEffect",
    Size = Vector3.new(88, 2, 88),
    CFrame = CFrame.new(0, 142.8, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Tier3",
    Size = Vector3.new(34, 12, 34),
    CFrame = CFrame.new(0, 110, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.176471, 0.203922, 0.235294),
    Material = Enum.Material.Granite,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Rune7",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(-7.53158e-15, 145, -41, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Rune2",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(28.9914, 145, 28.9914, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Skirt2",
    Size = Vector3.new(45.9, 8, 45.9),
    CFrame = CFrame.new(0, 69, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Rune3",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(2.51053e-15, 145, 41, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Tip",
    Size = Vector3.new(8, 12, 8),
    CFrame = CFrame.new(0, 86, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.176471, 0.203922, 0.235294),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
local Islands_SkySanctum_SpawnLocation = Instance.new("SpawnLocation")
Islands_SkySanctum_SpawnLocation.Name = "SpawnLocation"
Islands_SkySanctum_SpawnLocation.Parent = Islands_SkySanctum
createPart({
    Name = "Rune5",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(-41, 145, 5.02105e-15, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "Rune6",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(-28.9914, 145, -28.9914, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
createPart({
    Name = "TopPlatform",
    Size = Vector3.new(90, 6, 90),
    CFrame = CFrame.new(0, 137, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.431373, 0.372549),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_SkySanctum,
})
local Islands_CloudGardens = createModel("CloudGardens", nil, Islands)
local Islands_CloudGardens_WindAmbient = Instance.new("Sound")
Islands_CloudGardens_WindAmbient.Name = "WindAmbient"
Islands_CloudGardens_WindAmbient.Parent = Islands_CloudGardens
createPart({
    Name = "Skirt2",
    Size = Vector3.new(40.8, 8, 40.8),
    CFrame = CFrame.new(200, 67, -1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Rock5",
    Size = Vector3.new(3, 4, 8),
    CFrame = CFrame.new(184, 84, -39, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(60, 8, 60),
    CFrame = CFrame.new(200, 74, -1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Rock4",
    Size = Vector3.new(7, 4, 4),
    CFrame = CFrame.new(220, 84, 39, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Rock1",
    Size = Vector3.new(6, 3, 6),
    CFrame = CFrame.new(213, 85, 27, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(27.744, 8, 27.744),
    CFrame = CFrame.new(200, 60, -1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "SpawnPoint",
    Size = Vector3.new(4, 1, 4),
    CFrame = CFrame.new(200, 83, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 1, 0.392157),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Base",
    Size = Vector3.new(80, 4, 80),
    CFrame = CFrame.new(200, 80, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.784314, 0.588235),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Rock3",
    Size = Vector3.new(6, 6, 6),
    CFrame = CFrame.new(227, 84, -35, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
createPart({
    Name = "Rock2",
    Size = Vector3.new(3, 2, 8),
    CFrame = CFrame.new(173, 83, 27, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CloudGardens,
})
local Islands_Tree_3 = createModel("Tree_3", nil, Islands)
createPart({
    Name = "Base",
    Size = Vector3.new(2, 10, 2),
    CFrame = CFrame.new(-171, 78, -167.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.133333, 0.545098, 0.133333),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_3,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-181, 80, -160.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_3,
})
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-184, 80, -172.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_3,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-168, 80, -159.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_3,
})
local Islands_AncientRuins = createModel("AncientRuins", nil, Islands)
createPart({
    Name = "Skirt2",
    Size = Vector3.new(51, 8, 51),
    CFrame = CFrame.new(-200, 56, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
local Islands_AncientRuins_MysticAmbient = Instance.new("Sound")
Islands_AncientRuins_MysticAmbient.Name = "MysticAmbient"
Islands_AncientRuins_MysticAmbient.Parent = Islands_AncientRuins
createPart({
    Name = "Rock2",
    Size = Vector3.new(5, 5, 3),
    CFrame = CFrame.new(-237, 73, -212, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "Base",
    Size = Vector3.new(100, 6, 100),
    CFrame = CFrame.new(-200, 70, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 0.509804, 0.431373),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "Rock3",
    Size = Vector3.new(5, 2, 4),
    CFrame = CFrame.new(-221, 73, -246, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "Rock5",
    Size = Vector3.new(8, 2, 7),
    CFrame = CFrame.new(-205, 75, -225, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(75, 8, 75),
    CFrame = CFrame.new(-200, 63, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "SpawnPoint",
    Size = Vector3.new(4, 1, 4),
    CFrame = CFrame.new(-200, 74, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 1, 0.392157),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "Rock4",
    Size = Vector3.new(4, 4, 4),
    CFrame = CFrame.new(-187, 73, -238, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "Rock1",
    Size = Vector3.new(7, 5, 4),
    CFrame = CFrame.new(-214, 73, -165, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(34.68, 8, 34.68),
    CFrame = CFrame.new(-200, 49, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AncientRuins,
})
local Islands_CrystalSpires = createModel("CrystalSpires", nil, Islands)
createPart({
    Name = "Tier2",
    Size = Vector3.new(42, 10, 42),
    CFrame = CFrame.new(-150, 94, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.352941, 0.45098),
    Material = Enum.Material.Slate,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Tip",
    Size = Vector3.new(8, 12, 8),
    CFrame = CFrame.new(-150, 62, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.137255, 0.156863, 0.215686),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "TopPlatform",
    Size = Vector3.new(62, 4, 62),
    CFrame = CFrame.new(-150, 109, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.411765, 0.45098, 0.54902),
    Material = Enum.Material.Slate,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Spire2",
    Size = Vector3.new(7, 16.8, 7),
    CFrame = CFrame.new(-164, 117.9, 140, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.588235, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Spire5",
    Size = Vector3.new(4, 11.2, 4),
    CFrame = CFrame.new(-128, 116.1, 144, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.588235, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Glow6",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(-156, 111.3, 154, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 1, 0.862745),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(21.5016, 8, 21.5016),
    CFrame = CFrame.new(-150, 38, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
local Islands_CrystalSpires_SpawnLocation = Instance.new("SpawnLocation")
Islands_CrystalSpires_SpawnLocation.Name = "SpawnLocation"
Islands_CrystalSpires_SpawnLocation.Parent = Islands_CrystalSpires
createPart({
    Name = "Tier4",
    Size = Vector3.new(18, 10, 18),
    CFrame = CFrame.new(-150, 72, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.137255, 0.156863, 0.215686),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Glow5",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(-128, 111.3, 144, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.588235, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Glow3",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(-144, 111.3, 132, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.627451, 0.470588, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Skirt2",
    Size = Vector3.new(31.62, 8, 31.62),
    CFrame = CFrame.new(-150, 45, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Tier1",
    Size = Vector3.new(54, 8, 54),
    CFrame = CFrame.new(-150, 103, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.372549, 0.411765, 0.509804),
    Material = Enum.Material.Slate,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Glow4",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(-170, 111.3, 168, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.823529, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Spire6",
    Size = Vector3.new(7, 22.4, 7),
    CFrame = CFrame.new(-156, 120.2, 154, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.54902, 1, 0.862745),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "CoreCrystal1",
    Size = Vector3.new(2, 10, 2),
    CFrame = CFrame.new(-150, 116, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 1, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Spire4",
    Size = Vector3.new(5, 14, 5),
    CFrame = CFrame.new(-170, 118, 168, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.823529, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Tier3",
    Size = Vector3.new(30, 12, 30),
    CFrame = CFrame.new(-150, 83, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.352941, 0.45098),
    Material = Enum.Material.Slate,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Spire3",
    Size = Vector3.new(6, 25.2, 6),
    CFrame = CFrame.new(-144, 121.6, 132, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.627451, 0.470588, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(46.5, 8, 46.5),
    CFrame = CFrame.new(-150, 52, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "CoreCrystal3",
    Size = Vector3.new(2, 10, 2),
    CFrame = CFrame.new(-168, 114, 138, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.862745, 0.745098, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Glow1",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(-134, 111.3, 162, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.823529, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Spire1",
    Size = Vector3.new(8, 19.6, 8),
    CFrame = CFrame.new(-134, 119.3, 162, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.823529, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Glow2",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(-164, 111.3, 140, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.588235, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "CoreCrystal2",
    Size = Vector3.new(2, 10, 2),
    CFrame = CFrame.new(-132, 114, 162, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.705882, 0.784314, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
createPart({
    Name = "Cap",
    Size = Vector3.new(54, 1.2, 54),
    CFrame = CFrame.new(-150, 111.6, 150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.45098, 0.490196, 0.588235),
    Material = Enum.Material.Slate,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalSpires,
})
local Islands_VoidRifts = createModel("VoidRifts", nil, Islands)
createPart({
    Name = "Skirt3",
    Size = Vector3.new(24.276, 8, 24.276),
    CFrame = CFrame.new(-0.25, 100, 201.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
local Islands_VoidRifts_EtherealAmbient = Instance.new("Sound")
Islands_VoidRifts_EtherealAmbient.Name = "EtherealAmbient"
Islands_VoidRifts_EtherealAmbient.Parent = Islands_VoidRifts
createPart({
    Name = "Rock1",
    Size = Vector3.new(5, 5, 3),
    CFrame = CFrame.new(24, 124, 187, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "Base",
    Size = Vector3.new(70, 4, 70),
    CFrame = CFrame.new(0, 120, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.196078, 0.470588),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "SpawnPoint",
    Size = Vector3.new(4, 1, 4),
    CFrame = CFrame.new(0, 123, 200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 1, 0.392157),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "Skirt2",
    Size = Vector3.new(35.7, 8, 35.7),
    CFrame = CFrame.new(-0.25, 107, 201.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(52.5, 8, 52.5),
    CFrame = CFrame.new(-0.25, 114, 201.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "Rock3",
    Size = Vector3.new(7, 2, 5),
    CFrame = CFrame.new(21, 125, 180, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "Rock4",
    Size = Vector3.new(8, 5, 3),
    CFrame = CFrame.new(-15, 125, 233, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "Rock5",
    Size = Vector3.new(6, 4, 7),
    CFrame = CFrame.new(13, 125, 235, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
createPart({
    Name = "Rock2",
    Size = Vector3.new(5, 2, 3),
    CFrame = CFrame.new(-33, 125, 232, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VoidRifts,
})
local Islands_CrystalNode_3 = createModel("CrystalNode_3", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(194, 94.25, -199, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_3,
})
local Islands_VerdantIsle = createModel("VerdantIsle", nil, Islands)
createPart({
    Name = "Trunk4",
    Size = Vector3.new(2.5, 8, 2.5),
    CFrame = CFrame.new(-232, 72.5, -140, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Rock1",
    Size = Vector3.new(5, 4, 4),
    CFrame = CFrame.new(-236, 72.3, -164, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.470588, 0.470588),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Tier4",
    Size = Vector3.new(22, 10, 22),
    CFrame = CFrame.new(-200, 32, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.137255, 0.235294, 0.117647),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(69, 8, 69),
    CFrame = CFrame.new(-200, 12, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Canopy1",
    Size = Vector3.new(9, 7, 9),
    CFrame = CFrame.new(-180, 78.5, -132, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.509804, 0.215686),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Rock2",
    Size = Vector3.new(4, 3, 5),
    CFrame = CFrame.new(-166, 72, -128, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.411765, 0.411765, 0.411765),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
local Islands_VerdantIsle_SpawnLocation = Instance.new("SpawnLocation")
Islands_VerdantIsle_SpawnLocation.Name = "SpawnLocation"
Islands_VerdantIsle_SpawnLocation.Parent = Islands_VerdantIsle
createPart({
    Name = "Canopy3",
    Size = Vector3.new(9, 7, 9),
    CFrame = CFrame.new(-192, 78.5, -180, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.509804, 0.215686),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Canopy2",
    Size = Vector3.new(9, 7, 9),
    CFrame = CFrame.new(-224, 78.5, -170, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.509804, 0.215686),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "CanopyTop5",
    Size = Vector3.new(5, 4, 5),
    CFrame = CFrame.new(-170, 82.5, -158, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.588235, 0.254902),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Tier3",
    Size = Vector3.new(40, 12, 40),
    CFrame = CFrame.new(-200, 43, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.196078, 0.313726, 0.156863),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Canopy4",
    Size = Vector3.new(9, 7, 9),
    CFrame = CFrame.new(-232, 78.5, -140, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.509804, 0.215686),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "CanopyTop3",
    Size = Vector3.new(5, 4, 5),
    CFrame = CFrame.new(-192, 82.5, -180, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.588235, 0.254902),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Trunk1",
    Size = Vector3.new(2.5, 8, 2.5),
    CFrame = CFrame.new(-180, 72.5, -132, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Trunk3",
    Size = Vector3.new(2.5, 8, 2.5),
    CFrame = CFrame.new(-192, 72.5, -180, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "FlowerPatch1",
    Size = Vector3.new(4, 0.5, 4),
    CFrame = CFrame.new(-184, 71.3, -120, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.54902, 0.784314),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Tip",
    Size = Vector3.new(8, 12, 8),
    CFrame = CFrame.new(-200, 22, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.137255, 0.235294, 0.117647),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Trunk2",
    Size = Vector3.new(2.5, 8, 2.5),
    CFrame = CFrame.new(-224, 72.5, -170, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Tier1",
    Size = Vector3.new(76, 8, 76),
    CFrame = CFrame.new(-200, 63, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.254902, 0.431373, 0.188235),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Skirt2",
    Size = Vector3.new(46.92, 8, 46.92),
    CFrame = CFrame.new(-200, 5, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Tier2",
    Size = Vector3.new(58, 10, 58),
    CFrame = CFrame.new(-200, 54, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.392157, 0.176471),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "TopPlatform",
    Size = Vector3.new(92, 4, 92),
    CFrame = CFrame.new(-200, 69, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.294118, 0.509804, 0.215686),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "CanopyTop1",
    Size = Vector3.new(5, 4, 5),
    CFrame = CFrame.new(-180, 82.5, -132, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.588235, 0.254902),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(31.9056, 8, 31.9056),
    CFrame = CFrame.new(-200, -2, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Canopy5",
    Size = Vector3.new(9, 7, 9),
    CFrame = CFrame.new(-170, 78.5, -158, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.235294, 0.509804, 0.215686),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "CanopyTop4",
    Size = Vector3.new(5, 4, 5),
    CFrame = CFrame.new(-232, 82.5, -140, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.588235, 0.254902),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "FlowerPatch2",
    Size = Vector3.new(4, 0.5, 4),
    CFrame = CFrame.new(-218, 71.3, -182, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.901961, 0.470588),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Cap",
    Size = Vector3.new(84, 1.2, 84),
    CFrame = CFrame.new(-200, 71.6, -150, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.27451, 0.54902, 0.215686),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "Trunk5",
    Size = Vector3.new(2.5, 8, 2.5),
    CFrame = CFrame.new(-170, 72.5, -158, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.368627, 0.235294, 0.156863),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
createPart({
    Name = "CanopyTop2",
    Size = Vector3.new(5, 4, 5),
    CFrame = CFrame.new(-224, 82.5, -170, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.313726, 0.588235, 0.254902),
    Material = Enum.Material.LeafyGrass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_VerdantIsle,
})
local Islands_CrystalNode_4 = createModel("CrystalNode_4", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(197, 94.25, -186, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_4,
})
local Islands_Tree_2 = createModel("Tree_2", nil, Islands)
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-221, 78, -169, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_2,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-219, 78, -162, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_2,
})
createPart({
    Name = "Base",
    Size = Vector3.new(2, 6, 2),
    CFrame = CFrame.new(-210, 76, -169, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.133333, 0.545098, 0.133333),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_2,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-207, 78, -155, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_2,
})
local Islands_CrystalNode_1 = createModel("CrystalNode_1", nil, Islands)
createPart({
    Name = "Base",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(215, 96, -191.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.392157, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_1,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(227, 98, -190.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_1,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(201, 98, -179.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_1,
})
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(211, 98, -187.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_1,
})
local Islands_CrystalNode_2 = createModel("CrystalNode_2", nil, Islands)
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(196, 98, -207.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_2,
})
createPart({
    Name = "Base",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(191, 96, -204.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.392157, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_2,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(176, 98, -219.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_2,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(192, 98, -219.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_2,
})
local Islands_OreNode_1 = createModel("OreNode_1", nil, Islands)
createPart({
    Name = "Base",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(117.75, 94.5, 185.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.392157, 0.196078),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_OreNode_1,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(113.75, 96.5, 195.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_OreNode_1,
})
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(113.75, 96.5, 186.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_OreNode_1,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(114.75, 96.5, 194.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_OreNode_1,
})
local Islands_AetherNode_2 = createModel("AetherNode_2", nil, Islands)
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-26.5, 146, -17.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_2,
})
createPart({
    Name = "Base",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(-12.5, 144, -10.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.784314, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_2,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-15.5, 146, -21.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_2,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-5.5, 146, -6.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_2,
})
local Islands_AetherNode_10 = createModel("AetherNode_10", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-211, 73.5, -192, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_10,
})
local Islands_AetherNode_6 = createModel("AetherNode_6", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-3.25, 124.75, 198.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_6,
})
local Islands_AetherNode_8 = createModel("AetherNode_8", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-15.25, 124.75, 195.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_8,
})
local Islands_OreNode_4 = createModel("OreNode_4", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-186, 105, -5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_OreNode_4,
})
local Islands_Rock_1 = createModel("Rock_1", nil, Islands)
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-190, 109, 17, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_1,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-198, 109, 13, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_1,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-178, 109, 21, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_1,
})
createPart({
    Name = "Base",
    Size = Vector3.new(4, 3, 4),
    CFrame = CFrame.new(-193, 107, 8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.501961, 0.501961, 0.501961),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_1,
})
local Islands_CrystalCanyons = createModel("CrystalCanyons", nil, Islands)
local Islands_CrystalCanyons_CrystalAmbient = Instance.new("Sound")
Islands_CrystalCanyons_CrystalAmbient.Name = "CrystalAmbient"
Islands_CrystalCanyons_CrystalAmbient.Parent = Islands_CrystalCanyons
createPart({
    Name = "Rock2",
    Size = Vector3.new(5, 4, 6),
    CFrame = CFrame.new(216, 92.5, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Rock4",
    Size = Vector3.new(7, 3, 3),
    CFrame = CFrame.new(211, 95.5, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Base",
    Size = Vector3.new(90, 5, 90),
    CFrame = CFrame.new(200, 90, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.705882, 0.588235, 0.784314),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(31.212, 8, 31.212),
    CFrame = CFrame.new(200, 69.5, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "SpawnPoint",
    Size = Vector3.new(4, 1, 4),
    CFrame = CFrame.new(200, 93.5, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 1, 0.392157),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Rock5",
    Size = Vector3.new(4, 4, 5),
    CFrame = CFrame.new(204, 92.5, -242, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Rock3",
    Size = Vector3.new(3, 6, 8),
    CFrame = CFrame.new(239, 92.5, -203, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Skirt2",
    Size = Vector3.new(45.9, 8, 45.9),
    CFrame = CFrame.new(200, 76.5, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Rock1",
    Size = Vector3.new(3, 2, 5),
    CFrame = CFrame.new(243, 93.5, -162, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(67.5, 8, 67.5),
    CFrame = CFrame.new(200, 83.5, -200, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalCanyons,
})
local Islands_AetherNode_9 = createModel("AetherNode_9", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-187, 73.5, -193, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_9,
})
local Islands_AetherNode_5 = createModel("AetherNode_5", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(5, 7, 5),
    CFrame = CFrame.new(-15, 142.5, -25.9808, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.470588, 1),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_5,
})
local Islands_HerbNode_2 = createModel("HerbNode_2", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(214, 84.5, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_HerbNode_2,
})
local Islands_AetherNode_7 = createModel("AetherNode_7", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-2.25, 124.75, 195.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_7,
})
local Islands_StormPeaks = createModel("StormPeaks", nil, Islands)
local Islands_StormPeaks_ThunderAmbient = Instance.new("Sound")
Islands_StormPeaks_ThunderAmbient.Name = "ThunderAmbient"
Islands_StormPeaks_ThunderAmbient.Parent = Islands_StormPeaks
createPart({
    Name = "Rock1",
    Size = Vector3.new(4, 6, 7),
    CFrame = CFrame.new(-220, 106, 12, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Skirt3",
    Size = Vector3.new(20.808, 8, 20.808),
    CFrame = CFrame.new(-200, 79, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "SpawnPoint",
    Size = Vector3.new(4, 1, 4),
    CFrame = CFrame.new(-200, 104, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 1, 0.392157),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Rock3",
    Size = Vector3.new(4, 6, 4),
    CFrame = CFrame.new(-190, 106, 29, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Base",
    Size = Vector3.new(60, 6, 60),
    CFrame = CFrame.new(-200, 100, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.470588, 0.470588, 0.54902),
    Material = Enum.Material.Grass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Rock4",
    Size = Vector3.new(6, 2, 3),
    CFrame = CFrame.new(-183, 103, 22, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Skirt2",
    Size = Vector3.new(30.6, 8, 30.6),
    CFrame = CFrame.new(-200, 86, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Rock2",
    Size = Vector3.new(6, 6, 6),
    CFrame = CFrame.new(-188, 104, 29, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Rock5",
    Size = Vector3.new(7, 6, 5),
    CFrame = CFrame.new(-177, 106, -19, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.392157, 0.392157),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
createPart({
    Name = "Skirt1",
    Size = Vector3.new(45, 8, 45),
    CFrame = CFrame.new(-200, 93, 1, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.164706, 0.14902, 0.188235),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_StormPeaks,
})
local Islands_HerbNode_3 = createModel("HerbNode_3", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(203, 84.5, 5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_HerbNode_3,
})
local Islands_Rock_2 = createModel("Rock_2", nil, Islands)
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-222, 108.5, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_2,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-202, 108.5, -7.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_2,
})
createPart({
    Name = "Base",
    Size = Vector3.new(3, 2, 3),
    CFrame = CFrame.new(-214, 106.5, -14.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.501961, 0.501961, 0.501961),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_2,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-219, 108.5, -16.5, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Rock_2,
})
local Islands_Tree_1 = createModel("Tree_1", nil, Islands)
createPart({
    Name = "Base",
    Size = Vector3.new(2, 8, 2),
    CFrame = CFrame.new(-187, 77, -141, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.133333, 0.545098, 0.133333),
    Material = Enum.Material.Wood,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_1,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-185, 79, -147, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_1,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-175, 79, -129, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_1,
})
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-201, 79, -141, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_Tree_1,
})
local Islands_HerbNode_1 = createModel("HerbNode_1", nil, Islands)
createPart({
    Name = "ResourceNode_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(235.5, 88, 7, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_HerbNode_1,
})
createPart({
    Name = "ResourceNode_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(228.5, 88, -19, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_HerbNode_1,
})
createPart({
    Name = "ResourceNode_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(212.5, 88, -9, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_HerbNode_1,
})
createPart({
    Name = "Base",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(223.5, 86, -6, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 1, 0.392157),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_HerbNode_1,
})
local Islands_OreNode_2 = createModel("OreNode_2", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-194, 105, 11, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_OreNode_2,
})
local Islands_AetherNode_4 = createModel("AetherNode_4", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(5, 7, 5),
    CFrame = CFrame.new(-15, 142.5, 25.9808, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.717647, 0.301961),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_4,
})
local Islands_AetherNode_11 = createModel("AetherNode_11", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-201, 73.5, -185, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_11,
})
local Islands_AetherNode_3 = createModel("AetherNode_3", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(5, 7, 5),
    CFrame = CFrame.new(30, 142.5, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.392157, 0.862745, 1),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_AetherNode_3,
})
local Islands_CrystalNode_5 = createModel("CrystalNode_5", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(202, 94.25, -204, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_CrystalNode_5,
})
local Islands_OreNode_3 = createModel("OreNode_3", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-212, 105, 3, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_OreNode_3,
})
local Islands_HerbNode_4 = createModel("HerbNode_4", nil, Islands)
createPart({
    Name = "Core",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(202, 84.5, -12, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.8, 0.498039),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Islands_HerbNode_4,
})
local Props = Instance.new("Folder")
Props.Name = "Props"
Props.Parent = AetherWorld
createPart({
    Name = "CrystalTree_4",
    Size = Vector3.new(3, 6, 3),
    CFrame = CFrame.new(216, 95.5, -186, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.862745, 1),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "AetherFlower_5",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(26, 142.3, -14, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.54902, 0.862745),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "FloatingRock_1",
    Size = Vector3.new(3, 5, 3),
    CFrame = CFrame.new(34, 144.3, 10, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.509804, 0.509804, 0.529412),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "MushroomCluster_1",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(184, 82.5, 12, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.745098, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "GlowingOrb_4",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-22, 122.5, 210, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.470588, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "GlowingOrb_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-16, 122.5, 218, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.470588, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "AncientPillar_1",
    Size = Vector3.new(3, 8, 3),
    CFrame = CFrame.new(-190, 77, -186, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.784314, 0.823529),
    Material = Enum.Material.Marble,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "MushroomCluster_2",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(222, 82.5, -14, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.745098, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "AncientPillar_4",
    Size = Vector3.new(3, 8, 3),
    CFrame = CFrame.new(-222, 77, -188, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.784314, 0.823529),
    Material = Enum.Material.Marble,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "MushroomCluster_4",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(212, 82.5, 20, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.745098, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "AncientPillar_5",
    Size = Vector3.new(3, 8, 3),
    CFrame = CFrame.new(-208, 77, -176, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.784314, 0.823529),
    Material = Enum.Material.Marble,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "AncientPillar_3",
    Size = Vector3.new(3, 8, 3),
    CFrame = CFrame.new(-186, 77, -220, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.784314, 0.823529),
    Material = Enum.Material.Marble,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "AetherFlower_4",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-8, 142.3, 24, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.54902, 0.862745),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "AetherFlower_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(22, 142.3, 8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.54902, 0.862745),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "FloatingRock_3",
    Size = Vector3.new(3, 5, 3),
    CFrame = CFrame.new(-186, 105.5, 10, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.509804, 0.509804, 0.529412),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "GlowingOrb_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(14, 122.5, 184, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.470588, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "CrystalTree_3",
    Size = Vector3.new(3, 6, 3),
    CFrame = CFrame.new(-150, 114, 158, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.862745, 1),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "MushroomCluster_5",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(178, 82.5, 6, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.745098, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "AetherFlower_1",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-20, 142.3, 16, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.54902, 0.862745),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "FloatingRock_5",
    Size = Vector3.new(3, 5, 3),
    CFrame = CFrame.new(-184, 74.1, -162, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.509804, 0.509804, 0.529412),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "FloatingRock_2",
    Size = Vector3.new(3, 5, 3),
    CFrame = CFrame.new(214, 84.5, -8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.509804, 0.509804, 0.529412),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "GlowingOrb_5",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(18, 122.5, 222, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.470588, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "CrystalTree_2",
    Size = Vector3.new(3, 6, 3),
    CFrame = CFrame.new(-164, 114, 144, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.862745, 1),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "MushroomCluster_3",
    Size = Vector3.new(3, 3, 3),
    CFrame = CFrame.new(196, 82.5, -22, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.745098, 0.313726),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "FloatingRock_4",
    Size = Vector3.new(3, 5, 3),
    CFrame = CFrame.new(-188, 75.5, -214, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.509804, 0.509804, 0.529412),
    Material = Enum.Material.Rock,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "AncientPillar_2",
    Size = Vector3.new(3, 8, 3),
    CFrame = CFrame.new(-214, 77, -212, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.784314, 0.784314, 0.823529),
    Material = Enum.Material.Marble,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "CrystalTree_1",
    Size = Vector3.new(3, 6, 3),
    CFrame = CFrame.new(-138, 114, 144, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.862745, 1),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
createPart({
    Name = "AetherFlower_2",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(-15, 142.3, -18, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.54902, 0.862745),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "GlowingOrb_3",
    Size = Vector3.new(2, 2, 2),
    CFrame = CFrame.new(0, 122.5, 192, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.588235, 0.470588, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Props,
})
createPart({
    Name = "CrystalTree_5",
    Size = Vector3.new(3, 6, 3),
    CFrame = CFrame.new(188, 95.5, -214, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.862745, 1),
    Material = Enum.Material.Glass,
    Anchored = true,
    CanCollide = true,
    Parent = Props,
})
local Creatures = Instance.new("Folder")
Creatures.Name = "Creatures"
Creatures.Parent = AetherWorld
local Creatures_EmberDragon_3 =
    createModel("EmberDragon_3", { Speed = "24", Aggressive = "true", CreatureId = "ember_drake" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(120, 92.2, 186.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.298039, 0.0980392),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_EmberDragon_3,
})
local Creatures_EmberDragon_3_HeadWeld = Instance.new("WeldConstraint")
Creatures_EmberDragon_3_HeadWeld.Name = "HeadWeld"
Creatures_EmberDragon_3_HeadWeld.Parent = Creatures_EmberDragon_3
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(120, 93.75, 186.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.298039, 0.0980392),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_EmberDragon_3,
})
local Creatures_SkyWhale_1 =
    createModel("SkyWhale_1", { Speed = "12", Aggressive = "true", CreatureId = "sky_whale" }, Creatures)
local Creatures_SkyWhale_1_HeadWeld = Instance.new("WeldConstraint")
Creatures_SkyWhale_1_HeadWeld.Name = "HeadWeld"
Creatures_SkyWhale_1_HeadWeld.Parent = Creatures_SkyWhale_1
createPart({
    Name = "Body",
    Size = Vector3.new(4, 2.5, 10),
    CFrame = CFrame.new(30, 158, 30.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.627451, 0.862745),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_SkyWhale_1,
})
local Creatures_SkyWhale_1_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_1_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_1_WeldConstraint.Parent = Creatures_SkyWhale_1
createPart({
    Name = "Tail",
    Size = Vector3.new(1.5, 1.5, 3),
    CFrame = CFrame.new(30, 158, 23.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.27451, 0.54902, 0.784314),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_1,
})
local Creatures_SkyWhale_1_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_1_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_1_WeldConstraint.Parent = Creatures_SkyWhale_1
createPart({
    Name = "Eye",
    Size = Vector3.new(0.7, 0.7, 0.7),
    CFrame = CFrame.new(30.9, 159.3, 34.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 1, 1),
    Material = Enum.Material.Neon,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_1,
})
createPart({
    Name = "Fin",
    Size = Vector3.new(1, 0.8, 4),
    CFrame = CFrame.new(32.6, 158.2, 31.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.705882, 0.921569),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_1,
})
local Creatures_SkyWhale_1_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_1_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_1_WeldConstraint.Parent = Creatures_SkyWhale_1
createPart({
    Name = "Fin2",
    Size = Vector3.new(1, 0.8, 4),
    CFrame = CFrame.new(27.4, 158.2, 31.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.705882, 0.921569),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_1,
})
local Creatures_SkyWhale_1_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_1_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_1_WeldConstraint.Parent = Creatures_SkyWhale_1
local Creatures_AetherWolf_3 =
    createModel("AetherWolf_3", { Speed = "16", Aggressive = "false", CreatureId = "shadow_wolf" }, Creatures)
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(8, 144.75, -22, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.698039, 0.698039, 0.898039),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_AetherWolf_3,
})
local Creatures_AetherWolf_3_HeadWeld = Instance.new("WeldConstraint")
Creatures_AetherWolf_3_HeadWeld.Name = "HeadWeld"
Creatures_AetherWolf_3_HeadWeld.Parent = Creatures_AetherWolf_3
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(8, 143.2, -22, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.698039, 0.698039, 0.898039),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_AetherWolf_3,
})
local Creatures_EmberDragon_1 =
    createModel("EmberDragon_1", { Speed = "24", Aggressive = "true", CreatureId = "ember_drake" }, Creatures)
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(112, 93.75, 208.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.298039, 0.0980392),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_EmberDragon_1,
})
local Creatures_EmberDragon_1_HeadWeld = Instance.new("WeldConstraint")
Creatures_EmberDragon_1_HeadWeld.Name = "HeadWeld"
Creatures_EmberDragon_1_HeadWeld.Parent = Creatures_EmberDragon_1
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(112, 92.2, 208.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.298039, 0.0980392),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_EmberDragon_1,
})
local Creatures_SkyWhale_3 =
    createModel("SkyWhale_3", { Speed = "12", Aggressive = "true", CreatureId = "sky_whale" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(4, 2.5, 10),
    CFrame = CFrame.new(10, 175, -34.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.627451, 0.862745),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_SkyWhale_3,
})
local Creatures_SkyWhale_3_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_3_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_3_WeldConstraint.Parent = Creatures_SkyWhale_3
createPart({
    Name = "Tail",
    Size = Vector3.new(1.5, 1.5, 3),
    CFrame = CFrame.new(10, 175, -41.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.27451, 0.54902, 0.784314),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_3,
})
local Creatures_SkyWhale_3_HeadWeld = Instance.new("WeldConstraint")
Creatures_SkyWhale_3_HeadWeld.Name = "HeadWeld"
Creatures_SkyWhale_3_HeadWeld.Parent = Creatures_SkyWhale_3
createPart({
    Name = "Eye",
    Size = Vector3.new(0.7, 0.7, 0.7),
    CFrame = CFrame.new(10.9, 176.3, -30.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 1, 1),
    Material = Enum.Material.Neon,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_3,
})
local Creatures_SkyWhale_3_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_3_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_3_WeldConstraint.Parent = Creatures_SkyWhale_3
local Creatures_SkyWhale_3_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_3_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_3_WeldConstraint.Parent = Creatures_SkyWhale_3
createPart({
    Name = "Fin2",
    Size = Vector3.new(1, 0.8, 4),
    CFrame = CFrame.new(7.4, 175.2, -33.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.705882, 0.921569),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_3,
})
createPart({
    Name = "Fin",
    Size = Vector3.new(1, 0.8, 4),
    CFrame = CFrame.new(12.6, 175.2, -33.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.705882, 0.921569),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_3,
})
local Creatures_SkyWhale_3_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_3_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_3_WeldConstraint.Parent = Creatures_SkyWhale_3
local Creatures_CrystalFox_3 =
    createModel("CrystalFox_3", { Speed = "20", Aggressive = "false", CreatureId = "crystal_fox" }, Creatures)
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(222, 95.75, -207.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.8, 0.898039, 1),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_CrystalFox_3,
})
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(222, 94.2, -207.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.8, 0.898039, 1),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_CrystalFox_3,
})
local Creatures_CrystalFox_3_HeadWeld = Instance.new("WeldConstraint")
Creatures_CrystalFox_3_HeadWeld.Name = "HeadWeld"
Creatures_CrystalFox_3_HeadWeld.Parent = Creatures_CrystalFox_3
local Creatures_SkyWhale_2 =
    createModel("SkyWhale_2", { Speed = "12", Aggressive = "false", CreatureId = "sky_whale" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(4, 2.5, 10),
    CFrame = CFrame.new(-40, 170, 20.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.352941, 0.627451, 0.862745),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_SkyWhale_2,
})
local Creatures_SkyWhale_2_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_2_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_2_WeldConstraint.Parent = Creatures_SkyWhale_2
local Creatures_SkyWhale_2_HeadWeld = Instance.new("WeldConstraint")
Creatures_SkyWhale_2_HeadWeld.Name = "HeadWeld"
Creatures_SkyWhale_2_HeadWeld.Parent = Creatures_SkyWhale_2
createPart({
    Name = "Fin2",
    Size = Vector3.new(1, 0.8, 4),
    CFrame = CFrame.new(-42.6, 170.2, 21.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.705882, 0.921569),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_2,
})
createPart({
    Name = "Eye",
    Size = Vector3.new(0.7, 0.7, 0.7),
    CFrame = CFrame.new(-39.1, 171.3, 24.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 1, 1),
    Material = Enum.Material.Neon,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_2,
})
local Creatures_SkyWhale_2_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_2_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_2_WeldConstraint.Parent = Creatures_SkyWhale_2
local Creatures_SkyWhale_2_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_2_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_2_WeldConstraint.Parent = Creatures_SkyWhale_2
createPart({
    Name = "Tail",
    Size = Vector3.new(1.5, 1.5, 3),
    CFrame = CFrame.new(-40, 170, 13.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.27451, 0.54902, 0.784314),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_2,
})
createPart({
    Name = "Fin",
    Size = Vector3.new(1, 0.8, 4),
    CFrame = CFrame.new(-37.4, 170.2, 21.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.431373, 0.705882, 0.921569),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_SkyWhale_2,
})
local Creatures_SkyWhale_2_WeldConstraint = Instance.new("WeldConstraint")
Creatures_SkyWhale_2_WeldConstraint.Name = "WeldConstraint"
Creatures_SkyWhale_2_WeldConstraint.Parent = Creatures_SkyWhale_2
local Creatures_CloudSprite_2 = createModel("CloudSprite_2", { CreatureId = "cloud_sprite" }, Creatures)
createPart({
    Name = "Head",
    Size = Vector3.new(1.6, 1.6, 1.6),
    CFrame = CFrame.new(205, 86.5, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.901961, 0.960784, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Creatures_CloudSprite_2,
})
createPart({
    Name = "Body",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(205, 84.5, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.705882, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Creatures_CloudSprite_2,
})
local Creatures_EmberDragon_2 =
    createModel("EmberDragon_2", { Speed = "24", Aggressive = "true", CreatureId = "ember_drake" }, Creatures)
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(90, 93.75, 192.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.298039, 0.0980392),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_EmberDragon_2,
})
local Creatures_EmberDragon_2_HeadWeld = Instance.new("WeldConstraint")
Creatures_EmberDragon_2_HeadWeld.Name = "HeadWeld"
Creatures_EmberDragon_2_HeadWeld.Parent = Creatures_EmberDragon_2
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(90, 92.2, 192.25, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(1, 0.298039, 0.0980392),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_EmberDragon_2,
})
local Creatures_CrystalFox_1 =
    createModel("CrystalFox_1", { Speed = "20", Aggressive = "false", CreatureId = "crystal_fox" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(208, 94.2, -189.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.8, 0.898039, 1),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_CrystalFox_1,
})
local Creatures_CrystalFox_1_HeadWeld = Instance.new("WeldConstraint")
Creatures_CrystalFox_1_HeadWeld.Name = "HeadWeld"
Creatures_CrystalFox_1_HeadWeld.Parent = Creatures_CrystalFox_1
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(208, 95.75, -189.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.8, 0.898039, 1),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_CrystalFox_1,
})
local Creatures_AetherWolf_2 =
    createModel("AetherWolf_2", { Speed = "16", Aggressive = "true", CreatureId = "shadow_wolf" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(-18, 143.2, 10, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.698039, 0.698039, 0.898039),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_AetherWolf_2,
})
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(-18, 144.75, 10, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.698039, 0.698039, 0.898039),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_AetherWolf_2,
})
local Creatures_AetherWolf_2_HeadWeld = Instance.new("WeldConstraint")
Creatures_AetherWolf_2_HeadWeld.Name = "HeadWeld"
Creatures_AetherWolf_2_HeadWeld.Parent = Creatures_AetherWolf_2
local Creatures_AetherWolf_1 =
    createModel("AetherWolf_1", { Speed = "16", Aggressive = "false", CreatureId = "shadow_wolf" }, Creatures)
local Creatures_AetherWolf_1_HeadWeld = Instance.new("WeldConstraint")
Creatures_AetherWolf_1_HeadWeld.Name = "HeadWeld"
Creatures_AetherWolf_1_HeadWeld.Parent = Creatures_AetherWolf_1
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(20, 143.2, 8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.698039, 0.698039, 0.898039),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_AetherWolf_1,
})
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(20, 144.75, 8, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.698039, 0.698039, 0.898039),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_AetherWolf_1,
})
local Creatures_VerdantDeer_2 =
    createModel("VerdantDeer_2", { Speed = "18", Aggressive = "true", CreatureId = "verdant_deer" }, Creatures)
local Creatures_VerdantDeer_2_HeadWeld = Instance.new("WeldConstraint")
Creatures_VerdantDeer_2_HeadWeld.Name = "HeadWeld"
Creatures_VerdantDeer_2_HeadWeld.Parent = Creatures_VerdantDeer_2
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(-212, 73.75, -157.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.298039, 0.8, 0.4),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_VerdantDeer_2,
})
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(-212, 72.2, -157.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.298039, 0.8, 0.4),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_VerdantDeer_2,
})
local Creatures_CrystalFox_2 =
    createModel("CrystalFox_2", { Speed = "20", Aggressive = "true", CreatureId = "crystal_fox" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(194, 94.2, -203.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.8, 0.898039, 1),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_CrystalFox_2,
})
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(194, 95.75, -203.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.8, 0.898039, 1),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_CrystalFox_2,
})
local Creatures_CrystalFox_2_HeadWeld = Instance.new("WeldConstraint")
Creatures_CrystalFox_2_HeadWeld.Name = "HeadWeld"
Creatures_CrystalFox_2_HeadWeld.Parent = Creatures_CrystalFox_2
local Creatures_CloudSprite_1 = createModel("CloudSprite_1", { CreatureId = "cloud_sprite" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(2.5, 2.5, 2.5),
    CFrame = CFrame.new(180, 84.5, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.705882, 0.862745, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Creatures_CloudSprite_1,
})
createPart({
    Name = "Head",
    Size = Vector3.new(1.6, 1.6, 1.6),
    CFrame = CFrame.new(180, 86.5, -30, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.901961, 0.960784, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = false,
    Parent = Creatures_CloudSprite_1,
})
local Creatures_VerdantDeer_3 =
    createModel("VerdantDeer_3", { Speed = "18", Aggressive = "true", CreatureId = "verdant_deer" }, Creatures)
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(-182, 73.75, -167.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.298039, 0.8, 0.4),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_VerdantDeer_3,
})
local Creatures_VerdantDeer_3_HeadWeld = Instance.new("WeldConstraint")
Creatures_VerdantDeer_3_HeadWeld.Name = "HeadWeld"
Creatures_VerdantDeer_3_HeadWeld.Parent = Creatures_VerdantDeer_3
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(-182, 72.2, -167.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.298039, 0.8, 0.4),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_VerdantDeer_3,
})
local Creatures_VerdantDeer_1 =
    createModel("VerdantDeer_1", { Speed = "18", Aggressive = "true", CreatureId = "verdant_deer" }, Creatures)
createPart({
    Name = "Body",
    Size = Vector3.new(2, 1.5, 3),
    CFrame = CFrame.new(-190, 72.2, -139.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.298039, 0.8, 0.4),
    Material = Enum.Material.SmoothPlastic,
    Anchored = true,
    CanCollide = true,
    Parent = Creatures_VerdantDeer_1,
})
createPart({
    Name = "Head",
    Size = Vector3.new(1, 1, 1),
    CFrame = CFrame.new(-190, 73.75, -139.75, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.298039, 0.8, 0.4),
    Material = Enum.Material.SmoothPlastic,
    Anchored = false,
    CanCollide = true,
    Parent = Creatures_VerdantDeer_1,
})
local Creatures_VerdantDeer_1_HeadWeld = Instance.new("WeldConstraint")
Creatures_VerdantDeer_1_HeadWeld.Name = "HeadWeld"
Creatures_VerdantDeer_1_HeadWeld.Parent = Creatures_VerdantDeer_1
local Portals = Instance.new("Folder")
Portals.Name = "Portals"
Portals.Parent = AetherWorld
createPart({
    Name = "Portal_5",
    Size = Vector3.new(3, 5, 1),
    CFrame = CFrame.new(184, 92.5, -212, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.498039, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Portals,
})
createPart({
    Name = "Portal_1",
    Size = Vector3.new(3, 5, 1),
    CFrame = CFrame.new(-14, 141.5, 12, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.498039, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Portals,
})
createPart({
    Name = "Portal_4",
    Size = Vector3.new(3, 5, 1),
    CFrame = CFrame.new(0, 121.5, 212, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.498039, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Portals,
})
createPart({
    Name = "Portal_3",
    Size = Vector3.new(3, 5, 1),
    CFrame = CFrame.new(-214, 103, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.498039, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Portals,
})
createPart({
    Name = "Portal_2",
    Size = Vector3.new(3, 5, 1),
    CFrame = CFrame.new(186, 82.5, -4, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    Color = Color3.new(0.498039, 0.498039, 1),
    Material = Enum.Material.Neon,
    Anchored = true,
    CanCollide = true,
    Parent = Portals,
})

AetherWorld.Parent = game.Workspace

return AetherWorld
