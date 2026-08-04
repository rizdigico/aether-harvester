--
-- Progression.luau
-- Progression module for Aether Harvester Simulator
--

local Progression = {}

-- Constants
local XP_PER_LEVEL = 1000
local MAX_LEVEL = 100
local SKILL_POINTS_PER_LEVEL = 1
local SKILL_TREE_COUNT = 5

--[[
    PROGRESSION STRUCTURE:
    {
        level = 1,
        xp = 0,
        xpToNextLevel = XP_PER_LEVEL,
        skillPoints = 0,
        skillTrees = {
            {
                name = "Combat",
                unlockedSkills = {
                    {
                        name = "BasicAttack",
                        level = 1,
                        unlocked = true
                    }
                },
                lockedSkills = {
                    {
                        name = "AdvancedAttack",
                        level = 2,
                        unlocked = false
                    }
                }
            }
        },
        stats = {
            strength = 1,
            agility = 1,
            intelligence = 1,
            defense = 1,
            speed = 1,
            luck = 1
        }
    }
]]

-- Initialize a new progression system
function Progression.New()
    return {
        level = 1,
        xp = 0,
        xpToNextLevel = XP_PER_LEVEL,
        skillPoints = 0,
        skillTrees = {},
        stats = {
            strength = 1,
            agility = 1,
            intelligence = 1,
            defense = 1,
            speed = 1,
            luck = 1
        }
    }
end

-- Add XP to player
function Progression:AddXP(amount)
    self.xp = self.xp + amount
    
    -- Check if player has leveled up
    while self.xp >= self.xpToNextLevel and self.level < MAX_LEVEL do
        self:LevelUp()
    end
    
    return self.xp
end

-- Level up player
function Progression:LevelUp()
    self.level = self.level + 1
    self.xp = self.xp - self.xpToNextLevel
    self.xpToNextLevel = self.xpToNextLevel + (XP_PER_LEVEL * 0.1 * self.level)
    self.skillPoints = self.skillPoints + SKILL_POINTS_PER_LEVEL
    
    -- Update stats based on level
    self:UpdateStats()
    
    return self.level
end

-- Update stats based on level
function Progression:UpdateStats()
    -- Base stat growth
    self.stats.strength = math.floor(self.level * 0.5)
    self.stats.agility = math.floor(self.level * 0.4)
    self.stats.intelligence = math.floor(self.level * 0.3)
    self.stats.defense = math.floor(self.level * 0.4)
    self.stats.speed = math.floor(self.level * 0.6)
    self.stats.luck = math.floor(self.level * 0.2)
end

