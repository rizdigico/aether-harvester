-- Aether Harvester Simulator - Server Main
-- Initializes all game services

local ServerMain = {}
local RateLimiter = require(game.ServerScriptService.AetherServer.Security.RateLimiter)

local Services = {}

function ServerMain.Initialize()
    print("[ServerMain] Initializing Aether Harvester Simulator...")

    -- Initialize services in dependency order
    Services.WorldManager = require(game.ServerScriptService.AetherServer.GameServices.WorldManager)
    Services.NodeManager = require(game.ServerScriptService.AetherServer.GameServices.NodeManager)
    Services.PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)
    Services.QuestService = require(game.ServerScriptService.AetherServer.GameServices.QuestService)
    Services.CreatureService = require(game.ServerScriptService.AetherServer.GameServices.CreatureService)
    Services.EconomyService = require(game.ServerScriptService.AetherServer.GameServices.EconomyService)
    Services.PetService = require(game.ServerScriptService.AetherServer.GameServices.PetService)
    Services.AchievementService = require(game.ServerScriptService.AetherServer.GameServices.AchievementService)
    Services.UpgradeService = require(game.ServerScriptService.AetherServer.GameServices.UpgradeService)
    Services.TradingService = require(game.ServerScriptService.AetherServer.GameServices.TradingService)
    Services.GuildService = require(game.ServerScriptService.AetherServer.GameServices.GuildService)
    Services.PartyService = require(game.ServerScriptService.AetherServer.GameServices.PartyService)
    Services.EventService = require(game.ServerScriptService.AetherServer.GameServices.EventService)
    Services.CraftingService = require(game.ServerScriptService.AetherServer.GameServices.CraftingService)
    Services.DailyRewardsService = require(game.ServerScriptService.AetherServer.GameServices.DailyRewardsService)
    Services.MailService = require(game.ServerScriptService.AetherServer.GameServices.MailService)
    Services.ChatService = require(game.ServerScriptService.AetherServer.GameServices.ChatService)
    Services.AnalyticsService = require(game.ServerScriptService.AetherServer.GameServices.AnalyticsService)
    Services.AntiCheatService = require(game.ServerScriptService.AetherServer.GameServices.AntiCheatService)
    Services.CosmeticService = require(game.ServerScriptService.AetherServer.GameServices.CosmeticService)
    Services.BattlePassService = require(game.ServerScriptService.AetherServer.GameServices.BattlePassService)
    Services.MarketplaceService = require(game.ServerScriptService.AetherServer.GameServices.MarketplaceService)
    Services.MonetizationService = require(game.ServerScriptService.AetherServer.GameServices.MonetizationService)
    Services.LeaderboardService = require(game.ServerScriptService.AetherServer.GameServices.LeaderboardService)
    Services.ProgressionService = require(game.ServerScriptService.AetherServer.GameServices.ProgressionService)
    Services.RewardService = require(game.ServerScriptService.AetherServer.GameServices.RewardService)
    Services.PrestigeService = require(game.ServerScriptService.AetherServer.GameServices.PrestigeService)

    -- Wire cross-cutting XP listeners only after all modules have loaded.
    -- This preserves one-way module dependencies while keeping progression
    -- and battle-pass rewards in sync.
    Services.ProgressionService.SetBattlePassAwarder(function(player, amount)
        return Services.BattlePassService.AddXP(player, amount)
    end)
    Services.BattlePassService.SetProgressionGrant(function(player, amount)
        return Services.ProgressionService.AddXPWithoutBattlePass(player, amount)
    end)

    -- Initialize each service
    for _, service in pairs(Services) do
        if service.Initialize then
            service.Initialize()
        end
    end

    -- Setup player joining
    game.Players.PlayerAdded:Connect(function(player)
        Services.PlayerDataService.OnPlayerAdded(player)
        Services.MonetizationService.OnPlayerAdded(player)
        Services.QuestService.OnPlayerAdded(player)
        Services.AchievementService.CheckAllAchievements(player)
        Services.LeaderboardService.UpdateAll(player)
    end)

    -- Process players already in the game (Studio play mode, script reloads)
    for _, player in ipairs(game.Players:GetPlayers()) do
        Services.PlayerDataService.OnPlayerAdded(player)
        Services.MonetizationService.OnPlayerAdded(player)
        Services.QuestService.OnPlayerAdded(player)
        Services.AchievementService.CheckAllAchievements(player)
        Services.LeaderboardService.UpdateAll(player)
    end

    -- Setup player leaving
    game.Players.PlayerRemoving:Connect(function(player)
        Services.PartyService.OnPlayerRemoving(player)
        Services.MarketplaceService.OnPlayerRemoving(player)
        Services.LeaderboardService.RemovePlayer(player)
        Services.PetService.OnPlayerRemoving(player)
        Services.QuestService.OnPlayerRemoving(player)
        Services.PlayerDataService.OnPlayerRemoving(player)
        Services.AntiCheatService.ClearViolations(player.UserId)
        RateLimiter.Cleanup(player)
    end)

    print("[ServerMain] Server initialized successfully!")
end

function ServerMain.GetService(serviceName)
    return Services[serviceName]
end

return ServerMain
