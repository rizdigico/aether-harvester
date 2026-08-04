local AntiCheatService = {}
local PlayerDataService = require(game.ServerScriptService.AetherServer.GameServices.PlayerDataService)

AntiCheatService.Violations = {}
AntiCheatService.MaxViolations = 5

function AntiCheatService.Initialize()
    print("[AntiCheatService] Initializing...")
end

function AntiCheatService:CheckPlayer(player)
    local data = PlayerDataService.GetData(player)
    if not data then
        return
    end

    -- Check for impossible values
    if data.Level and data.Level > 1000 then
        self:FlagPlayer(player, "impossible_level")
    end

    if data.Currency and data.Currency.AetherShards and data.Currency.AetherShards > 10000000 then
        self:FlagPlayer(player, "impossible_currency")
    end

    -- Check for rapid actions
    local now = os.time()
    if not data.LastActionTime then
        data.LastActionTime = now
        data.ActionCount = 0
    else
        if now - data.LastActionTime < 1 then
            data.ActionCount += 1
            if data.ActionCount > 100 then
                self:FlagPlayer(player, "rapid_actions")
            end
        else
            data.ActionCount = 0
        end
        data.LastActionTime = now
    end
end

function AntiCheatService:FlagPlayer(player, reason)
    if not AntiCheatService.Violations[player.UserId] then
        AntiCheatService.Violations[player.UserId] = {}
    end

    table.insert(AntiCheatService.Violations[player.UserId], {
        Reason = reason,
        Timestamp = os.time(),
    })

    print("[AntiCheat] Flagged " .. player.Name .. " for " .. reason)

    -- Check if player should be banned
    local violations = AntiCheatService.Violations[player.UserId]
    if #violations >= AntiCheatService.MaxViolations then
        -- Ban player
        player:Kick("Cheating detected")
        print("[AntiCheat] Banned " .. player.Name)
    end
end

function AntiCheatService.GetViolations(playerId)
    return AntiCheatService.Violations[playerId] or {}
end

function AntiCheatService.ClearViolations(playerId)
    AntiCheatService.Violations[playerId] = nil
end

return AntiCheatService
