--!strict
-- TradeController: client surface for targeted, server-authoritative trades.
-- The server remains the source of truth for distance, ownership, and transfer.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local AetherUI = playerGui:WaitForChild("AetherUI")
local Screens = AetherUI:WaitForChild("Screens")
local Shared = ReplicatedStorage:WaitForChild("AetherShared")
local Remotes = Shared:WaitForChild("Remotes")
local ItemsData = require(Shared:WaitForChild("Data"):WaitForChild("Items"))
local GameClient = require(Shared:WaitForChild("Modules"):WaitForChild("GameClient"))
local Toast = require(script.Parent.Components.Toast)

local window = Screens:FindFirstChild("TradeWindow")
if not window then
    return nil
end

local uiConnections: { RBXScriptConnection } = {}
local globalConnections: { RBXScriptConnection } = {}
local playerRows: { TextButton } = {}
local itemRows: { TextButton } = {}
local offerMap: { [string]: number } = {}
local requestMap: { [string]: number } = {}
local selectedTargetUserId: number? = nil
local selectionMode = "offer"
local pendingTrade: any = nil
local outgoingTrade: any = nil
local toastHost: any = nil

local BASE_ROW_COLOR = Color3.fromRGB(33, 37, 54)
local SELECTED_ROW_COLOR = Color3.fromRGB(60, 120, 90)
local TARGET_ROW_COLOR = Color3.fromRGB(54, 91, 128)
local MAX_TRADE_DISTANCE = 50

local function mainFrame(): Frame?
    local frame = window:FindFirstChild("MainFrame")
    if frame and frame:IsA("Frame") then
        return frame
    end
    return nil
end

local function showToast(text: string, toastType: any)
    if toastHost then
        toastHost.Queue({ Text = text, Type = toastType })
    else
        toastHost = Toast.enqueue(window, { Text = text, Type = toastType })
    end
end

local function disconnectUi()
    for _, connection in ipairs(uiConnections) do
        connection:Disconnect()
    end
    table.clear(uiConnections)
    for _, row in ipairs(playerRows) do
        row:Destroy()
    end
    table.clear(playerRows)
    for _, row in ipairs(itemRows) do
        row:Destroy()
    end
    table.clear(itemRows)
end

local function getRoot(character: Model?): BasePart?
    if not character then
        return nil
    end
    local root = character:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        return root
    end
    return nil
end

local function isNearby(target: Player): boolean
    local character = player.Character
    local targetCharacter = target.Character
    local root = getRoot(character)
    local targetRoot = getRoot(targetCharacter)
    return root ~= nil and targetRoot ~= nil and (root.Position - targetRoot.Position).Magnitude <= MAX_TRADE_DISTANCE
end

local function ensureTargetLabel(frame: Frame): TextLabel
    local existing = frame:FindFirstChild("TradeTargetLabel")
    if existing and existing:IsA("TextLabel") then
        return existing
    end
    local label = Instance.new("TextLabel")
    label.Name = "TradeTargetLabel"
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.36, 0, 0.095, 0)
    label.Size = UDim2.new(0.6, 0, 0.09, 0)
    label.TextColor3 = Color3.fromRGB(230, 235, 245)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = "Select a nearby player"
    label.Parent = frame
    return label
end

local function ensureSelectionControls(slots: Frame): (TextButton, TextLabel, ScrollingFrame)
    local modeButton: TextButton
    local modeButtonInstance = slots:FindFirstChild("SelectionModeButton")
    if modeButtonInstance and modeButtonInstance:IsA("TextButton") then
        modeButton = modeButtonInstance
    else
        local createdModeButton = Instance.new("TextButton")
        modeButton = createdModeButton
        modeButton.Name = "SelectionModeButton"
        modeButton.BackgroundColor3 = Color3.fromRGB(47, 54, 77)
        modeButton.BorderSizePixel = 0
        modeButton.Position = UDim2.new(0.02, 0, 0.15, 0)
        modeButton.Size = UDim2.new(0.55, 0, 0.13, 0)
        modeButton.TextColor3 = Color3.fromRGB(230, 235, 245)
        modeButton.Font = Enum.Font.GothamMedium
        modeButton.TextSize = 13
        modeButton.Parent = slots
    end

    local summary: TextLabel
    local summaryInstance = slots:FindFirstChild("SelectionSummary")
    if summaryInstance and summaryInstance:IsA("TextLabel") then
        summary = summaryInstance
    else
        local createdSummary = Instance.new("TextLabel")
        summary = createdSummary
        summary.Name = "SelectionSummary"
        summary.BackgroundTransparency = 1
        summary.Position = UDim2.new(0.59, 0, 0.15, 0)
        summary.Size = UDim2.new(0.39, 0, 0.13, 0)
        summary.TextColor3 = Color3.fromRGB(160, 174, 196)
        summary.Font = Enum.Font.Gotham
        summary.TextSize = 12
        summary.TextWrapped = true
        summary.TextXAlignment = Enum.TextXAlignment.Right
        summary.Parent = slots
    end

    local itemScroll: ScrollingFrame
    local itemScrollInstance = slots:FindFirstChild("ItemScroll")
    if itemScrollInstance and itemScrollInstance:IsA("ScrollingFrame") then
        itemScroll = itemScrollInstance
    else
        local createdItemScroll = Instance.new("ScrollingFrame")
        itemScroll = createdItemScroll
        itemScroll.Name = "ItemScroll"
        itemScroll.BackgroundTransparency = 1
        itemScroll.BorderSizePixel = 0
        itemScroll.Position = UDim2.new(0.02, 0, 0.3, 0)
        itemScroll.Size = UDim2.new(0.96, 0, 0.66, 0)
        itemScroll.ScrollBarThickness = 5
        itemScroll.CanvasSize = UDim2.new()
        itemScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        itemScroll.Parent = slots

        local layout = Instance.new("UIListLayout")
        layout.Name = "ItemLayout"
        layout.Padding = UDim.new(0, 4)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = itemScroll
    end
    return modeButton, summary, itemScroll
