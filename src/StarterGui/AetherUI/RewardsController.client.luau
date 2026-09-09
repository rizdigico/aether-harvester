--!strict
-- RewardsController: makes the daily calendar and extra reward grants usable.
-- Claim eligibility and reward mutation are decided by the server.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local rewardsData = require(shared:WaitForChild("Data"):WaitForChild("Rewards"))
local toast = require(script.Parent.Components.Toast)

local screen = screens:FindFirstChild("RewardsScreen")
if not screen then
    return nil
end

local mainFrame = screen:FindFirstChild("MainFrame")
local rewardsList = mainFrame and mainFrame:FindFirstChild("RewardsList")
if not mainFrame or not mainFrame:IsA("Frame") or not rewardsList or not rewardsList:IsA("ScrollingFrame") then
    return nil
end

local dynamicRows: { GuiObject } = {}
local uiConnections: { RBXScriptConnection } = {}
local toastHost: any = nil

local function showToast(message: string, kind: any)
    if toastHost then
        toastHost.Queue({ Text = message, Type = kind })
    else
        toastHost = toast.enqueue(screen, { Text = message, Type = kind })
    end
end

local function clearRows()
    for _, row in ipairs(dynamicRows) do
        row:Destroy()
    end
    table.clear(dynamicRows)
end

