--!strict
-- Server-authoritative prestige/rebirth flow.

local PrestigeService = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)
local AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
local PrestigeMath = require(ReplicatedStorage.AetherShared.Modules.PrestigeMath)

local function clone(value: any): any
    if type(value) ~= "table" then
        return value
    end
    local copy = {}
    for key, nested in pairs(value) do
        copy[key] = clone(nested)
    end
    return copy
end

local function getRemotes(): Folder?
    local shared = ReplicatedStorage:FindFirstChild("AetherShared")
    return shared and shared:FindFirstChild("Remotes") :: Folder?
end

local function fireError(player: Player, message: string)
    local remotes = getRemotes()
    local errorRemote = remotes and remotes:FindFirstChild("Error")
    if errorRemote and errorRemote:IsA("RemoteEvent") then
        errorRemote:FireClient(player, message)
    end
end

function PrestigeService.GetSnapshot(player: Player): { [string]: any }
    local data = PlayerDataService.GetData(player)
    if not data then
        return {}
    end

    local prestigeLevel = PrestigeMath.NormalizeLevel(data.PrestigeLevel)
    local currentLevel = type(data.Level) == "number" and math.max(1, math.floor(data.Level)) or 1
    local canPrestige, reason = PrestigeMath.CanPrestige(currentLevel, prestigeLevel)
    return {
        PrestigeLevel = prestigeLevel,
        MaxPrestige = PrestigeMath.MAX_PRESTIGE,
        CurrentLevel = currentLevel,
        RequiredLevel = PrestigeMath.REQUIRED_LEVEL,
        CanPrestige = canPrestige,
        Reason = reason,
        XPBonusPercent = math.floor((PrestigeMath.GetXPMultiplier(prestigeLevel) - 1) * 100 + 0.5),
        NextXPBonusPercent = math.floor(
            (PrestigeMath.GetXPMultiplier(PrestigeMath.GetNextLevel(prestigeLevel)) - 1) * 100 + 0.5
        ),
        Keeps = { "Pets", "Cosmetics", "Achievements", "Gems", "Entitlements", "Guild" },
        Resets = { "Level", "Skills", "Upgrades", "Inventory", "SoftCurrency", "TemporaryBoosts" },
    }
end

function PrestigeService.Prestige(player: Player): (boolean, string)
    local data = PlayerDataService.GetData(player)
    if not data then
        return false, "Player data not found"
    end

    local canPrestige, reason = PrestigeMath.CanPrestige(data.Level, data.PrestigeLevel)
    if not canPrestige then
        return false, reason
    end

    local backup = clone(data)
    local oldGems = type(data.Currency) == "table" and data.Currency.AetherGems or 0
    local nextPrestige = PrestigeMath.GetNextLevel(data.PrestigeLevel)

    data.Level = 1
    data.XP = 0
    data.Currency = {
        AetherShards = 0,
        AetherGems = type(oldGems) == "number" and math.max(0, oldGems) or 0,
        EventTokens = 0,
        FamePoints = 0,
    }
    data.Inventory = {}
    data.Upgrades = {}
    data.Skills = {}
    data.SkillPoints = 0
    data.Quests = {}
    data.Boosts = {}
    data.PrestigeLevel = nextPrestige

    -- A failed save must leave both the in-memory profile and the receipt-safe
    -- persisted state unchanged, so the user can retry without data loss.
    if not PlayerDataService.SaveNow(player) then
        for key in pairs(data) do
            data[key] = nil
        end
        for key, value in pairs(backup) do
            data[key] = value
        end
        return false, "Prestige save failed; nothing was reset"
    end

    local remotes = getRemotes()
    local completed = remotes and remotes:FindFirstChild("PrestigeCompleted")
    if completed and completed:IsA("RemoteEvent") then
        completed:FireClient(player, PrestigeService.GetSnapshot(player))
    end
    return true, "Ascension complete"
end

function PrestigeService.Initialize()
    print("[PrestigeService] Initializing...")
    local remotes = getRemotes()
    if not remotes then
        return
    end

    local getPrestige = remotes:FindFirstChild("GetPrestige")
    if getPrestige and getPrestige:IsA("RemoteFunction") then
        getPrestige.OnServerInvoke = function(player: Player)
            if not RateLimiter.Check(player, "GetPrestige", 0.5) then
                return {}
            end
            return PrestigeService.GetSnapshot(player)
        end
    end

    local requestPrestige = remotes:FindFirstChild("RequestPrestige")
    if requestPrestige and requestPrestige:IsA("RemoteEvent") then
        requestPrestige.OnServerEvent:Connect(function(player: Player)
            if not RateLimiter.Check(player, "RequestPrestige", 2) then
                return
            end
            AntiCheatService:CheckPlayer(player)
            local success, message = PrestigeService.Prestige(player)
            if not success then
                fireError(player, message)
            end
        end)
    end

    print("[PrestigeService] Initialized")
end

return PrestigeService