end

local function selectedMap(): { [string]: number }
    if selectionMode == "request" then
        return requestMap
    end
    return offerMap
end

local function countEntries(items: { [string]: number }): number
    local count = 0
    for _ in pairs(items) do
        count += 1
    end
    return count
end

local function renderSelectionState(modeButton: TextButton, summary: TextLabel)
    local active = selectedMap()
    modeButton.Text = selectionMode == "request" and "REQUEST ITEMS  •  click to offer"
        or "OFFER ITEMS  •  click to request"
    summary.Text = string.format("Offer: %d   Request: %d", countEntries(offerMap), countEntries(requestMap))
    for _, row in ipairs(itemRows) do
        local itemId = row:GetAttribute("ItemId")
        if type(itemId) == "string" then
            row.BackgroundColor3 = active[itemId] and SELECTED_ROW_COLOR or BASE_ROW_COLOR
        end
    end
end

local function refreshItems(itemScroll: ScrollingFrame, modeButton: TextButton, summary: TextLabel)
    for _, row in ipairs(itemRows) do
        row:Destroy()
    end
    table.clear(itemRows)
    local oldEmpty = itemScroll:FindFirstChild("NoTradeItems")
    if oldEmpty then
        oldEmpty:Destroy()
    end

    local getInventory = Remotes:FindFirstChild("GetInventory")
    if not getInventory or not getInventory:IsA("RemoteFunction") then
        return
    end
    local ok, inventory = pcall(function()
        return getInventory:InvokeServer()
    end)
    if not ok or type(inventory) ~= "table" then
        return
    end

    local order: { string } = {}
    for itemId, count in pairs(inventory) do
        if type(itemId) == "string" and type(count) == "number" and count > 0 then
            table.insert(order, itemId)
        end
    end
    table.sort(order)

    if #order == 0 then
        local empty = Instance.new("TextLabel")
        empty.Name = "NoTradeItems"
        empty.BackgroundTransparency = 1
        empty.Size = UDim2.new(1, 0, 0, 32)
        empty.Text = "No items available"
        empty.TextColor3 = Color3.fromRGB(160, 174, 196)
        empty.Font = Enum.Font.Gotham
        empty.TextSize = 13
        empty.Parent = itemScroll
    end

    for index, itemId in ipairs(order) do
        local count = inventory[itemId]
        local definition = ItemsData.GetItem(itemId)
        local name = (definition and definition.Name) or itemId
        local row = Instance.new("TextButton")
        row.Name = "TradeItem_" .. itemId
        row:SetAttribute("ItemId", itemId)
        row.LayoutOrder = index
        row.Size = UDim2.new(1, -6, 0, 32)
        row.BackgroundColor3 = BASE_ROW_COLOR
        row.BorderSizePixel = 0
        row.TextColor3 = Color3.fromRGB(230, 235, 245)
        row.Font = Enum.Font.GothamMedium
        row.TextSize = 13
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.Text = string.format("  %s  ×%d", name, count)
        row.MouseButton1Click:Connect(function()
            local active = selectedMap()
            if active[itemId] then
                active[itemId] = nil
            else
                active[itemId] = count
            end
            renderSelectionState(modeButton, summary)
        end)
        row.Parent = itemScroll
        table.insert(itemRows, row)
    end
    renderSelectionState(modeButton, summary)
