--!strict
-- MailController: a small inbox and compose surface for server-authoritative mail.
-- Reading a message is also the only path that claims its attachments.

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
    Gold = Color3.fromRGB(255, 183, 77),
    Green = Color3.fromRGB(111, 220, 151),
    Danger = Color3.fromRGB(255, 132, 132),
}

local screen: ScreenGui
local panel: Frame
local status: TextLabel
local inbox: ScrollingFrame
local targetInput: TextBox
local subjectInput: TextBox
local messageInput: TextBox
local mailRows: { GuiObject } = {}
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

local function field(parent: Instance, name: string, placeholder: string): TextBox
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

local function makeScreen(): (ScreenGui, Frame, TextLabel, ScrollingFrame, TextBox, TextBox, TextBox)
    local existing = screens:FindFirstChild("MailScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "MailScreen"
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
    createdPanel.Size = UDim2.fromScale(0.86, 0.82)
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
    local title = label(titleBar, "Title", "AETHER MAIL", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 7)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = label(titleBar, "Subtitle", "Send messages and claim delivered attachments", 12, COLORS.Muted)
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

    local createdStatus = label(createdPanel, "Status", "Loading mailbox…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 20, 0, 72)
    createdStatus.Size = UDim2.new(1, -40, 0, 25)

    local compose = Instance.new("Frame")
    compose.Name = "Compose"
    compose.Position = UDim2.new(0, 20, 0, 105)
    compose.Size = UDim2.new(0.36, -10, 1, -125)
    compose.BackgroundColor3 = COLORS.Raised
    compose.BorderSizePixel = 0
    compose.Parent = createdPanel
    round(compose, 8)
    local composeTitle = label(compose, "ComposeTitle", "COMPOSE", 15, COLORS.Gold)
    composeTitle.Position = UDim2.new(0, 12, 0, 10)
    composeTitle.Size = UDim2.new(1, -24, 0, 24)
    composeTitle.Font = Enum.Font.GothamBold
    local createdTarget = field(compose, "TargetInput", "Recipient user ID (online)")
    createdTarget.Position = UDim2.new(0, 12, 0, 44)
    createdTarget.Size = UDim2.new(1, -24, 0, 32)
    local createdSubject = field(compose, "SubjectInput", "Subject")
    createdSubject.Position = UDim2.new(0, 12, 0, 84)
    createdSubject.Size = UDim2.new(1, -24, 0, 32)
    local createdMessage = field(compose, "MessageInput", "Message")
    createdMessage.Position = UDim2.new(0, 12, 0, 124)
    createdMessage.Size = UDim2.new(1, -24, 0, 110)
    createdMessage.TextWrapped = true
    createdMessage.TextYAlignment = Enum.TextYAlignment.Top
    createdMessage.MultiLine = true
    local send = button(compose, "SendButton", "SEND MAIL", Color3.fromRGB(31, 77, 91))
    send.Position = UDim2.new(0, 12, 0, 246)
    send.Size = UDim2.new(1, -24, 0, 34)
    local note = label(
        compose,
        "Note",
        "Recipient must be online. Items and currency can be attached by trusted callers; claims stay server-authoritative.",
        11,
        COLORS.Muted
    )
    note.Position = UDim2.new(0, 12, 0, 290)
    note.Size = UDim2.new(1, -24, 0, 80)
    note.TextYAlignment = Enum.TextYAlignment.Top

    local createdInbox = Instance.new("ScrollingFrame")
    createdInbox.Name = "Inbox"
    createdInbox.Position = UDim2.new(0.36, 10, 0, 105)
    createdInbox.Size = UDim2.new(0.64, -30, 1, -125)
    createdInbox.BackgroundTransparency = 1
    createdInbox.BorderSizePixel = 0
    createdInbox.ScrollBarThickness = 5
    createdInbox.ScrollBarImageColor3 = COLORS.Cyan
    createdInbox.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdInbox.CanvasSize = UDim2.new()
    createdInbox.Parent = createdPanel
    local layout = Instance.new("UIListLayout")
    layout.Name = "MailLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdInbox

    return createdScreen, createdPanel, createdStatus, createdInbox, createdTarget, createdSubject, createdMessage
end

screen, panel, status, inbox, targetInput, subjectInput, messageInput = makeScreen()

local function clearRows()
    for _, row in ipairs(mailRows) do
        row:Destroy()
    end
    table.clear(mailRows)
end

local function addEmpty(message: string)
    local empty = label(inbox, "EmptyState", message, 14, COLORS.Muted)
    empty.Size = UDim2.new(1, -8, 0, 60)
    empty.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(mailRows, empty)
end

local function addMail(mail: any, order: number)
    if type(mail) ~= "table" or type(mail.Id) ~= "string" then
        return
    end
    local read = mail.Read == true
    local card = Instance.new("Frame")
    card.Name = "Mail_" .. mail.Id
    card.Size = UDim2.new(1, -8, 0, 92)
    card.BackgroundColor3 = read and COLORS.Raised or Color3.fromRGB(43, 75, 65)
    card.BorderSizePixel = 0
    card.LayoutOrder = order
    card.Parent = inbox
    round(card, 7)
    outline(card, read and COLORS.Cyan or COLORS.Green, 0.78)
    local subject =
        label(card, "Subject", tostring(mail.Subject or "(no subject)"), 14, read and COLORS.Text or COLORS.Green)
    subject.Position = UDim2.new(0, 12, 0, 8)
    subject.Size = UDim2.new(0.62, 0, 0, 22)
    subject.Font = Enum.Font.GothamBold
    local from = label(card, "From", "From: " .. tostring(mail.From or mail.FromId or "Unknown"), 11, COLORS.Muted)
    from.Position = UDim2.new(0, 12, 0, 32)
    from.Size = UDim2.new(0.62, 0, 0, 18)
    local message = label(card, "Message", tostring(mail.Message or ""), 11, COLORS.Muted)
    message.Position = UDim2.new(0, 12, 0, 52)
    message.Size = UDim2.new(0.62, 0, 0, 32)
    message.TextYAlignment = Enum.TextYAlignment.Top
    local action = button(
        card,
        "Action",
        read and "DELETE" or "READ + CLAIM",
        read and Color3.fromRGB(83, 65, 35) or Color3.fromRGB(31, 77, 91)
    )
    action.AnchorPoint = Vector2.new(1, 0.5)
    action.Position = UDim2.new(1, -12, 0.5, 0)
    action.Size = UDim2.fromOffset(112, 36)
    action.Activated:Connect(function()
        local remoteName = read and "DeleteMail" or "ReadMail"
        local remote = remotes:FindFirstChild(remoteName)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(mail.Id)
            action.Active = false
            action.Text = "WORKING…"
        end
    end)
    table.insert(mailRows, card)
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    clearRows()
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server mailbox…"
    local remote = remotes:FindFirstChild("GetMailbox")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Mailbox unavailable: endpoint is missing."
        addEmpty("No mailbox action is available in this state.")
        refreshInFlight = false
        return
    end
    local ok, result = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok or type(result) ~= "table" then
        status.TextColor3 = COLORS.Danger
        status.Text = "Mailbox unavailable: server read failed."
        addEmpty("Try again in a moment.")
        refreshInFlight = false
        return
    end
    table.sort(result, function(left, right)
        return tostring(left.SentAt or "") > tostring(right.SentAt or "")
    end)
    local unread = 0
    for _, mail in ipairs(result) do
        if type(mail) == "table" and mail.Read ~= true then
            unread += 1
        end
    end
    status.TextColor3 = COLORS.Cyan
    status.Text = string.format("%d message(s)  •  %d unread  •  read to claim attachments", #result, unread)
    if #result == 0 then
        addEmpty("Your inbox is empty.")
    else
        for index, mail in ipairs(result) do
            addMail(mail, index)
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
    local existing = nav:FindFirstChild("NavMail")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavMail", "MAIL", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 12
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

local compose = panel:FindFirstChild("Compose")
local send = compose and compose:FindFirstChild("SendButton")
if send and send:IsA("TextButton") then
    send.Activated:Connect(function()
        local targetUserId = tonumber((string.gsub(targetInput.Text, "^%s*(.-)%s*$", "%1")))
        local subject = (string.gsub(subjectInput.Text, "^%s*(.-)%s*$", "%1"))
        if not targetUserId or targetUserId < 1 or targetUserId ~= math.floor(targetUserId) or subject == "" then
            status.TextColor3 = COLORS.Danger
            status.Text = "Enter a whole online recipient user ID and a subject."
            return
        end
        local remote = remotes:FindFirstChild("SendMail")
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(targetUserId, subject, messageInput.Text, {})
            status.TextColor3 = COLORS.Cyan
            status.Text = "Mail request sent to the server."
            subjectInput.Text = ""
            messageInput.Text = ""
        end
    end)
end

local received = remotes:FindFirstChild("MailReceived")
if received and received:IsA("RemoteEvent") then
    received.OnClientEvent:Connect(function()
        if screen.Enabled then
            refresh()
        end
    end)
end
local updated = remotes:FindFirstChild("MailUpdated")
if updated and updated:IsA("RemoteEvent") then
    updated.OnClientEvent:Connect(function()
        if screen.Enabled then
            refresh()
        end
    end)
end
local deleted = remotes:FindFirstChild("MailDeleted")
if deleted and deleted:IsA("RemoteEvent") then
    deleted.OnClientEvent:Connect(function()
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

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        refresh()
    else
        clearRows()
    end
end)

wireNav()
print("[MailController] Initialized")
