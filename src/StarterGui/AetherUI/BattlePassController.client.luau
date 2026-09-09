--!strict
-- BattlePassController: renders the server-owned seasonal progression snapshot.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")

local COLORS = {
    Background = Color3.fromRGB(13, 27, 42),
    Panel = Color3.fromRGB(28, 32, 48),
    Raised = Color3.fromRGB(38, 42, 62),
    Text = Color3.fromRGB(230, 235, 245),
    Muted = Color3.fromRGB(150, 162, 184),
    Cyan = Color3.fromRGB(100, 220, 255),
    Gold = Color3.fromRGB(255, 183, 77),
    Green = Color3.fromRGB(111, 220, 151),
    Danger = Color3.fromRGB(255, 132, 132),
}

local screen: ScreenGui
local status: TextLabel
local list: ScrollingFrame
local premiumButton: TextButton
local rows: { GuiObject } = {}
local refreshInFlight = false

local function round(instance: GuiObject, radius: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function outline(instance: GuiObject, color: Color3, transparency: number)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Transparency = transparency
    stroke.Thickness = 1
    stroke.Parent = instance
end

local function label(parent: Instance, name: string, text: string, size: number, color: Color3): TextLabel
    local result = Instance.new("TextLabel")
    result.Name = name
    result.BackgroundTransparency = 1
    result.Text = text
    result.TextColor3 = color
    result.Font = Enum.Font.GothamMedium
    result.TextSize = size
    result.TextWrapped = true
    result.TextXAlignment = Enum.TextXAlignment.Left
    result.TextYAlignment = Enum.TextYAlignment.Center
    result.Parent = parent
    return result
end

local function button(parent: Instance, name: string, text: string, color: Color3): TextButton
    local result = Instance.new("TextButton")
    result.Name = name
    result.BackgroundColor3 = color
    result.BorderSizePixel = 0
    result.Text = text
    result.TextColor3 = COLORS.Text
    result.Font = Enum.Font.GothamBold
    result.TextSize = 12
    result.TextWrapped = true
    result.AutoButtonColor = true
    result.Parent = parent
    round(result, 6)
    outline(result, COLORS.Cyan, 0.78)
    return result
end

local function makeScreen(): (ScreenGui, Frame, TextLabel, ScrollingFrame, TextButton)
    local existing = screens:FindFirstChild("BattlePassScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "BattlePassScreen"
    createdScreen.DisplayOrder = 20
    createdScreen.ResetOnSpawn = false
    createdScreen.Enabled = false
    createdScreen.Parent = screens

    local backdrop = Instance.new("Frame")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = COLORS.Background
    backdrop.BackgroundTransparency = 0.08
    backdrop.BorderSizePixel = 0
    backdrop.Parent = createdScreen

    local createdPanel = Instance.new("Frame")
    createdPanel.Name = "Panel"
    createdPanel.AnchorPoint = Vector2.new(0.5, 0.5)
    createdPanel.Position = UDim2.fromScale(0.5, 0.5)
    createdPanel.Size = UDim2.fromScale(0.8, 0.82)
    createdPanel.BackgroundColor3 = COLORS.Panel
    createdPanel.BorderSizePixel = 0
    createdPanel.Parent = backdrop
    round(createdPanel, 10)
    outline(createdPanel, COLORS.Cyan, 0.6)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 62)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 23, 36)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = createdPanel
    local title = label(titleBar, "Title", "AETHER PASS", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle =
        label(titleBar, "Subtitle", "Progression rewards are granted when the server levels you up", 12, COLORS.Muted)
    subtitle.Position = UDim2.new(0, 20, 0, 35)
    subtitle.Size = UDim2.new(1, -90, 0, 18)
    local close = button(titleBar, "CloseButton", "X", COLORS.Raised)
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -14, 0.5, 0)
    close.Size = UDim2.fromOffset(38, 34)
    close.TextSize = 16
    close.Activated:Connect(function()
        createdScreen.Enabled = false
    end)

    local createdStatus = label(createdPanel, "Status", "Loading Battle Pass…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 20, 0, 72)
    createdStatus.Size = UDim2.new(0.7, -20, 0, 25)
    local createdPremium = button(createdPanel, "PremiumButton", "PREMIUM · 2,000 SHARDS", Color3.fromRGB(83, 65, 35))
    createdPremium.Position = UDim2.new(0.72, 0, 0, 70)
    createdPremium.Size = UDim2.new(0.28, -20, 0, 30)

    local createdList = Instance.new("ScrollingFrame")
    createdList.Name = "RewardList"
    createdList.Position = UDim2.new(0, 20, 0, 110)
    createdList.Size = UDim2.new(1, -40, 1, -130)
    createdList.BackgroundTransparency = 1
    createdList.BorderSizePixel = 0
    createdList.ScrollBarThickness = 5
    createdList.ScrollBarImageColor3 = COLORS.Cyan
    createdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdList.CanvasSize = UDim2.new()
    createdList.Parent = createdPanel
    local layout = Instance.new("UIListLayout")
    layout.Name = "RewardLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdList
    return createdScreen, createdPanel, createdStatus, createdList, createdPremium
end

local _panel: Frame
screen, _panel, status, list, premiumButton = makeScreen()

local function clearRows()
    for _, row in ipairs(rows) do
        row:Destroy()
    end
    table.clear(rows)
end

local function rewardText(reward: any): string
    if type(reward) ~= "table" then
        return "—"
    end
    local parts: { string } = {}
    if type(reward.AetherShards) == "number" and reward.AetherShards > 0 then
        table.insert(parts, tostring(reward.AetherShards) .. " shards")
    end
    if type(reward.XP) == "number" and reward.XP > 0 then
        table.insert(parts, tostring(reward.XP) .. " XP")
    end
    if type(reward.Items) == "table" and #reward.Items > 0 then
        table.insert(parts, table.concat(reward.Items, ", "))
    end
    if type(reward.Special) == "string" then
        table.insert(parts, reward.Special)
    end
    return #parts > 0 and table.concat(parts, "  •  ") or "—"
end

local function render(snapshot: any)
    clearRows()
    local level = math.max(1, math.floor(tonumber(snapshot.Level) or 1))
    local xp = math.max(0, tonumber(snapshot.XP) or 0)
    local xpRequired = math.max(1, tonumber(snapshot.XPRequired) or 1)
    local maxLevel = math.max(level, math.floor(tonumber(snapshot.Levels) or level))
    status.TextColor3 = COLORS.Cyan
    status.Text = string.format(
        "%s  •  Level %d/%d  •  %d/%d XP  •  %s",
        tostring(snapshot.Name or "Aether Season"),
        level,
        maxLevel,
        xp,
        xpRequired,
        snapshot.Premium == true and "Premium active" or "Free track"
    )
    premiumButton.Text = snapshot.Premium == true and "PREMIUM ACTIVE" or "PREMIUM · 2,000 SHARDS"
    premiumButton.Active = snapshot.Premium ~= true
    premiumButton.AutoButtonColor = snapshot.Premium ~= true
    local rewards = type(snapshot.Rewards) == "table" and snapshot.Rewards or {}
    if #rewards == 0 then
        local empty = label(list, "EmptyState", "No reward milestones are configured.", 14, COLORS.Muted)
        empty.Size = UDim2.new(1, -8, 0, 60)
        empty.TextXAlignment = Enum.TextXAlignment.Center
        table.insert(rows, empty)
        return
    end
    for index, reward in ipairs(rewards) do
        if type(reward) == "table" then
            local rewardLevel = math.floor(tonumber(reward.Level) or 0)
            local current = rewardLevel <= level
            local row = Instance.new("Frame")
            row.Name = "Reward_" .. tostring(rewardLevel)
            row.LayoutOrder = index
            row.Size = UDim2.new(1, -8, 0, 66)
            row.BackgroundColor3 = current and Color3.fromRGB(43, 75, 65) or COLORS.Raised
            row.BorderSizePixel = 0
            row.Parent = list
            round(row, 7)
            outline(row, current and COLORS.Green or COLORS.Cyan, 0.8)
            local title = label(
                row,
                "Level",
                string.format("LEVEL %02d", rewardLevel),
                15,
                current and COLORS.Green or COLORS.Gold
            )
            title.Position = UDim2.new(0, 14, 0, 0)
            title.Size = UDim2.new(0.2, 0, 1, 0)
            title.Font = Enum.Font.GothamBold
            local free = label(row, "Free", "FREE  " .. rewardText(reward.Free), 11, COLORS.Text)
            free.Position = UDim2.new(0.22, 0, 0, 7)
            free.Size = UDim2.new(0.36, 0, 0, 24)
            local premium = label(row, "Premium", "PREMIUM  " .. rewardText(reward.Premium), 11, COLORS.Gold)
            premium.Position = UDim2.new(0.22, 0, 0, 34)
            premium.Size = UDim2.new(0.68, -8, 0, 24)
            local state =
                label(row, "State", current and "EARNED" or "LOCKED", 11, current and COLORS.Green or COLORS.Muted)
            state.Position = UDim2.new(0.78, 0, 0, 7)
            state.Size = UDim2.new(0.2, -8, 0, 24)
            state.TextXAlignment = Enum.TextXAlignment.Right
            table.insert(rows, row)
        end
    end
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server Battle Pass…"
    local remote = remotes:FindFirstChild("GetBattlePass")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Battle Pass unavailable: endpoint is missing."
        refreshInFlight = false
        return
    end
    local ok, snapshot = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok or type(snapshot) ~= "table" or snapshot.Id == nil then
        status.TextColor3 = COLORS.Danger
        status.Text = "Battle Pass unavailable: server snapshot failed."
        refreshInFlight = false
        return
    end
    render(snapshot)
    refreshInFlight = false
end

premiumButton.Activated:Connect(function()
    if not premiumButton.Active then
        return
    end
    local remote = remotes:FindFirstChild("PurchaseBattlePassPremium")
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer()
        premiumButton.Active = false
        premiumButton.Text = "PURCHASING…"
    end
end)

local purchased = remotes:FindFirstChild("BattlePassPremiumPurchased")
if purchased and purchased:IsA("RemoteEvent") then
    purchased.OnClientEvent:Connect(function()
        if screen.Enabled then
            refresh()
        end
    end)
end
local leveled = remotes:FindFirstChild("BattlePassLevelUp")
if leveled and leveled:IsA("RemoteEvent") then
    leveled.OnClientEvent:Connect(function()
        if screen.Enabled then
            refresh()
        end
    end)
end
local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        status.TextColor3 = COLORS.Danger
        status.Text = tostring(message)
        if screen.Enabled then
            task.delay(0.4, refresh)
        end
    end)
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavBattlePass")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavBattlePass", "AETHER PASS", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 15
    open.Activated:Connect(function()
        for _, sibling in ipairs(screens:GetChildren()) do
            if sibling:IsA("ScreenGui") then
                sibling.Enabled = false
            end
        end
        screen.Enabled = true
        refresh()
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        refresh()
    else
        clearRows()
    end
end)

wireNav()
print("[BattlePassController] Initialized")