end

local function refreshPlayers(scroll: ScrollingFrame, targetLabel: TextLabel)
    for _, row in ipairs(playerRows) do
        row:Destroy()
    end
    table.clear(playerRows)

    local nearby: { Player } = {}
    for _, candidate in ipairs(Players:GetPlayers()) do
        if candidate ~= player and isNearby(candidate) then
            table.insert(nearby, candidate)
        end
    end
    table.sort(nearby, function(first, second)
        return first.DisplayName:lower() < second.DisplayName:lower()
    end)

    local empty = scroll:FindFirstChild("EmptyState")
    if empty and empty:IsA("TextLabel") then
        empty.Visible = #nearby == 0
    end

    for index, candidate in ipairs(nearby) do
        local row = Instance.new("TextButton")
        row.Name = "Player_" .. tostring(candidate.UserId)
        row.LayoutOrder = index
        row.Size = UDim2.new(1, 0, 0, 34)
        row.BackgroundColor3 = candidate.UserId == selectedTargetUserId and TARGET_ROW_COLOR or BASE_ROW_COLOR
        row.BorderSizePixel = 0
        row.TextColor3 = Color3.fromRGB(230, 235, 245)
        row.Font = Enum.Font.GothamMedium
        row.TextSize = 13
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.Text = string.format("  %s  (@%s)", candidate.DisplayName, candidate.Name)
        row.MouseButton1Click:Connect(function()
            selectedTargetUserId = candidate.UserId
            targetLabel.Text = "Trading with " .. candidate.DisplayName
            refreshPlayers(scroll, targetLabel)
        end)
        row.Parent = scroll
        table.insert(playerRows, row)
    end
end

local function renderTradeState(frame: Frame, button: TextButton)
    local panel = frame:FindFirstChild("TradeStatePanel")
    if panel then
        panel:Destroy()
    end
    if not pendingTrade and not outgoingTrade then
        button.Text = "SEND TRADE"
        return
    end

    local isIncoming = pendingTrade ~= nil
    local trade = pendingTrade or outgoingTrade
    local offerer = Players:GetPlayerByUserId(trade.PlayerId)
    local offererName = offerer and offerer.DisplayName or ("User " .. tostring(trade.PlayerId))
    local target = Players:GetPlayerByUserId(trade.TargetPlayerId)
    local targetName = target and target.DisplayName or ("User " .. tostring(trade.TargetPlayerId))
    local requestItems = trade.RequestItems or {}
    local offeredItems = trade.OfferItems or {}
    local panelFrame = Instance.new("Frame")
    panelFrame.Name = "TradeStatePanel"
    panelFrame.BackgroundColor3 = Color3.fromRGB(47, 54, 77)
    panelFrame.BorderSizePixel = 0
    panelFrame.Position = UDim2.new(0.36, 0, 0.21, 0)
    panelFrame.Size = UDim2.new(0.6, 0, 0.24, 0)
    panelFrame.Parent = frame

    local details = Instance.new("TextLabel")
    details.BackgroundTransparency = 1
    details.Position = UDim2.new(0.03, 0, 0.05, 0)
    details.Size = UDim2.new(0.94, 0, 0.65, 0)
    details.TextColor3 = Color3.fromRGB(230, 235, 245)
    details.Font = Enum.Font.GothamMedium
    details.TextSize = 13
    details.TextWrapped = true
    details.TextXAlignment = Enum.TextXAlignment.Left
    details.TextYAlignment = Enum.TextYAlignment.Top
    if isIncoming then
        details.Text = string.format(
            "%s offered %d item type(s) and requests %d item type(s).\nAccept only if the exchange is correct.",
            offererName,
            countEntries(offeredItems),
            countEntries(requestItems)
        )
    else
        details.Text = string.format(
            "Offer sent to %s: %d offered item type(s), %d requested item type(s).\nWaiting for the other player.",
            targetName,
            countEntries(offeredItems),
            countEntries(requestItems)
        )
    end
    details.Parent = panelFrame

    if isIncoming then
        button.Text = "ACCEPT TRADE"
        local decline = Instance.new("TextButton")
        decline.Name = "DeclineTradeButton"
        decline.BackgroundColor3 = Color3.fromRGB(120, 63, 73)
        decline.BorderSizePixel = 0
        decline.Position = UDim2.new(0.7, 0, 0.72, 0)
        decline.Size = UDim2.new(0.27, 0, 0.2, 0)
        decline.Text = "DECLINE"
        decline.TextColor3 = Color3.fromRGB(255, 230, 230)
        decline.Font = Enum.Font.GothamBold
        decline.TextSize = 12
        decline.Parent = panelFrame
        uiConnections[#uiConnections + 1] = decline.MouseButton1Click:Connect(function()
            local cancel = Remotes:FindFirstChild("CancelTrade")
            if cancel then
                cancel:FireServer(trade.Id)
            end
        end)
    else
        button.Text = "CANCEL TRADE"
    end
