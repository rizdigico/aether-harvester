--[[
	TestEZ spec for Modules/Utils.luau
	Run in Studio via test.project.json → TestRunner
]]

local Modules = script.Parent:WaitForChild("Modules")
local Utils = require(Modules:WaitForChild("Utils"))

return function()
    describe("Utils.Constants", function()
        it("GAME_VERSION is a string", function()
            expect(type(Utils.Constants.GAME_VERSION)).to.equal("string")
        end)

        it("MAX_LEVEL is 100", function()
            expect(Utils.Constants.MAX_LEVEL).to.equal(100)
        end)

        it("MAX_INVENTORY_SLOTS_BASE is 50", function()
            expect(Utils.Constants.MAX_INVENTORY_SLOTS_BASE).to.equal(50)
        end)
    end)

    describe("Utils.Enums", function()
        it("ItemRarity.Common is 1", function()
            expect(Utils.Enums.ItemRarity.Common).to.equal(1)
        end)

        it("ItemRarity.Mythic is 6", function()
            expect(Utils.Enums.ItemRarity.Mythic).to.equal(6)
        end)
    end)

    describe("Utils.clamp", function()
        it("clamps above max", function()
            expect(Utils.clamp(150, 0, 100)).to.equal(100)
        end)

        it("clamps below min", function()
            expect(Utils.clamp(-50, 0, 100)).to.equal(0)
        end)

        it("keeps in-range", function()
            expect(Utils.clamp(42, 0, 100)).to.equal(42)
        end)
    end)

    describe("Utils.lerp", function()
        it("lerp at midpoint", function()
            expect(Utils.lerp(0.5, 0, 100)).to.equal(50)
        end)

        it("lerp at start", function()
            expect(Utils.lerp(0, 10, 20)).to.equal(10)
        end)

        it("lerp at end", function()
            expect(Utils.lerp(1, 10, 20)).to.equal(20)
        end)
    end)

    describe("Utils.distance2D", function()
        it("returns squared distance", function()
            expect(Utils.distance2D(0, 0, 3, 4)).to.equal(25)
        end)
    end)

    describe("Utils.distance3D", function()
        it("calculates Euclidean distance", function()
            local d = Utils.distance3D(0, 0, 0, 1, 2, 2)
            expect(d).to.be.near(3, 0.001)
        end)
    end)

    describe("Utils.angleBetween", function()
        it("perpendicular vectors = pi/2", function()
            local a = Utils.angleBetween(1, 0, 0, 1)
            expect(a).to.be.near(math.pi / 2, 0.001)
        end)

        it("parallel vectors = 0", function()
            local a = Utils.angleBetween(1, 0, 1, 0)
            expect(a).to.be.near(0, 0.001)
        end)
    end)

    describe("Utils.mapRange", function()
        it("maps midpoint", function()
            expect(Utils.mapRange(50, 0, 100, 0, 1000)).to.equal(500)
        end)
    end)

    describe("Utils.roundTo", function()
        it("rounds to integer", function()
            expect(Utils.roundTo(3.7)).to.equal(4)
        end)

        it("rounds to precision", function()
            expect(Utils.roundTo(3.14159, 2)).to.equal(3.14)
        end)
    end)

    describe("Utils.formatNumber", function()
        it("formats thousands", function()
            expect(Utils.formatNumber(1000000)).to.equal("1,000,000")
        end)

        it("formats small number", function()
            expect(Utils.formatNumber(42)).to.equal("42")
        end)
    end)

    describe("Utils.formatTime", function()
        it("formats seconds only", function()
            expect(Utils.formatTime(30)).to.equal("30s")
        end)

        it("formats hours", function()
            expect(Utils.formatTime(3661)).to.equal("1h 1m 1s")
        end)
    end)

    describe("Utils.truncate", function()
        it("truncates long string", function()
            expect(Utils.truncate("Hello World", 5)).to.equal("He...")
        end)

        it("keeps short string", function()
            expect(Utils.truncate("Hi", 5)).to.equal("Hi")
        end)
    end)

    describe("Utils.generateUID", function()
        it("generates default length", function()
            expect(#Utils.generateUID()).to.equal(8)
        end)

        it("generates custom length", function()
            expect(#Utils.generateUID(16)).to.equal(16)
        end)
    end)

    describe("Utils.deepClone", function()
        it("clones nested table", function()
            local original = { a = 1, b = { c = 2 } }
            local cloned = Utils.deepClone(original)
            expect(cloned.a).to.equal(1)
            expect(cloned.b.c).to.equal(2)
            cloned.b.c = 99
            expect(original.b.c).to.equal(2)
        end)
    end)

    describe("Utils.merge", function()
        it("merges with overwrite", function()
            local target = { a = 1, b = 2 }
            local source = { b = 3, c = 4 }
            local result = Utils.merge(target, source)
            expect(result.a).to.equal(1)
            expect(result.b).to.equal(3)
            expect(result.c).to.equal(4)
        end)
    end)

    describe("Utils.filter", function()
        it("filters correctly", function()
            local data = { 1, 2, 3, 4, 5 }
            local result = Utils.filter(data, function(v)
                return v > 3
            end)
            expect(#result).to.equal(2)
            expect(result[1]).to.equal(4)
        end)
    end)

    describe("Utils.find", function()
        it("finds matching element", function()
            local data = { 10, 20, 30 }
            local result = Utils.find(data, function(v)
                return v == 20
            end)
            expect(result).to.equal(20)
        end)

        it("returns nil when not found", function()
            local data = { 10, 20, 30 }
            local result = Utils.find(data, function(v)
                return v == 99
            end)
            expect(result).to.equal(nil)
        end)
    end)

    describe("Utils.contains", function()
        it("returns true for present", function()
            expect(Utils.contains({ 1, 2, 3 }, 2)).to.equal(true)
        end)

        it("returns false for absent", function()
            expect(Utils.contains({ 1, 2, 3 }, 4)).to.equal(false)
        end)
    end)

    describe("Utils.count", function()
        it("counts entries", function()
            expect(Utils.count({ a = 1, b = 2, c = 3 })).to.equal(3)
        end)

        it("counts empty", function()
            expect(Utils.count({})).to.equal(0)
        end)
    end)

    describe("Utils.isPositiveInteger", function()
        it("accepts positive integer", function()
            expect(Utils.isPositiveInteger(5)).to.equal(true)
        end)

        it("rejects zero", function()
            expect(Utils.isPositiveInteger(0)).to.equal(false)
        end)

        it("rejects float", function()
            expect(Utils.isPositiveInteger(3.5)).to.equal(false)
        end)
    end)

    describe("Utils.isNonNegativeInteger", function()
        it("accepts zero", function()
            expect(Utils.isNonNegativeInteger(0)).to.equal(true)
        end)

        it("rejects negative", function()
            expect(Utils.isNonNegativeInteger(-1)).to.equal(false)
        end)
    end)

    describe("Utils.isValidItemId", function()
        it("accepts positive integer", function()
            expect(Utils.isValidItemId(1)).to.equal(true)
        end)

        it("rejects zero", function()
            expect(Utils.isValidItemId(0)).to.equal(false)
        end)
    end)
end
