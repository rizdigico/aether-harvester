-- Lighting Configuration Script
-- Applies settings from DESIGN-AUDIT.md Section 4.1

local Lighting = game:GetService("Lighting")

-- DESIGN-AUDIT.md Section 4.1 lighting scheme (deep teal fantasy atmosphere)
Lighting.Ambient = Color3.fromRGB(20, 25, 40)
Lighting.OutdoorAmbient = Color3.fromRGB(30, 35, 50)
Lighting.ClockTime = 0.5
Lighting.Brightness = 2

-- Fog (legacy fog API: FogStart/FogEnd/FogColor only - no FogMode property)
Lighting.FogStart = 200
Lighting.FogEnd = 500
Lighting.FogColor = Color3.fromRGB(10, 10, 20)

-- Atmospheric fog for depth
local existing = Lighting:FindFirstChildOfClass("Atmosphere")
local atmosphere = existing or Instance.new("Atmosphere")
atmosphere.Name = "AetherAtmosphere"
atmosphere.Density = 0.15
atmosphere.Offset = 0.4
atmosphere.Color = Color3.fromRGB(13, 27, 42)
atmosphere.Decay = Color3.fromRGB(10, 10, 18)
atmosphere.Glare = 0.2
atmosphere.Haze = 0.3
if not existing then
    atmosphere.Parent = Lighting
end

print("[LightingConfig] Lighting and atmosphere configured")
