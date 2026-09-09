--!strict
-- LeaderboardController: displays the server's current in-session leaderboard.
-- Values and ordering come from the server; the client only renders the snapshot.

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

local CATEGORIES = {
    { Id = "Level", Label = "LEVEL" },
    { Id = "Wealth", Label = "WEALTH" },
    { Id = "Pets", Label = "PETS" },
    { Id = "Quests", Label = "QUESTS" },
}

local screen: ScreenGui
local status: TextLabel
local rows: ScrollingFrame
local currentCategory = "Level"
local rowInstances: { GuiObject } = {}
local categoryButtons: { [string]: TextButton } = {}
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

local function makeScreen(): (ScreenGui, Frame, TextLabel, ScrollingFrame, Frame)
    local existing = screens:FindFirstChild("LeaderboardScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "LeaderboardScreen"
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
    createdPanel.Size = UDim2.fromScale(0.72, 0.78)
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
    local title = label(titleBar, "Title", "AETHER LEADERBOARD", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = label(titleBar, "Subtitle", "Live top explorers in this server", 12, COLORS.Muted)
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

    local createdStatus = label(createdPanel, "Status", "Loading leaderboard…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 20, 0, 72)
    createdStatus.Size = UDim2.new(1, -40, 0, 25)

    local createdCategoryBar = Instance.new("Frame")
    createdCategoryBar.Name = "CategoryBar"
    createdCategoryBar.Position = UDim2.new(0, 20, 0, 105)
    createdCategoryBar.Size = UDim2.new(1, -40, 0, 36)
    createdCategoryBar.BackgroundTransparency = 1
    createdCategoryBar.Parent = createdPanel
    local categoryLayout = Instance.new("UIListLayout")
    categoryLayout.FillDirection = Enum.FillDirection.Horizontal
    categoryLayout.Padding = UDim.new(0, 6)
    categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
    categoryLayout.Parent = createdCategoryBar
    for index, entry in ipairs(CATEGORIES) do
        local categoryButton = button(createdCategoryBar, "Category_" .. entry.Id, entry.Label, COLORS.Raised)
        categoryButton.LayoutOrder = index
        categoryButton.Size = UDim2.new(0.25, -5, 1, 0)
        categoryButtons[entry.Id] = categoryButton
    end

    local createdRows = Instance.new("ScrollingFrame")
    createdRows.Name = "Rows"
    createdRows.Position = UDim2.new(0, 20, 0, 153)
    createdRows.Size = UDim2.new(1, -40, 1, -173)
    createdRows.BackgroundTransparency = 1
    createdRows.BorderSizePixel = 0
    createdRows.ScrollBarThickness = 5
    createdRows.ScrollBarImageColor3 = COLORS.Cyan
    createdRows.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdRows.CanvasSize = UDim2.new()
    createdRows.Parent = createdPanel
    local rowLayout = Instance.new("UIListLayout")
    rowLayout.Name = "RowLayout"
    rowLayout.Padding = UDim.new(0, 7)
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = createdRows

    return createdScreen, createdPanel, createdStatus, createdRows, createdCategoryBar
end

local _panel: Frame
local _categoryBar: Frame
screen, _panel, status, rows, _categoryBar = makeScreen()

local function clearRows()
    for _, row in ipairs(rowInstances) do
        row:Destroy()
    end
    table.clear(rowInstances)
end

local function render(entries: { any })
    clearRows()
    for category, categoryButton in pairs(categoryButtons) do
        categoryButton.BackgroundColor3 = category == currentCategory and Color3.fromRGB(31, 77, 91) or COLORS.Raised
    end
    if #entries == 0 then
        status.TextColor3 = COLORS.Muted
        status.Text = "No entries have been recorded in this category yet."
        local empty = label(rows, "EmptyState", "No leaderboard data", 15, COLORS.Muted)
        empty.Size = UDim2.new(1, -8, 0, 60)
        empty.TextXAlignment = Enum.TextXAlignment.Center
        table.insert(rowInstances, empty)
        return
    end

    status.TextColor3 = COLORS.Cyan
    status.Text =
        string.format("%s  •  top %d explorers  •  server snapshot", string.upper(currentCategory), #entries)
    for rank, entry in ipairs(entries) do
        local playerId = tonumber(entry.PlayerId) or 0
        local isLocal = playerId == player.UserId
        local row = Instance.new("Frame")
        row.Name = "Rank_" .. tostring(rank)
        row.LayoutOrder = rank
        row.Size = UDim2.new(1, -8, 0, 52)
        row.BackgroundColor3 = isLocal and Color3.fromRGB(43, 75, 65) or COLORS.Raised
        row.BorderSizePixel = 0
        row.Parent = rows
        round(row, 7)
        outline(row, isLocal and COLORS.Green or COLORS.Cyan, 0.8)
        local rankLabel =
            label(row, "Rank", string.format("#%02d", rank), 16, rank <= 3 and COLORS.Gold or COLORS.Muted)
        rankLabel.Position = UDim2.new(0, 14, 0, 0)
        rankLabel.Size = UDim2.fromOffset(52, 52)
        rankLabel.Font = Enum.Font.GothamBold
        local name = label(row, "Player", tostring(entry.PlayerName or ("User " .. playerId)), 14, COLORS.Text)
        name.Position = UDim2.new(0, 72, 0, 0)
        name.Size = UDim2.new(0.6, 0, 1, 0)
        name.Font = Enum.Font.GothamBold
        local value =
            label(row, "Value", tostring(math.max(0, math.floor(tonumber(entry.Value) or 0))), 14, COLORS.Cyan)
        value.Position = UDim2.new(0.68, 0, 0, 0)
        value.Size = UDim2.new(0.28, -10, 1, 0)
        value.TextXAlignment = Enum.TextXAlignment.Right
        if isLocal then
            name.Text = name.Text .. "  •  YOU"
        end
        table.insert(rowInstances, row)
    end
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server leaderboard…"
    local remote = remotes:FindFirstChild("GetLeaderboard")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Leaderboard unavailable: remote is missing."
        clearRows()
        refreshInFlight = false
        return
    end
    local ok, result = pcall(function()
        return remote:InvokeServer(currentCategory, 25)
    end)
    if not ok or type(result) ~= "table" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Leaderboard unavailable: server snapshot failed."
        clearRows()
    else
        render(result)
    end
    refreshInFlight = false
end

for category, categoryButton in pairs(categoryButtons) do
    categoryButton.Activated:Connect(function()
        currentCategory = category
        refresh()
    end)
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavLeaderboard")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavLeaderboard", "LEADERBOARD", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 10
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

local updated = remotes:FindFirstChild("LeaderboardUpdated")
if updated and updated:IsA("RemoteEvent") then
    updated.OnClientEvent:Connect(function(category, entries)
        if category == currentCategory and screen.Enabled and type(entries) == "table" then
            render(entries)
        end
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
print("[LeaderboardController] Initialized")
