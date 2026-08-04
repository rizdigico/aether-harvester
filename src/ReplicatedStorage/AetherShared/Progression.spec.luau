--[[
	TestEZ spec for Progression.luau
	Run in Studio via test.project.json → TestRunner
]]

local Modules = script.Parent:WaitForChild("Modules")
local Progression = require(Modules:WaitForChild("Progression"))

return function()
    describe("Progression.New", function()
        it("initializes at level 1", function()
            local p = Progression.New()
            expect(p.level).to.equal(1)
        end)

        it("initializes xp at 0", function()
            local p = Progression.New()
            expect(p.xp).to.equal(0)
        end)

        it("initial xpToNextLevel is 1000", function()
            local p = Progression.New()
            expect(p.xpToNextLevel).to.equal(1000)
        end)

        it("initial skillPoints is 0", function()
            local p = Progression.New()
            expect(p.skillPoints).to.equal(0)
        end)

        it("initial stats are all 1", function()
            local p = Progression.New()
            expect(p.stats.strength).to.equal(1)
            expect(p.stats.agility).to.equal(1)
            expect(p.stats.intelligence).to.equal(1)
            expect(p.stats.defense).to.equal(1)
            expect(p.stats.speed).to.equal(1)
            expect(p.stats.luck).to.equal(1)
        end)
    end)

    describe("Progression.AddXP", function()
        it("adds xp below threshold", function()
            local p = Progression.New()
            p:AddXP(500)
            expect(p.xp).to.equal(500)
            expect(p.level).to.equal(1)
        end)

        it("triggers level up on threshold", function()
            local p = Progression.New()
            p:AddXP(1000)
            expect(p.level).to.equal(2)
            expect(p.xp).to.equal(0)
        end)
    end)

    describe("Progression.LevelUp", function()
        it("increments level", function()
            local p = Progression.New()
            p:LevelUp()
            expect(p.level).to.equal(2)
        end)

        it("increases xpToNextLevel", function()
            local p = Progression.New()
            p:LevelUp()
            expect(p.xpToNextLevel).to.equal(1200)
        end)

        it("awards skill points", function()
            local p = Progression.New()
            p:LevelUp()
            expect(p.skillPoints).to.equal(1)
        end)

        it("updates stats", function()
            local p = Progression.New()
            p:LevelUp()
            expect(p.stats.strength).to.equal(math.floor(2 * 0.5))
            expect(p.stats.speed).to.equal(math.floor(2 * 0.6))
        end)
    end)

    describe("Progression XP curve", function()
        it("xpToNextLevel increases each level", function()
            local p = Progression.New()
            local prev = p.xpToNextLevel
            for _ = 1, 10 do
                p:LevelUp()
                expect(p.xpToNextLevel > prev).to.equal(true)
                prev = p.xpToNextLevel
            end
        end)
    end)

    describe("Progression getters", function()
        it("GetLevel matches field", function()
            local p = Progression.New()
            expect(p:GetLevel()).to.equal(1)
        end)

        it("GetXP matches field", function()
            local p = Progression.New()
            expect(p:GetXP()).to.equal(0)
        end)

        it("GetStats returns table", function()
            local p = Progression.New()
            expect(type(p:GetStats())).to.equal("table")
        end)
    end)
end
