--!strict
local Util = require(game.ReplicatedStorage.AetherShared.Util)

return {
    describe("Util.clamp", function()
        it("clamps values above the max", function()
            expect(Util.clamp(150, 0, 100)).to.equal(100)
        end)

        it("clamps values below the min", function()
            expect(Util.clamp(-50, 0, 100)).to.equal(0)
        end)

        it("leaves in-range values unchanged", function()
            expect(Util.clamp(42, 0, 100)).to.equal(42)
        end)
    end),

    describe("Util.safeDivide", function()
        it("divides normally with non-zero divisor", function()
            expect(Util.safeDivide(10, 2, -1)).to.equal(5)
        end)

        it("returns fallback on zero divisor", function()
            expect(Util.safeDivide(10, 0, -1)).to.equal(-1)
        end)
    end),
}
