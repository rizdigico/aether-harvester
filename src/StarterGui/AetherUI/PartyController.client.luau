--!strict
-- PartyController: renders the session party and server-issued invites.

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
local playerInput: TextBox
local inviteButton: TextButton
local createButton: TextButton
local leaveButton: TextButton
local cards: { GuiObject } = {}
local pendingInvite: { PartyId: string, InvitedBy: number, InviterName: string }?
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

local function makeScreen(): (ScreenGui, TextLabel, ScrollingFrame, TextBox, TextButton, TextButton, TextButton)
    local existing = screens:FindFirstChild("PartyScreen")
    if existing and existing:IsA("ScreenGui") then
        existing:Destroy()
    end

    local createdScreen = Instance.new("ScreenGui")
    createdScreen.Name = "PartyScreen"
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

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.Size = UDim2.fromScale(0.72, 0.72)
    panel.BackgroundColor3 = COLORS.Panel
    panel.BorderSizePixel = 0
    panel.Parent = backdrop
    round(panel, 10)
    outline(panel, COLORS.Cyan, 0.6)

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 68)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 23, 36)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = panel

    local title = label(titleBar, "Title", "PARTY OPS", 22, COLORS.Cyan)
    title.Position = UDim2.new(0, 20, 0, 8)
    title.Size = UDim2.new(1, -90, 0, 27)
    title.Font = Enum.Font.GothamBold
    local subtitle = label(titleBar, "Subtitle", "Coordinate an expedition with up to four players.", 12, COLORS.Muted)
    subtitle.Position = UDim2.new(0, 20, 0, 37)
    subtitle.Size = UDim2.new(1, -90, 0, 18)

    local close = button(titleBar, "CloseButton", "X", COLORS.Raised)
    close.AnchorPoint = Vector2.new(1, 0.5)
    close.Position = UDim2.new(1, -14, 0.5, 0)
    close.Size = UDim2.fromOffset(38, 34)
    close.TextSize = 16
    close.Activated:Connect(function()
        createdScreen.Enabled = false
    end)

    local createdStatus = label(panel, "Status", "Reading server party state…", 13, COLORS.Muted)
    createdStatus.Position = UDim2.new(0, 24, 0, 84)
    createdStatus.Size = UDim2.new(1, -48, 0, 28)

    local createdList = Instance.new("ScrollingFrame")
    createdList.Name = "MemberList"
    createdList.Position = UDim2.new(0, 24, 0, 122)
    createdList.Size = UDim2.new(1, -48, 1, -250)
    createdList.BackgroundTransparency = 1
    createdList.BorderSizePixel = 0
    createdList.ScrollBarThickness = 5
    createdList.ScrollBarImageColor3 = COLORS.Cyan
    createdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    createdList.CanvasSize = UDim2.new()
    createdList.Parent = panel
    local layout = Instance.new("UIListLayout")
    layout.Name = "MemberLayout"
    layout.Padding = UDim.new(0, 7)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = createdList

    local controls = Instance.new("Frame")
    controls.Name = "Controls"
    controls.Position = UDim2.new(0, 24, 1, -110)
    controls.Size = UDim2.new(1, -48, 0, 86)
    controls.BackgroundTransparency = 1
    controls.Parent = panel

    local createdInput = Instance.new("TextBox")
    createdInput.Name = "PlayerInput"
    createdInput.Position = UDim2.new(0, 0, 0, 0)
    createdInput.Size = UDim2.new(0.55, -7, 0, 36)
    createdInput.BackgroundColor3 = COLORS.Raised
    createdInput.BorderSizePixel = 0
    createdInput.PlaceholderText = "Online player name"
    createdInput.PlaceholderColor3 = COLORS.Muted
    createdInput.TextColor3 = COLORS.Text
    createdInput.Font = Enum.Font.GothamMedium
    createdInput.TextSize = 12
    createdInput.ClearTextOnFocus = false
    createdInput.Parent = controls
    round(createdInput, 6)
    outline(createdInput, COLORS.Cyan, 0.82)

    local createdInvite = button(controls, "InviteButton", "INVITE", Color3.fromRGB(31, 77, 91))
    createdInvite.Position = UDim2.new(0.55, 0, 0, 0)
    createdInvite.Size = UDim2.new(0.22, -5, 0, 36)

    local createdCreate = button(controls, "CreateButton", "CREATE PARTY", Color3.fromRGB(31, 77, 91))
    createdCreate.Position = UDim2.new(0, 0, 0, 46)
    createdCreate.Size = UDim2.new(0.48, -5, 0, 36)

    local createdLeave = button(controls, "LeaveButton", "LEAVE PARTY", Color3.fromRGB(83, 48, 55))
    createdLeave.Position = UDim2.new(0.52, 0, 0, 46)
    createdLeave.Size = UDim2.new(0.48, 0, 0, 36)

    return createdScreen, createdStatus, createdList, createdInput, createdInvite, createdCreate, createdLeave
end

screen, status, list, playerInput, inviteButton, createButton, leaveButton = makeScreen()