local function makeLabel(parent: Instance, name: string, position: UDim2, size: UDim2): TextLabel
    local label = Instance.new("TextLabel")
    label.Name = name
    label.BackgroundTransparency = 1
    label.Position = position
    label.Size = size
    label.TextColor3 = Color3.fromRGB(230, 235, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

local function makeButton(parent: Instance, name: string, position: UDim2, size: UDim2, text: string): TextButton
    local button = Instance.new("TextButton")
    button.Name = name
    button.BackgroundColor3 = Color3.fromRGB(47, 54, 77)
    button.BorderSizePixel = 0
    button.Position = position
    button.Size = size
    button.Text = text
    button.TextColor3 = Color3.fromRGB(230, 235, 245)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 12
    button.Parent = parent
    return button
end

local function ensureStatus(): TextLabel
    local existing = mainFrame:FindFirstChild("RewardStatus")
    if existing and existing:IsA("TextLabel") then
        return existing
    end
    return makeLabel(mainFrame, "RewardStatus", UDim2.new(0.04, 0, 0.81, 0), UDim2.new(0.58, 0, 0.08, 0))
end

local function ensureDailyButton(): TextButton
    local existing = mainFrame:FindFirstChild("ClaimDailyButton")
    if existing and existing:IsA("TextButton") then
        return existing
    end
    return makeButton(
        mainFrame,
        "ClaimDailyButton",
        UDim2.new(0.64, 0, 0.805, 0),
        UDim2.new(0.31, 0, 0.085, 0),
        "CLAIM DAILY"
    )
end

local function getPlayerData(): any
    local getPlayerData = remotes:FindFirstChild("GetPlayerData")
    if not getPlayerData or not getPlayerData:IsA("RemoteFunction") then
        return {}
    end
    local ok, data = pcall(function()
        return getPlayerData:InvokeServer()
    end)
    return if ok and type(data) == "table" then data else {}
end

local function rewardText(reward: any): string
    if type(reward) ~= "table" then
        return "No reward configured"
    end
    local parts: { string } = {}
    if type(reward.Currency) == "number" then
        table.insert(parts, tostring(reward.Currency) .. " Aether Shards")
    end
    if type(reward.XP) == "number" then
        table.insert(parts, tostring(reward.XP) .. " XP")
    end
    if type(reward.Item) == "string" then
        table.insert(parts, tostring(reward.Amount or 1) .. " × " .. reward.Item)
    end
    if type(reward.Bonus) == "string" then
        table.insert(parts, reward.Bonus)
    end
    return #parts > 0 and table.concat(parts, "  •  ") or "No reward configured"
end

local function render()
    clearRows()
    rewardsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local empty = rewardsList:FindFirstChild("EmptyState")
    if empty and empty:IsA("TextLabel") then
        empty.Visible = false
    end

    local data = getPlayerData()
    local streak = math.max(0, math.floor(tonumber(data.DailyStreak) or 0))
    local nextDay = (streak % 30) + 1
    local currentDayIndex = math.floor(os.time() / 86400)
    local lastClaimDay = tonumber(data.LastDailyRewardDay)
    local canClaim = lastClaimDay ~= currentDayIndex

    local status = ensureStatus()
    status.Text = string.format(
        "Daily streak: %d   •   Next calendar day: %d   •   %s",
        streak,
        nextDay,
        canClaim and "Ready to claim" or "Claimed today"
    )
    local dailyButton = ensureDailyButton()
    dailyButton.Text = canClaim and "CLAIM DAILY" or "CLAIMED TODAY"
    dailyButton.AutoButtonColor = canClaim
    dailyButton.Active = canClaim
    uiConnections[#uiConnections + 1] = dailyButton.MouseButton1Click:Connect(function()
        local claim = remotes:FindFirstChild("ClaimDailyReward")
        if claim and claim:IsA("RemoteEvent") and canClaim then
            claim:FireServer()
        end
    end)

    for day = 1, 30 do
        local reward = rewardsData.GetDailyReward(day)
        local row = makeLabel(rewardsList, "Day_" .. tostring(day), UDim2.new(), UDim2.new(1, -8, 0, 32))
        row.LayoutOrder = day
        row.BackgroundTransparency = 0
        row.BackgroundColor3 = day == nextDay and Color3.fromRGB(54, 91, 128) or Color3.fromRGB(33, 37, 54)
        row.Text = string.format("  DAY %02d%s    %s", day, day == nextDay and "  ◀ NEXT" or "", rewardText(reward))
        table.insert(dynamicRows, row)
    end

    local claimedRewards = type(data.ClaimedRewards) == "table" and data.ClaimedRewards or {}
    for rewardId, reward in pairs(rewardsData.GetAllExtraRewards()) do
        local row = makeLabel(rewardsList, "Extra_" .. rewardId, UDim2.new(), UDim2.new(1, -8, 0, 40))
        row.LayoutOrder = 100 + #dynamicRows
        row.BackgroundTransparency = 0
        row.BackgroundColor3 = Color3.fromRGB(47, 54, 77)
        row.Text = string.format("  %s    %s", reward.Name or rewardId, rewardText(reward.Rewards))
        table.insert(dynamicRows, row)
        if not claimedRewards[rewardId] then
            local claim = makeButton(
                rewardsList,
                "Claim_" .. rewardId,
                UDim2.new(0.78, 0, 0, 4),
                UDim2.new(0.2, -8, 0, 32),
                "CLAIM"
            )
            claim.LayoutOrder = row.LayoutOrder
            table.insert(dynamicRows, claim)
            uiConnections[#uiConnections + 1] = claim.MouseButton1Click:Connect(function()
                local claimRemote = remotes:FindFirstChild("ClaimReward")
                if claimRemote and claimRemote:IsA("RemoteEvent") then
                    claimRemote:FireServer(rewardId)
                end
            end)
        end
    end
end

local function refresh()
    for _, connection in ipairs(uiConnections) do
        connection:Disconnect()
    end
    table.clear(uiConnections)
    if screen.Enabled then
        render()
    end
end

screen:GetPropertyChangedSignal("Enabled"):Connect(refresh)

local dailyClaimed = remotes:FindFirstChild("DailyRewardClaimed")
if dailyClaimed and dailyClaimed:IsA("RemoteEvent") then
    dailyClaimed.OnClientEvent:Connect(function(_, reward)
        showToast("Daily reward claimed: " .. rewardText(reward), "success")
        refresh()
    end)
end
local rewardClaimed = remotes:FindFirstChild("RewardClaimed")
if rewardClaimed and rewardClaimed:IsA("RemoteEvent") then
    rewardClaimed.OnClientEvent:Connect(function(rewardId)
        showToast("Reward claimed: " .. tostring(rewardId), "success")
        refresh()
    end)
end
local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        showToast(tostring(message), "error")
    end)
end

if screen.Enabled then
    render()
end

print("[RewardsController] Initialized")