-- Initialize skill trees
function Progression:InitializeSkillTrees()
    -- Combat skill tree
    local combatTree = {
        name = "Combat",
        description = "Increase combat effectiveness.",
        unlockedSkills = {
            {
                name = "BasicAttack",
                level = 1,
                description = "Increase basic attack damage.",
                effect = function(player)
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:SetAttribute("AttackDamage", (humanoid:GetAttribute("AttackDamage") or 5) + 1)
                    end
                end
            }
        },
        lockedSkills = {
            {
                name = "AdvancedAttack",
                level = 2,
                description = "Increase advanced attack damage.",
                effect = function(player)
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:SetAttribute("AdvancedAttackDamage", (humanoid:GetAttribute("AdvancedAttackDamage") or 0) + 2)
                    end
                end
            },
            {
                name = "DefenseBoost",
                level = 2,
                description = "Increase defense.",
                effect = function(player)
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:SetAttribute("Defense", (humanoid:GetAttribute("Defense") or 0) + 1)
                    end
                end
            }
        }
    }
    table.insert(self.skillTrees, combatTree)
    
    -- Crafting skill tree
    local craftingTree = {
        name = "Crafting",
        description = "Improve crafting skills.",
        unlockedSkills = {
            {
                name = "FasterCrafting",
                level = 1,
                description = "Reduce crafting time.",
                effect = function(player)
                    local craftingSpeed = player:GetAttribute("CraftingSpeed") or 1.0
                    player:SetAttribute("CraftingSpeed", craftingSpeed * 0.9)
                end
            }
        },
        lockedSkills = {
            {
                name = "BetterRecipes",
                level = 2,
                description = "Unlock better recipes.",
                effect = function(player)
                    -- Unlock better recipes
                    player:SetAttribute("UnlockedRecipes", (player:GetAttribute("UnlockedRecipes") or 0) + 1)
                end
            }
        }
    }
    table.insert(self.skillTrees, craftingTree)
    
    -- Mining skill tree
    local miningTree = {
        name = "Mining",
        description = "Improve mining efficiency.",
        unlockedSkills = {
            {
                name = "MiningSpeed",
                level = 1,
                description = "Increase mining speed.",
                effect = function(player)
                    local miningSpeed = player:GetAttribute("MiningSpeed") or 1.0
                    player:SetAttribute("MiningSpeed", miningSpeed * 1.1)
                end
            }
        },
        lockedSkills = {
            {
                name = "MiningPower",
                level = 2,
                description = "Increase mining power.",
                effect = function(player)
                    local miningPower = player:GetAttribute("MiningPower") or 1.0
                    player:SetAttribute("MiningPower", miningPower * 1.2)
                end
            }
        }
    }
    table.insert(self.skillTrees, miningTree)
    
    -- Exploration skill tree
    local explorationTree = {
        name = "Exploration",
        description = "Improve exploration skills.",
        unlockedSkills = {
            {
                name = "FasterTravel",
                level = 1,
                description = "Reduce travel time.",
                effect = function(player)
                    local travelSpeed = player:GetAttribute("TravelSpeed") or 1.0
                    player:SetAttribute("TravelSpeed", travelSpeed * 1.1)
                end
            }
        },
        lockedSkills = {
            {
                name = "BetterSenses",
                level = 2,
                description = "Improve senses.",
                effect = function(player)
                    local senses = player:GetAttribute("Senses") or 0
                    player:SetAttribute("Senses", senses + 1)
                end
            }
        }
    }
    table.insert(self.skillTrees, explorationTree)
    
    -- Social skill tree
    local socialTree = {
        name = "Social",
        description = "Improve social skills.",
        unlockedSkills = {
            {
                name = "Charisma",
                level = 1,
                description = "Increase charisma.",
                effect = function(player)
                    local charisma = player:GetAttribute("Charisma") or 0
                    player:SetAttribute("Charisma", charisma + 1)
                end
            }
        },
        lockedSkills = {
            {
                name = "Negotiation",
                level = 2,
                description = "Improve negotiation skills.",
                effect = function(player)
                    local negotiation = player:GetAttribute("Negotiation") or 0
                    player:SetAttribute("Negotiation", negotiation + 1)
                end
            }
        }
    }
    table.insert(self.skillTrees, socialTree)
end

-- Unlock a skill
function Progression:UnlockSkill(skillName, skillTreeName)
    for _, tree in ipairs(self.skillTrees) do
        if tree.name == skillTreeName then
            for _, skill in ipairs(tree.lockedSkills) do
                if skill.name == skillName then
                    if self.skillPoints > 0 then
                        table.insert(tree.unlockedSkills, skill)
                        table.removeValue(tree.lockedSkills, skill)
                        self.skillPoints = self.skillPoints - 1
                        
                        -- Apply skill effect
                        if skill.effect then
                            skill.effect(game.Players:GetPlayerFromCharacter(playerCharacter))
                        end
                        
                        return true
                    else
                        return false, "Not enough skill points."
                    end
                end
            end
            return false, "Skill not found in this tree."
        end
    end
    return false, "Skill tree not found."
end

-- Get current level
function Progression:GetLevel()
    return self.level
end

-- Get current XP
function Progression:GetXP()
    return self.xp
end

-- Get XP to next level
function Progression:GetXPToNextLevel()
    return self.xpToNextLevel
end

-- Get skill points
function Progression:GetSkillPoints()
    return self.skillPoints
end

-- Get skill trees
function Progression:GetSkillTrees()
    return self.skillTrees
end

-- Get stats
function Progression:GetStats()
    return self.stats
end

-- Get skill tree by name
function Progression:GetSkillTree(name)
    for _, tree in ipairs(self.skillTrees) do
        if tree.name == name then
            return tree
        end
    end
    return nil
end

-- Get unlocked skills in a skill tree
function Progression:GetUnlockedSkills(skillTreeName)
    for _, tree in ipairs(self.skillTrees) do
        if tree.name == skillTreeName then
            return tree.unlockedSkills
        end
    end
    return nil
end

-- Get locked skills in a skill tree
function Progression:GetLockedSkills(skillTreeName)
    for _, tree in ipairs(self.skillTrees) do
        if tree.name == skillTreeName then
            return tree.lockedSkills
        end
    end
    return nil
end

return Progression