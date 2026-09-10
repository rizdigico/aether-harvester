--!strict
-- Roblox-native companion for the Godot Aether Bloom v2 export.
-- The shape and material palette intentionally mirror the 12-node Godot asset
-- while the binary GLB import remains a separate Studio-only gate.

local AetherBloomFactory = {}

local PETAL_COUNT = 6
local TAU = math.pi * 2
local CYAN = Color3.fromRGB(102, 232, 255)
local VIOLET = Color3.fromRGB(178, 125, 255)
local DEEP_VIOLET = Color3.fromRGB(72, 35, 135)

local function createPart(
    className: string,
    name: string,
    size: Vector3,
    cframe: CFrame,
    color: Color3,
    material: Enum.Material,
    parent: Instance
): BasePart
    local part: any = Instance.new(className)
    part.Name = name
    part.Size = size
    part.CFrame = cframe
    part.Color = color
    part.Material = material
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Parent = parent
    return part
end

function AetherBloomFactory.Create(parent: Instance, origin: CFrame): Model
    local model = Instance.new("Model")
    model.Name = "AetherBloom_GodotV2"
    model:SetAttribute("SourceArtifact", "AetherBloom_Godot_v2.glb")
    model:SetAttribute("SourceReference", "aether_bloom_concept_v2.png")
    model:SetAttribute("GeneratedBy", "godot-content-lab")
    model:SetAttribute("AssetVersion", 2)
    model:SetAttribute("ImportStatus", "native-runtime-companion")
    model.Parent = parent

    local stem = createPart(
        "Part",
        "Stem",
        Vector3.new(0.35, 3.2, 0.35),
        origin * CFrame.new(0, 1.6, 0),
        DEEP_VIOLET,
        Enum.Material.SmoothPlastic,
        model
    )
    model.PrimaryPart = stem

    createPart(
        "WedgePart",
        "LeafLeft",
        Vector3.new(1.2, 0.18, 0.5),
        origin * CFrame.new(-0.42, 1.55, 0) * CFrame.Angles(0, 0, math.rad(-18)),
        Color3.fromRGB(57, 181, 178),
        Enum.Material.SmoothPlastic,
        model
    )
    createPart(
        "WedgePart",
        "LeafRight",
        Vector3.new(1.2, 0.18, 0.5),
        origin * CFrame.new(0.42, 1.9, 0) * CFrame.Angles(0, math.pi, math.rad(-18)),
        Color3.fromRGB(74, 210, 190),
        Enum.Material.SmoothPlastic,
        model
    )
    local collar: any = createPart(
        "Part",
        "Collar",
        Vector3.new(1.15, 0.25, 1.15),
        origin * CFrame.new(0, 3.2, 0),
        DEEP_VIOLET,
        Enum.Material.SmoothPlastic,
        model
    )
    collar.Shape = Enum.PartType.Cylinder

    local core: any = createPart(
        "Part",
        "Core",
        Vector3.new(0.85, 0.85, 0.85),
        origin * CFrame.new(0, 3.75, 0),
        CYAN,
        Enum.Material.Neon,
        model
    )
    core.Shape = Enum.PartType.Ball

    local light = Instance.new("PointLight")
    light.Name = "CoreGlow"
    light.Color = CYAN
    light.Brightness = 1.5
    light.Range = 10
    light.Shadows = false
    light.Parent = core

    for index = 1, PETAL_COUNT do
        local angle = (index - 1) * TAU / PETAL_COUNT
        local radial = Vector3.new(math.cos(angle) * 0.72, 4.0, math.sin(angle) * 0.72)
        local petal = createPart(
            "WedgePart",
            "Petal" .. tostring(index),
            Vector3.new(0.9, 0.22, 1.45),
            origin * CFrame.new(radial) * CFrame.Angles(0, -angle, math.rad(-24)),
            if index % 2 == 0 then VIOLET else CYAN,
            Enum.Material.Neon,
            model
        )
        petal:SetAttribute("PetalIndex", index)
    end

    return model
end

return AetherBloomFactory
