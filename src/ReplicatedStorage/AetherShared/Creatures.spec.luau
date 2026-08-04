--[[
	TestEZ spec for Creatures.luau
	Run in Studio via test.project.json → TestRunner

	NOTE: Most Creatures functions depend on workspace, Instance.new, game:GetService.
	This spec tests the pure and semi-pure parts only.
]]

local Modules = script.Parent:WaitForChild("Modules")
local Creatures = require(Modules:WaitForChild("Creatures"))

return function()
    describe("Creatures.New", function()
        it("creates creature manager with empty list", function()
            local mgr = Creatures.New({})
            expect(mgr).to.be.ok()
            expect(#mgr.creatures).to.equal(0)
        end)
    end)

    describe("Creatures getters", function()
        it("GetCount returns 0 for new manager", function()
            local mgr = Creatures.New({})
            expect(mgr:GetCount()).to.equal(0)
        end)

        it("GetAll returns empty table", function()
            local mgr = Creatures.New({})
            expect(#mgr:GetAll()).to.equal(0)
        end)

        it("GetCreature returns nil for unknown", function()
            local mgr = Creatures.New({})
            expect(mgr:GetCreature("NonExistent")).to.equal(nil)
        end)

        it("Get returns nil for invalid index", function()
            local mgr = Creatures.New({})
            expect(mgr:Get(1)).to.equal(nil)
            expect(mgr:Get(0)).to.equal(nil)
            expect(mgr:Get(-1)).to.equal(nil)
        end)
    end)

    describe("Creatures manual operations", function()
        it("releases non-existent creature returns false", function()
            local mgr = Creatures.New({})
            local ok = mgr:Release("NonExistent", {})
            expect(ok).to.equal(false)
        end)
    end)
end