end

local function wireWindow()
    local frame = mainFrame()
    if not frame then
        return
    end
    local playerList = frame:FindFirstChild("PlayerList")
    local playerScroll = playerList and playerList:FindFirstChild("PlayerScroll")
    local slots = frame:FindFirstChild("TradeSlots")
    local button = frame:FindFirstChild("ConfirmButton")
    if
        not playerScroll
        or not playerScroll:IsA("ScrollingFrame")
        or not slots
        or not slots:IsA("Frame")
        or not button
        or not button:IsA("TextButton")
    then
        return
    end

    local targetLabel = ensureTargetLabel(frame)
    local modeButton, summary, itemScroll = ensureSelectionControls(slots)
    refreshPlayers(playerScroll, targetLabel)
    refreshItems(itemScroll, modeButton, summary)

    uiConnections[#uiConnections + 1] = modeButton.MouseButton1Click:Connect(function()
        selectionMode = selectionMode == "offer" and "request" or "offer"
        refreshItems(itemScroll, modeButton, summary)
    end)
    uiConnections[#uiConnections + 1] = button.MouseButton1Click:Connect(function()
        if pendingTrade then
            local accept = Remotes:FindFirstChild("AcceptTrade")
            if accept then
                accept:FireServer(pendingTrade.Id)
            end
            return
        end
        if outgoingTrade then
            local cancel = Remotes:FindFirstChild("CancelTrade")
            if cancel then
                cancel:FireServer(outgoingTrade.Id)
            end
            return
        end
        if not selectedTargetUserId then
            showToast("Select a nearby player first", "warning")
            return
        end
        if next(offerMap) == nil and next(requestMap) == nil then
            showToast("Select an offer or request item first", "warning")
            return
        end
        local create = Remotes:FindFirstChild("CreateTrade")
        if not create then
            showToast("Trading is unavailable", "error")
            return
        end
        create:FireServer(selectedTargetUserId, offerMap, requestMap)
        showToast("Trade offer sent", "info")
    end)
    renderTradeState(frame, button)
end

local function clearLocalTradeState()
    pendingTrade = nil
    outgoingTrade = nil
    selectedTargetUserId = nil
    table.clear(offerMap)
    table.clear(requestMap)
    selectionMode = "offer"
end

local function wireServerEvents()
    local tradeCreated = Remotes:FindFirstChild("TradeCreated")
    if tradeCreated and tradeCreated:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = tradeCreated.OnClientEvent:Connect(function(trade)
            if type(trade) ~= "table" then
                return
            end
            if trade.TargetPlayerId == player.UserId then
                pendingTrade = trade
                if not window.Enabled then
                    GameClient:OpenScreen("TradeWindow")
                else
                    disconnectUi()
                    wireWindow()
                end
                showToast("Incoming trade offer", "info")
            elseif trade.PlayerId == player.UserId then
                outgoingTrade = trade
                if window.Enabled then
                    disconnectUi()
                    wireWindow()
                end
                showToast("Trade offer sent", "success")
            end
        end)
    end

    local tradeCompleted = Remotes:FindFirstChild("TradeCompleted")
    if tradeCompleted and tradeCompleted:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = tradeCompleted.OnClientEvent:Connect(function()
            clearLocalTradeState()
            showToast("Trade completed", "success")
            if window.Enabled then
                disconnectUi()
                wireWindow()
            end
        end)
    end

    local tradeCancelled = Remotes:FindFirstChild("TradeCancelled")
    if tradeCancelled and tradeCancelled:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = tradeCancelled.OnClientEvent:Connect(function()
            clearLocalTradeState()
            showToast("Trade cancelled or declined", "warning")
            if window.Enabled then
                disconnectUi()
                wireWindow()
            end
        end)
    end

    local errorRemote = Remotes:FindFirstChild("Error")
    if errorRemote and errorRemote:IsA("RemoteEvent") then
        globalConnections[#globalConnections + 1] = errorRemote.OnClientEvent:Connect(function(message)
            showToast(tostring(message), "error")
        end)
    end
end

window:GetPropertyChangedSignal("Enabled"):Connect(function()
    disconnectUi()
    if window.Enabled then
        wireWindow()
    end
end)

wireServerEvents()
if window.Enabled then
    wireWindow()
end

print("[TradeController] Initialized")
