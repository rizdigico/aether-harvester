--!strict
-- BootSpec: proves the recovered game boots in Studio play mode.
-- ServerBootstrap builds AetherWorld via WorldBuilder, then ServerMain.Initialize()
-- registers the 24 services after a 2s wait, so these tests poll up to 15s.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local function waitFor(fn: () -> any, timeout: number)
    local deadline = os.clock() + timeout
    local value = fn()
    while (value == nil or value == false) and os.clock() < deadline do
        task.wait(0.2)
        value = fn()
    end
    return value
end

-- Names of the 24 services ServerMain.Initialize() registers in dependency order.
local EXPECTED_SERVICES = {
    "WorldManager",
    "NodeManager",
    "PlayerDataService",
    "QuestService",
    "CreatureService",
    "EconomyService",
    "PetService",
    "AchievementService",
    "UpgradeService",
    "TradingService",
    "GuildService",
    "EventService",
    "CraftingService",
    "DailyRewardsService",
    "MailService",
    "ChatService",
    "AnalyticsService",
    "AntiCheatService",
    "CosmeticService",
    "BattlePassService",
    "MarketplaceService",
    "LeaderboardService",
    "ProgressionService",
    "RewardService",
}

return function()
    describe("AetherWorld is built at server boot", function()
        it("AetherWorld folder exists under Workspace", function()
            local aw = waitFor(function()
                return Workspace:FindFirstChild("AetherWorld")
            end, 15)
            expect(aw).never.to.equal(nil)
        end)

        it("AetherWorld contains an Islands folder", function()
            local aw = waitFor(function()
                return Workspace:FindFirstChild("AetherWorld")
            end, 15)
            expect(aw).never.to.equal(nil)
            local awFolder = aw :: Instance
            expect(awFolder:FindFirstChild("Islands")).never.to.equal(nil)
        end)

        it("has at least 10 playable island Models in the Islands folder", function()
            local aw = waitFor(function()
                return Workspace:FindFirstChild("AetherWorld")
            end, 15)
            expect(aw).never.to.equal(nil)
            local islands = (aw :: Instance):FindFirstChild("Islands")
            expect(islands).never.to.equal(nil)

            -- Count models whose name matches a WorldManager island definition.
            local WorldManager = require(ServerScriptService.AetherServer.GameServices.WorldManager)
            local count = 0
            for _, child in ipairs((islands :: Instance):GetChildren()) do
                if child:IsA("Model") and WorldManager.IslandDefs[child.Name] then
                    count += 1
                end
            end
            expect(count >= 10).to.equal(true)
        end)
    end)

    describe("harvest node discovery", function()
        it("NodeManager discovers at least 20 resource nodes", function()
            local NodeManager = require(ServerScriptService.AetherServer.GameServices.NodeManager)
            expect(NodeManager).never.to.equal(nil)
            local nodes = waitFor(function()
                local n = NodeManager.GetAllNodes()
                return #n >= 20 and n or nil
            end, 15)
            expect(nodes).never.to.equal(nil)
            local nodeList = nodes :: { any }
            expect(#nodeList >= 20).to.equal(true)
        end)
    end)

    describe("server services", function()
        it("all 24 services are registered after boot", function()
            local ServerMain = require(ReplicatedStorage.AetherShared.Modules.ServerMain)
            -- Poll until every expected service is resolvable (Initialize ran).
            local allReady = waitFor(function()
                local ok = true
                for _, name in ipairs(EXPECTED_SERVICES) do
                    if ServerMain.GetService(name) == nil then
                        ok = false
                        break
                    end
                end
                return ok and true or nil
            end, 15)
            expect(allReady).never.to.equal(nil)

            -- Sanity: spot-check a couple of services expose the core API surface.
            expect(ServerMain.GetService("NodeManager").ProcessHarvest).never.to.equal(nil)
            expect(ServerMain.GetService("PlayerDataService").AddItem).never.to.equal(nil)
        end)
    end)
end
