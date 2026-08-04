--[[
	TestEZ spec for Inventory.luau
	Run in Studio via test.project.json → TestRunner
]]

local Modules = script.Parent:WaitForChild("Modules")
local Inventory = require(Modules:WaitForChild("Inventory"))

return function()
    describe("Inventory.New", function()
        it("creates inventory with 30 slots", function()
            local inv = Inventory.New()
            expect(#inv.slots).to.equal(30)
        end)

        it("all slots are empty", function()
            local inv = Inventory.New()
            for _, slot in ipairs(inv.slots) do
                expect(slot.itemName).to.equal(nil)
                expect(slot.quantity).to.equal(0)
            end
        end)

        it("currency starts at 0", function()
            local inv = Inventory.New()
            expect(inv.currency.gold).to.equal(0)
            expect(inv.currency.aether).to.equal(0)
        end)

        it("equipped items start nil", function()
            local inv = Inventory.New()
            expect(inv.equippedItems.weapon).to.equal(nil)
            expect(inv.equippedItems.armor).to.equal(nil)
            expect(inv.equippedItems.tool).to.equal(nil)
        end)
    end)

    describe("Inventory currency ops", function()
        it("adds gold", function()
            local inv = Inventory.New()
            inv:AddCurrency("gold", 100)
            expect(inv.currency.gold).to.equal(100)
        end)

        it("adds aether", function()
            local inv = Inventory.New()
            inv:AddCurrency("aether", 50)
            expect(inv.currency.aether).to.equal(50)
        end)

        it("removes gold when sufficient", function()
            local inv = Inventory.New()
            inv:AddCurrency("gold", 100)
            local ok = inv:RemoveCurrency("gold", 60)
            expect(ok).to.equal(true)
            expect(inv.currency.gold).to.equal(40)
        end)

        it("fails to remove gold when insufficient", function()
            local inv = Inventory.New()
            inv:AddCurrency("gold", 10)
            local ok = inv:RemoveCurrency("gold", 50)
            expect(ok).to.equal(false)
            expect(inv.currency.gold).to.equal(10)
        end)
    end)

    describe("Inventory getters", function()
        it("GetSize returns 30", function()
            local inv = Inventory.New()
            expect(inv:GetSize()).to.equal(30)
        end)

        it("GetSlots returns slots table", function()
            local inv = Inventory.New()
            expect(#inv:GetSlots()).to.equal(30)
        end)

        it("GetCurrency returns currency", function()
            local inv = Inventory.New()
            local c = inv:GetCurrency()
            expect(c.gold).to.equal(0)
            expect(c.aether).to.equal(0)
        end)
    end)
end
