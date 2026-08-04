--[[
	TestEZ spec for Trading.luau
	Run in Studio via test.project.json → TestRunner

	NOTE: Most Trading functions depend on game.Players and game:GetService.
	This spec tests the pure and semi-pure parts only.
]]

local Modules = script.Parent:WaitForChild("Modules")
local Trading = require(Modules:WaitForChild("Trading"))

return function()
    describe("Trading.New", function()
        it("creates trading state with nil trade", function()
            local state = Trading.New({})
            expect(state).to.be.ok()
            expect(state.trade).to.equal(nil)
        end)

        it("initializes empty marketplace", function()
            local state = Trading.New({})
            expect(state.marketplace).to.be.ok()
            expect(#state.marketplace.listings).to.equal(0)
        end)
    end)

    describe("Trading status getters", function()
        it("GetTradeStatus returns 'no trade' when no trade", function()
            local state = Trading.New({})
            expect(state:GetTradeStatus()).to.equal("no trade")
        end)

        it("GetTradeItems returns nil when no trade", function()
            local state = Trading.New({})
            expect(state:GetTradeItems()).to.equal(nil)
        end)

        it("GetTradeCurrency returns nil when no trade", function()
            local state = Trading.New({})
            expect(state:GetTradeCurrency()).to.equal(nil)
        end)

        it("GetMarketplaceListings returns empty table", function()
            local state = Trading.New({})
            expect(#state:GetMarketplaceListings()).to.equal(0)
        end)
    end)

    describe("Trading lifecycle (manual setup)", function()
        it("acceptTrade fails when no trade", function()
            local state = Trading.New({})
            local ok = state:AcceptTrade()
            expect(ok).to.equal(false)
        end)

        it("confirmTrade fails when no trade", function()
            local state = Trading.New({})
            local ok = state:ConfirmTrade()
            expect(ok).to.equal(false)
        end)

        it("cancelTrade fails when no trade", function()
            local state = Trading.New({})
            local ok = state:CancelTrade()
            expect(ok).to.equal(false)
        end)
    end)
end
