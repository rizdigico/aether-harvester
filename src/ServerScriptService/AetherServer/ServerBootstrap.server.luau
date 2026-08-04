--!strict
-- Server entry: builds AetherWorld from the recovery dump, then boots ServerMain.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- 1. Build the world (idempotent: skip if AetherWorld already exists, e.g. live place)
if not Workspace:FindFirstChild("AetherWorld") then
    local WorldBuilder = require(script.Parent.WorldBuilder)
end

-- 2. Boot server services
local ServerMain = require(ReplicatedStorage.AetherShared.Modules.ServerMain)
task.wait(2)
ServerMain.Initialize()
print("[BOOT] Aether Harvester Simulator server started successfully")
