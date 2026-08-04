--!strict
-- RateLimiter: generic per-player per-action cooldown tracker (server-side).
-- RateLimiter.Check(player, action, windowSeconds) -> boolean (true = allowed)
-- Entries auto-clean: each action stores a single last-fired timestamp that is
-- overwritten on every Check, so memory is bounded by (#active players x #actions).
-- Call Cleanup(player) when a player leaves to release their state eagerly.

local RateLimiter = {}

-- player.UserId -> action -> last allowed os.clock() timestamp
local lastFired: { [number]: { [string]: number } } = {}

local DEFAULT_WINDOW = 1

-- Returns true if the action is allowed within the given window, false otherwise.
-- On success, records the current time so subsequent calls within the window are blocked.
function RateLimiter.Check(player: Player, action: string, windowSeconds: number?): boolean
    local userId: number = player.UserId
    local window: number = windowSeconds or DEFAULT_WINDOW

    local actions = lastFired[userId]
    if not actions then
        actions = {}
        lastFired[userId] = actions
    end

    local now: number = os.clock()
    local last: number? = actions[action]

    if last and (now - last) < window then
        return false
    end

    actions[action] = now
    return true
end

-- Releases a leaving player's rate-limit state eagerly.
function RateLimiter.Cleanup(player: Player)
    lastFired[player.UserId] = nil
end

-- Prunes any player entry whose action map is empty (players that left before
-- Cleanup ran). Bounded, cheap to call periodically.
function RateLimiter.CleanupAll()
    for userId, actions in pairs(lastFired) do
        if next(actions) == nil then
            lastFired[userId] = nil
        end
    end
end

return RateLimiter
