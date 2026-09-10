--!strict
-- Server entry: builds AetherWorld from the recovery dump, then boots ServerMain.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local AetherBloomRuntime = require(script.Parent.AetherBloomRuntime)

-- 1. Build the world (idempotent: skip if AetherWorld already exists, e.g. live place)
if not Workspace:FindFirstChild("AetherWorld") then
    require(script.Parent.WorldBuilder)
end

-- Install the first generated Godot-to-Roblox content companion before the
-- gameplay services boot, so the world has deterministic generated content.
AetherBloomRuntime.Initialize()

-- 2. Boot server services
local ServerMain = require(ReplicatedStorage.AetherShared.Modules.ServerMain)
task.wait(2)
ServerMain.Initialize()
print("[BOOT] Aether Harvester Simulator server started successfully")