local function clearCards()
    for _, card in ipairs(cards) do
        card:Destroy()
    end
    table.clear(cards)
end

local function showEmpty(message: string)
    local empty = label(list, "EmptyState", message, 14, COLORS.Muted)
    empty.Size = UDim2.new(1, -8, 0, 60)
    empty.TextXAlignment = Enum.TextXAlignment.Center
    table.insert(cards, empty)
end

local function render(snapshot: any)
    clearCards()
    if type(snapshot) ~= "table" or type(snapshot.Id) ~= "string" then
        status.TextColor3 = COLORS.Cyan
        status.Text = "No active party  •  create one or accept an invite"
        inviteButton.Active = false
        inviteButton.AutoButtonColor = false
        createButton.Active = true
        createButton.AutoButtonColor = true
        leaveButton.Active = false
        leaveButton.AutoButtonColor = false
        showEmpty("No party members yet.")
        return
    end

    local members = type(snapshot.Members) == "table" and snapshot.Members or {}
    local ownerId = tonumber(snapshot.OwnerId) or 0
    local maxMembers = math.max(#members, math.floor(tonumber(snapshot.MaxMembers) or 4))
    status.TextColor3 = COLORS.Green
    status.Text = string.format("PARTY %s  •  %d/%d members", tostring(snapshot.Id), #members, maxMembers)
    inviteButton.Active = #members < maxMembers
    inviteButton.AutoButtonColor = #members < maxMembers
    createButton.Active = false
    createButton.AutoButtonColor = false
    leaveButton.Active = true
    leaveButton.AutoButtonColor = true

    if #members == 0 then
        showEmpty("Party state is empty; the server will repair it on the next update.")
    end
    for index, member in ipairs(members) do
        if type(member) == "table" then
            local row = Instance.new("Frame")
            row.Name = "Member_" .. tostring(member.UserId or index)
            row.LayoutOrder = index
            row.Size = UDim2.new(1, -8, 0, 48)
            row.BackgroundColor3 = COLORS.Raised
            row.BorderSizePixel = 0
            row.Parent = list
            round(row, 7)
            outline(row, member.IsOwner == true and COLORS.Gold or COLORS.Cyan, 0.8)
            local text = label(
                row,
                "MemberName",
                string.format(
                    "%s  •  %s",
                    tostring(member.DisplayName or member.Name or "Player"),
                    member.IsOwner == true and "OWNER" or "MEMBER"
                ),
                13,
                member.IsOwner == true and COLORS.Gold or COLORS.Text
            )
            text.Position = UDim2.new(0, 14, 0, 0)
            text.Size = UDim2.new(0.76, 0, 1, 0)
            local memberId = tonumber(member.UserId)
            if ownerId == player.UserId and memberId and memberId ~= player.UserId then
                local kick = button(row, "Kick", "REMOVE", Color3.fromRGB(83, 48, 55))
                kick.AnchorPoint = Vector2.new(1, 0.5)
                kick.Position = UDim2.new(1, -10, 0.5, 0)
                kick.Size = UDim2.fromOffset(74, 30)
                kick.Activated:Connect(function()
                    local remote = remotes:FindFirstChild("KickPartyMember")
                    if remote and remote:IsA("RemoteEvent") then
                        remote:FireServer(memberId)
                    end
                end)
            end
            table.insert(cards, row)
        end
    end
end

local function refresh()
    if refreshInFlight or not screen.Enabled then
        return
    end
    refreshInFlight = true
    status.TextColor3 = COLORS.Muted
    status.Text = "Reading server party state…"
    local remote = remotes:FindFirstChild("GetParty")
    if not remote or not remote:IsA("RemoteFunction") then
        status.TextColor3 = COLORS.Danger
        status.Text = "Party unavailable: endpoint is missing."
        refreshInFlight = false
        return
    end
    local ok, snapshot = pcall(function()
        return remote:InvokeServer()
    end)
    if not ok then
        status.TextColor3 = COLORS.Danger
        status.Text = "Party unavailable: server snapshot failed."
    else
        render(snapshot)
    end
    refreshInFlight = false
end

local function findOnlinePlayer(query: string): Player?
    local normalized = string.lower((string.gsub(query, "^%s*(.-)%s*$", "%1")))
    if normalized == "" then
        return nil
    end
    for _, candidate in ipairs(Players:GetPlayers()) do
        if
            candidate ~= player
            and (string.lower(candidate.Name) == normalized or string.lower(candidate.DisplayName) == normalized)
        then
            return candidate
        end
    end
    return nil
end

inviteButton.Activated:Connect(function()
    if not inviteButton.Active then
        return
    end
    local target = findOnlinePlayer(playerInput.Text)
    if not target then
        status.TextColor3 = COLORS.Danger
        status.Text = "Enter an exact online player name."
        return
    end
    local remote = remotes:FindFirstChild("InviteToParty")
    if remote and remote:IsA("RemoteEvent") then
        inviteButton.Active = false
        inviteButton.Text = "SENDING…"
        remote:FireServer(target.UserId)
        task.delay(0.5, refresh)
    end
end)

createButton.Activated:Connect(function()
    if not createButton.Active then
        return
    end
    local remote = remotes:FindFirstChild("CreateParty")
    if remote and remote:IsA("RemoteEvent") then
        createButton.Active = false
        createButton.Text = "CREATING…"
        remote:FireServer()
        task.delay(0.5, refresh)
    end
end)

leaveButton.Activated:Connect(function()
    if not leaveButton.Active then
        return
    end
    local remote = remotes:FindFirstChild("LeaveParty")
    if remote and remote:IsA("RemoteEvent") then
        leaveButton.Active = false
        remote:FireServer()
    end
end)

local updated = remotes:FindFirstChild("PartyUpdated")
if updated and updated:IsA("RemoteEvent") then
    updated.OnClientEvent:Connect(function(snapshot)
        if screen.Enabled then
            render(snapshot)
        end
    end)
end

local inviteRemote = remotes:FindFirstChild("PartyInvite")
if inviteRemote and inviteRemote:IsA("RemoteEvent") then
    inviteRemote.OnClientEvent:Connect(function(partyId: any, invitedBy: any, inviterName: any)
        if type(partyId) ~= "string" or type(invitedBy) ~= "number" then
            return
        end
        local invite: { PartyId: string, InvitedBy: number, InviterName: string } = {
            PartyId = partyId,
            InvitedBy = invitedBy,
            InviterName = tostring(inviterName or "Player"),
        }
        pendingInvite = invite
        for _, sibling in ipairs(screens:GetChildren()) do
            if sibling:IsA("ScreenGui") then
                sibling.Enabled = false
            end
        end
        screen.Enabled = true
        clearCards()
        status.TextColor3 = COLORS.Gold
        status.Text = string.format("Invite from %s  •  accept or decline below", invite.InviterName)
        showEmpty(string.format("Party %s is inviting you.", partyId))
    end)
end

local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        if screen.Enabled then
            status.TextColor3 = COLORS.Danger
            status.Text = tostring(message)
            task.delay(0.4, refresh)
        end
    end)
end

local function ensureInviteControls()
    local existing = screen:FindFirstChild("InviteActions", true)
    if existing then
        existing:Destroy()
    end
    if not pendingInvite then
        return
    end
    local panel = screen:FindFirstChild("Panel", true)
    if not panel or not panel:IsA("Frame") then
        return
    end
    local actions = Instance.new("Frame")
    actions.Name = "InviteActions"
    actions.AnchorPoint = Vector2.new(0.5, 0)
    actions.Position = UDim2.new(0.5, 0, 0, 286)
    actions.Size = UDim2.new(0.58, 0, 0, 42)
    actions.BackgroundTransparency = 1
    actions.Parent = panel
    local accept = button(actions, "AcceptInvite", "ACCEPT INVITE", Color3.fromRGB(43, 75, 65))
    accept.Position = UDim2.new(0, 0, 0, 0)
    accept.Size = UDim2.new(0.48, -5, 1, 0)
    local decline = button(actions, "DeclineInvite", "DECLINE", Color3.fromRGB(83, 48, 55))
    decline.Position = UDim2.new(0.52, 0, 0, 0)
    decline.Size = UDim2.new(0.48, 0, 1, 0)
    accept.Activated:Connect(function()
        local invite = pendingInvite
        pendingInvite = nil
        actions:Destroy()
        local remote = remotes:FindFirstChild("RespondPartyInvite")
        if invite and remote and remote:IsA("RemoteEvent") then
            remote:FireServer(invite.PartyId, true)
        end
    end)
    decline.Activated:Connect(function()
        local invite = pendingInvite
        pendingInvite = nil
        actions:Destroy()
        local remote = remotes:FindFirstChild("RespondPartyInvite")
        if invite and remote and remote:IsA("RemoteEvent") then
            remote:FireServer(invite.PartyId, false)
        end
        screen.Enabled = false
    end)
end

local function wireNav()
    local mainMenu = screens:FindFirstChild("MainMenu")
    local nav = mainMenu and mainMenu:FindFirstChild("NavContainer", true)
    if not nav or not nav:IsA("GuiObject") then
        return
    end
    local existing = nav:FindFirstChild("NavParty")
    local open = if existing and existing:IsA("TextButton")
        then existing
        else button(nav, "NavParty", "PARTY OPS", Color3.fromRGB(31, 77, 91))
    open.Size = UDim2.new(0.9, 0, 0, 42)
    open.LayoutOrder = 17
    open.Activated:Connect(function()
        for _, sibling in ipairs(screens:GetChildren()) do
            if sibling:IsA("ScreenGui") then
                sibling.Enabled = false
            end
        end
        screen.Enabled = true
        ensureInviteControls()
        refresh()
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        ensureInviteControls()
        refresh()
    else
        clearCards()
    end
end)

wireNav()
print("[PartyController] Initialized")
