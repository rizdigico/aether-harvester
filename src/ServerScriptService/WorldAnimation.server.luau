-- WorldAnimation: living world effects - halo rotation, beacon pulse, whale flight, rock bob, island drift
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local AetherWorld = Workspace:FindFirstChild("AetherWorld")
if not AetherWorld then
    return
end
local Islands = AetherWorld:FindFirstChild("Islands")
local Creatures = AetherWorld:FindFirstChild("Creatures")
local Props = AetherWorld:FindFirstChild("Props")

-- 1. SkySanctum halo rotation + rune pulse + beacon pulse
local sanctum = Islands and Islands:FindFirstChild("SkySanctum")
local haloParts = {}
if sanctum then
    for _, r in ipairs(sanctum:GetChildren()) do
        if r.Name:match("^Rune%d") then
            table.insert(haloParts, r)
        end
    end
end
local beacon = sanctum and sanctum:FindFirstChild("Beacon")

RunService.Heartbeat:Connect(function()
    local t = os.clock()
    -- rotate runes around the center
    for i, r in ipairs(haloParts) do
        if r.Parent then
            local radius = 41
            local angle = math.rad((i - 1) * 45) + t * 0.15
            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius
            r.Position = Vector3.new(x, 145 + math.sin(t * 2 + i) * 0.4, z)
        end
    end
    -- beacon pulse
    if beacon and beacon.Parent then
        beacon.Transparency = 0.3 + math.sin(t * 3) * 0.15
    end
end)

-- 2. SkyWhale flight: slow circles high above islands
local whales = {}
if Creatures then
    for _, c in ipairs(Creatures:GetChildren()) do
        if c.Name:match("^SkyWhale") then
            local body = c:FindFirstChild("Body")
            if body then
                table.insert(whales, {
                    model = c,
                    body = body,
                    home = body.Position,
                    phase = math.random() * math.pi * 2,
                    radius = 25 + math.random() * 20,
                })
            end
        end
    end
end
RunService.Heartbeat:Connect(function()
    local t = os.clock()
    for _, w in ipairs(whales) do
        if w.model and w.model.Parent then
            local angle = t * 0.1 + w.phase
            local x = w.home.X + math.cos(angle) * w.radius
            local z = w.home.Z + math.sin(angle) * w.radius
            local y = w.home.Y + math.sin(t * 0.3 + w.phase) * 6
            w.body.CFrame = CFrame.new(x, y, z) * CFrame.Angles(0, angle + math.pi / 2, 0)
        end
    end
end)

-- 3. FloatingRocks bob gently
local rocks = {}
if Props then
    for _, p in ipairs(Props:GetChildren()) do
        if p.Name:match("^FloatingRock") and p:IsA("BasePart") then
            table.insert(rocks, { part = p, home = p.Position, phase = math.random() * math.pi * 2 })
        end
    end
end
RunService.Heartbeat:Connect(function()
    local t = os.clock()
    for _, r in ipairs(rocks) do
        if r.part and r.part.Parent then
            r.part.Position = r.home + Vector3.new(0, math.sin(t * 1.2 + r.phase) * 0.8, 0)
            r.part.Orientation = Vector3.new(0, t * 8 + r.phase * 30, math.sin(t * 0.8 + r.phase) * 4)
        end
    end
end)

-- 4. (intentionally omitted: island drift would jitter players/nodes standing on the island)

print(
    "[WorldAnimation] Halo, whales, rocks active: "
        .. #haloParts
        .. " runes, "
        .. #whales
        .. " whales, "
        .. #rocks
        .. " rocks"
)
