--!strict
-- ChatController: server-filtered chat with scoped channel selection.
-- History is requested only for global/trade; guild/island/party messages arrive live.

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
    Field = Color3.fromRGB(20, 24, 38),
    Text = Color3.fromRGB(230, 235, 245),
    Muted = Color3.fromRGB(150, 162, 184),
    Cyan = Color3.fromRGB(100, 220, 255),
    Green = Color3.fromRGB(111, 220, 151),
    Danger = Color3.fromRGB(255, 132, 132),
}

local CHANNELS = {
    { Id = "global", Label = "GLOBAL" },
    { Id = "trade", Label = "TRADE" },
    { Id = "island", Label = "ISLAND" },
    { Id = "guild", Label = "GUILD" },
    { Id = "party", Label = "PARTY" },
}

local screen: ScreenGui
local panel: Frame
local status: TextLabel
local history: ScrollingFrame
local messageInput: TextBox
local currentChannel = "global"
local rows: { GuiObject } = {}
local channelButtons: { [string]: TextButton } = {}
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

local function textField(parent: Instance, name: string, placeholder: string): TextBox
    local result = Instance.new("TextBox")
    result.Name = name
    result.BackgroundColor3 = COLORS.Field
    result.BorderSizePixel = 0
    result.PlaceholderText = placeholder
    result.PlaceholderColor3 = COLORS.Muted
    result.TextColor3 = COLORS.Text
    result.Font = Enum.Font.Gotham
    result.TextSize = 12
    result.ClearTextOnFocus = false
    result.TextXAlignment = Enum.TextXAlignment.Left
    result.Parent = parent
    round(result, 6)
    outline(result, COLORS.Cyan, 0.84)
    return result
end

