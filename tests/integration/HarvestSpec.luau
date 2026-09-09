--!strict
-- HarvestSpec: exercises NodeManager.ProcessHarvest server-side with a real node
-- and a real Player. ProcessHarvest calls FireClient on remotes (NodeHarvested,
-- UpdateHUD, AchievementUnlocked, etc.), which requires a genuine Player instance,
-- so a mock table would crash. This spec runs only when a real player is connected
-- in Studio play mode.

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local function waitFor(fn: () -> any, timeout: number)
    local deadline = os.clock() + timeout
    local value = fn()
    while (value == nil or value == false) and os.clock() < deadline do
        task.wait(0.2)
        value = fn()
    end
    return value
end

return function()
    describe("harvest core loop (needs a connected player)", function()
        local NodeManager = require(ServerScriptService.AetherServer.GameServices.NodeManager)
        local PlayerDataService = require(ServerScriptService.AetherServer.GameServices.PlayerDataService)

        it("finds a real player in Studio play mode", function()
            local player = waitFor(function()
                local p = Players:GetPlayers()
                return p and #p > 0 and p[1] or nil
            end, 15)
            expect(player).never.to.equal(nil)
        end)

        it("ProcessHarvest returns true and grants the resource", function()
            local player = waitFor(function()
                local p = Players:GetPlayers()
                return p and #p > 0 and p[1] or nil
            end, 15)
            expect(player).never.to.equal(nil)

            -- Wait for a real node to be present and the world to be built.
            local node = waitFor(function()
                local nodes = NodeManager.GetAllNodes()
                return nodes and #nodes > 0 and nodes[1] or nil
            end, 15)
            expect(node).never.to.equal(nil)

            -- Ensure the node is not on cooldown from a prior harvest run.
            local cooldown = NodeManager.IsNodeAvailable(node)
            if not cooldown then
                -- Force availability by clearing the internal activeNodes entry via a new harvest
                -- is not possible without internals; instead re-pick the first available node.
                for _, candidate in ipairs(NodeManager.GetAllNodes()) do
                    if NodeManager.IsNodeAvailable(candidate) then
                        node = candidate
                        break
                    end
                end
            end

            local nodeType = NodeManager.GetNodeType(node)
            expect(nodeType).never.to.equal(nil)

            -- Move the player's character next to the node so distance checks pass.
            local character = player.Character
            expect(character).never.to.equal(nil)
            local hrp = character:FindFirstChild("HumanoidRootPart")
            expect(hrp).never.to.equal(nil)
            local okPivot = pcall(function()
                return node:GetPivot()
            end)
            expect(okPivot).to.equal(true)
            hrp.CFrame = CFrame.new((node :: Instance):GetPivot().Position + Vector3.new(0, 3, 0))

            -- Read resource count before, then harvest.
            local resourceId = nodeType.ResourceId
            local before = PlayerDataService.GetItemCount(player, resourceId)
            local success, _result = NodeManager.ProcessHarvest(player, node)

            expect(success).to.equal(true)

            local after = PlayerDataService.GetItemCount(player, resourceId)
            expect(after > before).to.equal(true)

            -- HarvestCount stat incremented.
            local data = PlayerDataService.GetData(player)
            expect(data).never.to.equal(nil)
            expect((data.Stats and data.Stats.HarvestCount or 0) >= 1).to.equal(true)
        end)
    end)
end
