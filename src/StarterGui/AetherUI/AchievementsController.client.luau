--!strict
-- AchievementsController: renders server-computed achievement state and rewards.

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
local cards: { GuiObject } = {}
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
    result.AutoButtonColor = true
    result.Parent = parent
    round(result, 6)
    outline(result, COLORS.Cyan, 0.78)
    return result
end

local function makeScreen(): (ScreenGui, Frame, TextLabel, ScrollingFrame)
    local existing = screens:FindFirstChild("AchievementsScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "AchievementsScreen"
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
    createdPanel.Size = UDim2.fromScale(0.78, 0.82)
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
    local title = label(titleBar, "Title", "AETHER ACHIEVEMENTS", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = label(titleBar, "Subtitle", "Milestones tracked and rewarded by the server", 12, COLORS.Muted)
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

    local createdStatus = label(createdPanel, "Status", "Loading achievements…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 20, 0, 72)
    createdStatus.Size = UDim2.new(1, -40, 0, 25)

    local createdList = Instance.new("ScrollingFrame")
    createdList.Name = "AchievementList"
    createdList.Position = UDim2.new(0, 20, 0, 105)
    createdList.Size = UDim2.new(1, -40, 1, -125)
    createdList.BackgroundTransparency = 1
    createdList.BorderSizePixel = 0
    createdList.ScrollBarThickness = 5
    createdList.ScrollBarImageColor3 = COLORS.Cyan
    createdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdList.CanvasSize = UDim2.new()
    createdList.Parent = createdPanel
    local layout = Instance.new("UIListLayout")
    layout.Name = "AchievementLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdList

    return createdScreen, createdPanel, createdStatus, createdList
end

local _panel: Frame
screen, _panel, status, list = makeScreen()

local function clearCards()
    for _, card in ipairs(cards) do
        card:Destroy()
    end
    table.clear(cards)
end

local function rewardText(reward: any): string
    if type(reward) ~= "table" then
        return "No reward"
    end
    local parts: { string } = {}
    if type(reward.Currency) == "number" and reward.Currency > 0 then
        table.insert(parts, tostring(reward.Currency) .. " shards")
    end
    if type(reward.XP) == "number" and reward.XP > 0 then
        table.insert(parts, tostring(reward.XP) .. " XP")
    end
    if type(reward.Item) == "string" then
        table.insert(parts, reward.Item)
    end
    return #parts > 0 and table.concat(parts, "  •  ") or "No reward"
end

local function addEmpty(message: string)
    local empty = label(list, "EmptyState", message, 15, COLORS.Muted)
    empty.Size = UDim2.new(1, -8, 0, 60)
    empty.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(cards, empty)
end

local function addAchievement(achievement: any, order: number)
    if type(achievement) ~= "table" or type(achievement.Id) ~= "string" then
        return
    end
    local unlocked = tonumber(achievement.Progress) == 1
    local card = Instance.new("Frame")
    card.Name = "Achievement_" .. achievement.Id
    card.Size = UDim2.new(1, -8, 0, 82)
    card.BackgroundColor3 = unlocked and Color3.fromRGB(43, 75, 65) or COLORS.Raised
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = list
    round(card, 7)
    outline(card, unlocked and COLORS.Green or COLORS.Cyan, 0.78)
    local title = label(
        card,
        "Title",
        tostring(achievement.Title or achievement.Id),
        15,
        unlocked and COLORS.Green or COLORS.Text
    )
    title.Position = UDim2.new(0, 14, 0, 8)
    title.Size = UDim2.new(0.52, 0, 0, 22)
    title.Font = Enum.Font.GothamBold
    local description = label(card, "Description", tostring(achievement.Description or ""), 11, COLORS.Muted)
    description.Position = UDim2.new(0, 14, 0, 33)
    description.Size = UDim2.new(0.52, 0, 0, 38)
    description.TextYAlignment = Enum.TextYAlignment.Top
    local meta = label(
        card,
        "Meta",
        string.format(
            "%s  •  %s  •  %s",
            tostring(achievement.Category or "General"),
            tostring(achievement.Tier or "Milestone"),
            rewardText(achievement.Reward)
        ),
        11,
        COLORS.Gold
    )
    meta.Position = UDim2.new(0.57, 0, 0, 9)
    meta.Size = UDim2.new(0.39, -8, 0, 34)
    meta.TextXAlignment = Enum.TextXAlignment.Right
    local state =
        label(card, "State", unlocked and "UNLOCKED" or "LOCKED", 12, unlocked and COLORS.Green or COLORS.Muted)
    state.Position = UDim2.new(0.57, 0, 0, 48)
    state.Size = UDim2.new(0.39, -8, 0, 20)
    state.TextXAlignment = Enum.TextXAlignment.Right
    table.insert(cards, card)
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    clearCards()
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server achievements…"
    local remote = remotes:FindFirstChild("GetAchievements")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Achievements unavailable: endpoint is missing."
        addEmpty("No achievement action is available in this state.")
        refreshInFlight = false
        return
    end
    local ok, result = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok or type(result) ~= "table" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Achievements unavailable: server snapshot failed."
        addEmpty("Try again in a moment.")
        refreshInFlight = false
        return
    end
    local unlocked = 0
    for _, achievement in ipairs(result) do
        if type(achievement) == "table" and tonumber(achievement.Progress) == 1 then
            unlocked += 1
        end
    end
    status.TextColor3 = COLORS.Cyan
    status.Text = string.format("%d/%d unlocked  •  rewards are granted server-side", unlocked, #result)
    if #result == 0 then
        addEmpty("No achievements are configured yet.")
    else
        for index, achievement in ipairs(result) do
            addAchievement(achievement, index)
        end
    end
    refreshInFlight = false
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavAchievements")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavAchievements", "ACHIEVEMENTS", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 14
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

local unlockedRemote = remotes:FindFirstChild("AchievementUnlocked")
if unlockedRemote and unlockedRemote:IsA("RemoteEvent") then
    unlockedRemote.OnClientEvent:Connect(function()
        if screen.Enabled then
            refresh()
        end
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        refresh()
    else
        clearCards()
    end
end)

wireNav()
print("[AchievementsController] Initialized")
