-- CreatureService
local CreatureService = {}

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
local QuestService = require(game.ServerScriptService.AetherServer.GameServices.QuestService)
local CreaturesData = require(game.ReplicatedStorage.AetherShared.Data.Creatures)

local AetherWorld = Workspace:FindFirstChild("AetherWorld")
local CreaturesFolder = AetherWorld and AetherWorld:FindFirstChild("Creatures")

local creatureState = {} -- creature -> {health, maxHealth, aggroTarget}

function CreatureService.GetAllCreatures()
    local creatures = {}
    if not CreaturesFolder then
        return creatures
    end
    for _, child in ipairs(CreaturesFolder:GetChildren()) do
        table.insert(creatures, child)
    end
    return creatures
end

function CreatureService.GetCreatureDef(creature)
    if not creature then
        return nil
    end
    local id = creature:GetAttribute("CreatureId")
    if id then
        return CreaturesData.Get(id)
    end
    return nil
end

function CreatureService.GetCreatureHealth(creature)
    local state = creatureState[creature]
    if not state then
        return nil
    end
    return state.health
end

function CreatureService.DamageCreature(creature, amount, player)
    local state = creatureState[creature]
    if not state then
        return false
    end

    state.health -= amount

    if state.health <= 0 then
        CreatureService.OnCreatureDefeated(creature, player)
        return true, "Defeated"
    end

    -- Aggro on player if creature is aggressive
    if state.def.Aggressive and player then
        state.aggroTarget = player
    end

    return true, "Hit"
end

function CreatureService.TameCreature(creature, player)
    local def = CreatureService.GetCreatureDef(creature)
    if not def then
        return false, "Unknown creature"
    end
    if not def.Tameable then
        return false, "This creature cannot be tamed"
    end

    local state = creatureState[creature]
    if not state then
        return false, "Creature not active"
    end

    -- Check player level requirement
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "No player data"
    end
    if (data.Level or 1) < (def.Level or 1) then
        return false, "Level " .. def.Level .. " required to tame"
    end

    -- Success - add to pet inventory
    PlayerDataService.AddPet(player, def.Id)

    -- Update quests
    if QuestService.UpdateProgress then
        QuestService.UpdateProgress(player, "Tame", def.Id, 1)
    end

    -- Grant XP
    ProgressionService.AddXP(player, math.floor(def.Level * 20))

    -- Remove creature from world
    creatureState[creature] = nil
    creature:Destroy()

    -- Notify client
    local Remotes = ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local PetSummon = Remotes:FindFirstChild("PetSummon")
        if PetSummon then
            PetSummon:FireClient(player, def.Id)
        end
    end

    return true, "Tamed!"
end

function CreatureService.OnCreatureDefeated(creature, player)
    local def = CreatureService.GetCreatureDef(creature)
    if not def then
        return
    end

    creatureState[creature] = nil
    creature:Destroy()

    if not player then
        return
    end

    -- Grant loot
    for _, lootId in ipairs(def.Loot or {}) do
        PlayerDataService.AddItem(player, lootId, 1)
    end

    -- Grant XP
    ProgressionService.AddXP(player, math.floor(def.Level * 15))

    -- Track stats
    PlayerDataService.IncrementStat(player, "CombatKills", 1)

    -- Update quests
    if QuestService.UpdateProgress then
        QuestService.UpdateProgress(player, "Defeat", def.Id, 1)
        QuestService.UpdateProgress(player, "DefeatRarity", def.Rarity, 1)
    end

    -- Notify client
    local Remotes = ReplicatedStorage.AetherShared.Remotes
    if Remotes then
        local NodeHarvested = Remotes:FindFirstChild("NodeHarvested")
        if NodeHarvested then
            local loot = {}
            for _, lootId in ipairs(def.Loot or {}) do
                loot[lootId] = 1
            end
            NodeHarvested:FireClient(player, creature.Name, loot)
        end
    end
end

function CreatureService.Initialize()
    print("[CreatureService] Initializing...")

    local Remotes = ReplicatedStorage.AetherShared.Remotes

    -- Setup creature states
    local count = 0
    if CreaturesFolder then
        for _, creature in ipairs(CreaturesFolder:GetChildren()) do
            local def = CreatureService.GetCreatureDef(creature)
            if def then
                creatureState[creature] = {
                    health = def.Health,
                    maxHealth = def.Health,
                    def = def,
                    aggroTarget = nil,
                }
                count += 1
            end
        end
    end
    print("[CreatureService] Active creatures: " .. count)

    -- TameCreature remote: tame a creature by reference
    local TameCreatureRemote = Remotes and Remotes:FindFirstChild("TameCreature")
    if TameCreatureRemote then
        TameCreatureRemote.OnServerEvent:Connect(function(player, creature)
            if not creature or not creature.Parent then
                local ErrorRemote = Remotes:FindFirstChild("Error")
                if ErrorRemote then
                    ErrorRemote:FireClient(player, "Creature not found")
                end
                return
            end
            local success, result = CreatureService.TameCreature(creature, player)
            if not success then
                local ErrorRemote = Remotes:FindFirstChild("Error")
                if ErrorRemote then
                    ErrorRemote:FireClient(player, result)
                end
            end
        end)
    end

    -- DamageCreature remote: hit a creature (combat)
    local DamageRemote = Remotes and Remotes:FindFirstChild("DamageCreature")
    if not DamageRemote then
        -- create if missing so combat works
        DamageRemote = Instance.new("RemoteEvent")
        DamageRemote.Name = "DamageCreature"
        DamageRemote.Parent = Remotes
    end
    DamageRemote.OnServerEvent:Connect(function(player, creature)
        if not creature or not creature.Parent then
            return
        end
        CreatureService.DamageCreature(creature, 10, player)
    end)

    -- Aggro check loop
    RunService.Heartbeat:Connect(function()
        for creature, state in pairs(creatureState) do
            if not creature or not creature.Parent then
                creatureState[creature] = nil
            elseif state.aggroTarget and state.def.Aggressive then
                -- Chase aggro target (simple: check distance)
                local target = state.aggroTarget
                if not target.Parent or not target.Character then
                    state.aggroTarget = nil
                else
                    local root = target.Character:FindFirstChild("HumanoidRootPart")
                    local creatureRoot = creature:FindFirstChild("HumanoidRootPart") or creature:GetPivot()
                    if root and creatureRoot then
                        local dist = (
                            root.Position
                            - (typeof(creatureRoot) == "CFrame" and creatureRoot.Position or creatureRoot.Position)
                        ).Magnitude
                        if dist > 40 then
                            state.aggroTarget = nil
                        elseif dist < 8 then
                            -- Attack
                            local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:TakeDamage(state.def.Damage)
                            end
                        end
                    end
                end
            end
        end
    end)

    print("[CreatureService] Initialized with creature AI")
end

return CreatureService
