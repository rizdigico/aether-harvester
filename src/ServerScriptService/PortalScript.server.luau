-- PortalScript: touch a portal to travel to its target island
local Workspace = game:GetService("Workspace")
local WorldManager = require(game.ServerScriptService.AetherServer.GameServices.WorldManager)

local PortalsFolder = Workspace.AetherWorld and Workspace.AetherWorld:FindFirstChild("Portals")
if not PortalsFolder then
    return
end

local cooldowns = {} -- player.UserId -> os.time()

-- attach touch to every portal
local function setupPortals()
    for _, portal in ipairs(PortalsFolder:GetChildren()) do
        if portal:IsA("BasePart") and not portal:FindFirstChild("PortalTouch") then
            local touch = Instance.new("ClickDetector")
            touch.Name = "PortalTouch"
            touch.MaxActivationDistance = 20
            touch.Parent = portal
            touch.MouseClick:Connect(function(plr)
                local now = os.time()
                if cooldowns[plr.UserId] and (now - cooldowns[plr.UserId]) < 3 then
                    return
                end
                cooldowns[plr.UserId] = now
                local target = portal:GetAttribute("TargetIsland")
                if not target or target == "" then
                    return
                end
                if portal:IsA("BasePart") then
                    portal.Color = Color3.fromRGB(255, 255, 255)
                    task.delay(0.25, function()
                        if portal.Parent then
                            portal.Color = Color3.fromRGB(120, 200, 255)
                        end
                    end)
                end
                local ok = WorldManager.TeleportPlayerToIsland(plr, target)
                if ok then
                    print("[PortalScript] " .. plr.Name .. " traveled to " .. target)
                end
            end)
        end
    end
end

setupPortals()
PortalsFolder.ChildAdded:Connect(function(child)
    if child:IsA("BasePart") then
        task.wait(0.1)
        setupPortals()
    end
end)

print("[PortalScript] Portals wired: " .. #PortalsFolder:GetChildren() .. " portals")
