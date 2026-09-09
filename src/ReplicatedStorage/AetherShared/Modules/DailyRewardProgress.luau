--!strict
-- Pure daily-claim calendar logic. The server supplies the current timestamp
-- and persists the resulting day index; no client-provided date is trusted.

local DailyRewardProgress = {}

local DAY_SECONDS = 86400

export type ClaimDecision = {
    canClaim: boolean,
    dayIndex: number,
    streak: number,
    reason: string?,
}

function DailyRewardProgress.GetDayIndex(timestamp: number): number
    return math.floor(timestamp / DAY_SECONDS)
end

function DailyRewardProgress.GetDayKey(timestamp: number): string
    return os.date("!%Y-%m-%d", timestamp)
end

function DailyRewardProgress.ResolveClaim(
    lastClaimDay: number?,
    currentStreak: number?,
    timestamp: number
): ClaimDecision
    local dayIndex = DailyRewardProgress.GetDayIndex(timestamp)
    if lastClaimDay == dayIndex then
        return {
            canClaim = false,
            dayIndex = dayIndex,
            streak = math.max(0, math.floor(currentStreak or 0)),
            reason = "already_claimed",
        }
    end

    local streak = math.max(0, math.floor(currentStreak or 0))
    if lastClaimDay and dayIndex == lastClaimDay + 1 then
        streak = math.max(streak, 1) + 1
    else
        streak = 1
    end

    return {
        canClaim = true,
        dayIndex = dayIndex,
        streak = streak,
    }
end

function DailyRewardProgress.GetRewardDay(streak: number, cycleLength: number): number
    if cycleLength < 1 then
        return 1
    end
    return ((math.max(1, math.floor(streak)) - 1) % math.floor(cycleLength)) + 1
end

return DailyRewardProgress
