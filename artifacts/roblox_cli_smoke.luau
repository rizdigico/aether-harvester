-- Local Studio command-line smoke test for the generated Aether Harvester place.
-- This is intentionally bounded: it does not publish, save, or contact services.
local Workspace = game:GetService("Workspace")
local ServerScriptService = game:GetService("ServerScriptService")

local server = ServerScriptService:FindFirstChild("AetherServer")
assert(server, "AetherServer folder is missing")

if not Workspace:FindFirstChild("AetherWorld") then
	local worldBuilder = server:FindFirstChild("WorldBuilder")
		or error("WorldBuilder module is missing")
	require(worldBuilder)
end

local bloomRuntime = server:FindFirstChild("AetherBloomRuntime")
	or error("AetherBloomRuntime module is missing")
local installed = require(bloomRuntime).Initialize()
assert(installed == true, "AetherBloomRuntime.Initialize did not report success")

local world = Workspace:FindFirstChild("AetherWorld")
assert(world, "AetherWorld was not built")
local islands = world:FindFirstChild("Islands")
assert(islands, "AetherWorld.Islands is missing")
local crystalSpires = islands:FindFirstChild("CrystalSpires")
assert(crystalSpires, "CrystalSpires is missing")
local generatedContent = crystalSpires:FindFirstChild("GeneratedContent")
assert(generatedContent, "GeneratedContent folder is missing")
local bloom = generatedContent:FindFirstChild("AetherBloom_GodotV2")
assert(bloom, "AetherBloom_GodotV2 is missing")
assert(bloom:GetAttribute("SourceArtifact") == "AetherBloom_Godot_v2.glb", "source artifact marker mismatch")
assert(bloom:GetAttribute("ImportStatus") == "native-runtime-companion", "import status marker mismatch")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerMain = require(ReplicatedStorage.AetherShared.Modules.ServerMain)
ServerMain.Initialize()

local tutorialService = ServerMain.GetService("TutorialService")
assert(tutorialService, "TutorialService was not registered")
assert(ReplicatedStorage.AetherShared.Remotes:FindFirstChild("TutorialUpdated"), "TutorialUpdated remote is missing")
assert(ReplicatedStorage.AetherShared.Remotes:FindFirstChild("GetTutorial"), "GetTutorial remote is missing")

local nodeManager = ServerMain.GetService("NodeManager")
assert(nodeManager, "NodeManager was not registered")
local nodes = nodeManager.GetAllNodes()
local nodeCount = #nodes
local promptCount = 0
for _, node in ipairs(nodes) do
	assert(node:GetAttribute("NodeId") == node.Name, "node id marker missing: " .. node.Name)
	if node:FindFirstChild("HarvestPrompt", true) then
		promptCount += 1
	end
end
assert(nodeCount == 29, "unexpected resource node count: " .. tostring(nodeCount))
assert(promptCount == nodeCount, "not every resource node has a harvest prompt")

print("[CLI_SMOKE] PASS AetherWorld built")
print("[CLI_SMOKE] PASS CrystalSpires generated content installed")
print("[CLI_SMOKE] PASS Bloom source=" .. tostring(bloom:GetAttribute("SourceArtifact")))
print("[CLI_SMOKE] PASS Bloom version=" .. tostring(bloom:GetAttribute("AssetVersion")))
print("[CLI_SMOKE] PASS ServerMain initialized all services")
print("[CLI_SMOKE] PASS TutorialService and tutorial remotes wired")
print("[CLI_SMOKE] PASS " .. tostring(nodeCount) .. " harvest prompts wired")