local function makeScreen(): (ScreenGui, Frame, TextLabel, ScrollingFrame, TextBox, Frame)
    local existing = screens:FindFirstChild("ChatScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "ChatScreen"
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
    createdPanel.Size = UDim2.fromScale(0.82, 0.78)
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
    local title = label(titleBar, "Title", "AETHER CHAT", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = label(titleBar, "Subtitle", "Messages are filtered and routed by the server", 12, COLORS.Muted)
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

    local createdStatus = label(createdPanel, "Status", "Loading chat…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 20, 0, 72)
    createdStatus.Size = UDim2.new(1, -40, 0, 25)

    local createdChannelBar = Instance.new("Frame")
    createdChannelBar.Name = "ChannelBar"
    createdChannelBar.Position = UDim2.new(0, 20, 0, 105)
    createdChannelBar.Size = UDim2.new(1, -40, 0, 34)
    createdChannelBar.BackgroundTransparency = 1
    createdChannelBar.Parent = createdPanel
    local channelLayout = Instance.new("UIListLayout")
    channelLayout.FillDirection = Enum.FillDirection.Horizontal
    channelLayout.Padding = UDim.new(0, 6)
    channelLayout.SortOrder = Enum.SortOrder.LayoutOrder
    channelLayout.Parent = createdChannelBar
    for index, channel in ipairs(CHANNELS) do
        local channelButton = button(createdChannelBar, "Channel_" .. channel.Id, channel.Label, COLORS.Raised)
        channelButton.LayoutOrder = index
        channelButton.Size = UDim2.new(1 / #CHANNELS, -5, 1, 0)
        channelButtons[channel.Id] = channelButton
    end

    local createdHistory = Instance.new("ScrollingFrame")
    createdHistory.Name = "History"
    createdHistory.Position = UDim2.new(0, 20, 0, 151)
    createdHistory.Size = UDim2.new(1, -40, 1, -213)
    createdHistory.BackgroundTransparency = 1
    createdHistory.BorderSizePixel = 0
    createdHistory.ScrollBarThickness = 5
    createdHistory.ScrollBarImageColor3 = COLORS.Cyan
    createdHistory.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdHistory.CanvasSize = UDim2.new()
    createdHistory.Parent = createdPanel
    local historyLayout = Instance.new("UIListLayout")
    historyLayout.Name = "HistoryLayout"
    historyLayout.Padding = UDim.new(0, 5)
    historyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    historyLayout.Parent = createdHistory

    local createdMessage = textField(createdPanel, "MessageInput", "Write a message…")
    createdMessage.Position = UDim2.new(0, 20, 1, -52)
    createdMessage.Size = UDim2.new(1, -126, 0, 34)
    local send = button(createdPanel, "SendButton", "SEND", Color3.fromRGB(31, 77, 91))
    send.Position = UDim2.new(1, -96, 1, -52)
    send.Size = UDim2.fromOffset(76, 34)

    return createdScreen, createdPanel, createdStatus, createdHistory, createdMessage, createdChannelBar
end

local _channelBar: Frame
screen, panel, status, history, messageInput, _channelBar = makeScreen()

local function clearRows()
    for _, row in ipairs(rows) do
        row:Destroy()
    end
    table.clear(rows)
end

local function render(messages: { any })
    clearRows()
    for channel, channelButton in pairs(channelButtons) do
        channelButton.BackgroundColor3 = channel == currentChannel and Color3.fromRGB(31, 77, 91) or COLORS.Raised
    end
    if #messages == 0 then
        status.TextColor3 = COLORS.Muted
        if currentChannel == "global" or currentChannel == "trade" then
            status.Text = "No messages yet."
        else
            status.Text = "Live-only channel: messages appear as players send them."
        end
        local empty = label(history, "EmptyState", "No messages in this channel", 14, COLORS.Muted)
        empty.Size = UDim2.new(1, -8, 0, 50)
        empty.TextXAlignment = Enum.TextXAlignment.Center
        table.insert(rows, empty)
        return
    end
    status.TextColor3 = COLORS.Cyan
    status.Text = string.format("%s  •  %d message(s)  •  server-filtered", string.upper(currentChannel), #messages)
    for index, message in ipairs(messages) do
        if type(message) == "table" then
            local row = Instance.new("TextLabel")
            row.Name = "Message_" .. tostring(index)
            row.LayoutOrder = index
            row.Size = UDim2.new(1, -8, 0, 42)
            row.BackgroundColor3 = message.PlayerId == player.UserId and Color3.fromRGB(43, 75, 65) or COLORS.Raised
            row.BorderSizePixel = 0
            row.TextColor3 = COLORS.Text
            row.Font = Enum.Font.GothamMedium
            row.TextSize = 12
            row.TextWrapped = true
            row.TextXAlignment = Enum.TextXAlignment.Left
            row.Text =
                string.format("  %s: %s", tostring(message.PlayerName or "Explorer"), tostring(message.Message or ""))
            row.Parent = history
            round(row, 6)
            table.insert(rows, row)
        end
    end
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    local messages: { any } = {}
    local remote = remotes:FindFirstChild("GetChatHistory")
    if remote and remote:IsA("RemoteFunction") then
        local ok, result = pcall(function()
            return remote:InvokeServer(currentChannel, 50)
        end)
        if ok and type(result) == "table" then
            messages = result
        end
    end
    table.sort(messages, function(left, right)
        return tostring(left.Timestamp or "") < tostring(right.Timestamp or "")
    end)
    render(messages)
    refreshInFlight = false
end

for channel, channelButton in pairs(channelButtons) do
    channelButton.Activated:Connect(function()
        currentChannel = channel
        refresh()
    end)
end

local send = panel:FindFirstChild("SendButton")
if send and send:IsA("TextButton") then
    send.Activated:Connect(function()
        local message = messageInput.Text
        if string.gsub(message, "^%s*(.-)%s*$", "%1") == "" then
            return
        end
        local remote = remotes:FindFirstChild("SendChatMessage")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(currentChannel, message)
            messageInput.Text = ""
        end
    end)
end

local received = remotes:FindFirstChild("ChatMessageReceived")
if received and received:IsA("RemoteEvent") then
    received.OnClientEvent:Connect(function(message)
        if screen.Enabled and type(message) == "table" and message.Channel == currentChannel then
            refresh()
        end
    end)
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavChat")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavChat", "CHAT", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 13
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
print("[ChatController] Initialized")
