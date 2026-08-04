--[[
	TestEZ spec for Harvesting.luau
	Run in Studio via test.project.json → TestRunner

	NOTE: Most Harvesting functions are Roblox-engine-dependent
	(task.wait, Instance.new, workspace, game:GetService).
	This spec tests the pure and semi-pure parts only.
]]

local Modules = script.Parent:WaitForChild("Modules")
local Harvesting = require(Modules:WaitForChild("Harvesting"))

return function()
    describe("Harvesting.New", function()
        it("creates a session with node, tool, player", function()
            local node = { quantity = 10, lastHarvested = 0, respawnTime = 30 }
            local tool = { miningSpeed = 1.0, miningPower = 10, criticalChance = 0.1 }
            local player = {}
            local session = Harvesting.New(node, tool, player)
            expect(session).to.be.ok()
            expect(session.node).to.equal(node)
            expect(session.tool).to.equal(tool)
            expect(session.player).to.equal(player)
        end)
    end)

    describe("Harvesting.GetCriticalChanceMultiplier", function()
        it("returns 2.0", function()
            expect(Harvesting.GetCriticalChanceMultiplier()).to.equal(2.0)
        end)
    end)
end
