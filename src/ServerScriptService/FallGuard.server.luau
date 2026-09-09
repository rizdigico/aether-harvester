-- FallGuard Script
-- Teleports players back to the spawn island if they fall off

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local WorldManager = require(game.ServerScriptService.AetherServer.GameServices.WorldManager)

-- Fall threshold: islands float at y>=70; anything below y=30 is off the world
local FALL_Y = 30
local RETURN_ISLAND = "SkySanctum"

local function returnToSpawn(player)
    local character = player.Character
    if not character then
        return
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then
        return
    end
    local ok = WorldManager.TeleportPlayerToIsland(player, RETURN_ISLAND)
    if ok then
        print("[FallGuard] " .. player.Name .. " returned to " .. RETURN_ISLAND)
    end
end

local function trackPlayer(player)
    player.CharacterAdded:Connect(function(character)
        local root = character:WaitForChild("HumanoidRootPart", 5)
        if not root then
            return
        end
        -- Poll position; if the player falls below the world, bring them back
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not root.Parent then
                conn:Disconnect()
                return
            end
            if root.Position.Y < FALL_Y then
                conn:Disconnect()
                returnToSpawn(player)
            end
        end)
    end)
end

Players.PlayerAdded:Connect(trackPlayer)
for _, player in ipairs(Players:GetPlayers()) do
    trackPlayer(player)
end

print("[FallGuard] Active - players falling below y=" .. FALL_Y .. " return to " .. RETURN_ISLAND)
