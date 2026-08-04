--[[
	TestEZ spec for Events.luau
	Run in Studio via test.project.json → TestRunner

	NOTE: Events uses Enum.create, Vector3.new, and game.Players.
	This spec tests the pure management parts only.
]]

local Modules = script.Parent:WaitForChild("Modules")
local Events = require(Modules:WaitForChild("Events"))

return function()
    describe("Events.New", function()
        it("creates event system with empty lists", function()
            local sys = Events.New()
            expect(sys).to.be.ok()
            expect(#sys.events).to.equal(0)
        end)
    end)

    describe("Events CRUD", function()
        it("CreateEvent returns false for nil data", function()
            local sys = Events.New()
            local ok = sys:CreateEvent(nil)
            expect(ok).to.equal(false)
        end)

        it("CreateEvent returns false for invalid data", function()
            local sys = Events.New()
            local ok = sys:CreateEvent({ name = nil, displayName = nil, description = nil })
            expect(ok).to.equal(false)
        end)

        it("GetEvent returns nil for unknown", function()
            local sys = Events.New()
            expect(sys:GetEvent("NonExistent")).to.equal(nil)
        end)
    end)

    describe("Events getters", function()
        it("GetAllEvents returns empty table", function()
            local sys = Events.New()
            expect(#sys:GetAllEvents()).to.equal(0)
        end)

        it("GetActiveEvents returns empty table", function()
            local sys = Events.New()
            expect(#sys:GetActiveEvents()).to.equal(0)
        end)

        it("GetEventsByStatus returns empty table", function()
            local sys = Events.New()
            expect(#sys:GetEventsByStatus("active")).to.equal(0)
        end)
    end)
end
