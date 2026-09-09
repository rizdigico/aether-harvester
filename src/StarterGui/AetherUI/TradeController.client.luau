--!strict
-- TradeController: wires the TradeWindow screen to TradingService remotes.
--
-- Recovery notes (do not delete):
--   * No GetActiveTrades remote exists in Remotes.model.json -- TradingService
--     exposes GetActiveTrades() server-side only. So we SKIP active-trade listing
--     and rely on server events (TradeCreated/TradeCompleted/TradeCancelled) for
--     tradeId-driven create/accept/cancel + toasts.
--   * TradeWindow has NO Accept or Cancel buttons and NO request-items entry in the
--     recovered Screens.luau. We wire ConfirmButton -> CreateTrade and expose
--     TradeController.Accept(tradeId) / TradeController.Cancel(tradeId) so a future
--     Accept/Cancel UI (or a TradeListing flow) can drive AcceptTrade/CancelTrade.
--   * Offer items are built from GetInventory (map { [itemId] = count }) and selected
--     by clicking dynamic rows parented under TradeWindow.MainFrame.TradeSlots.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local AetherUI = playerGui:WaitForChild("AetherUI")
local Screens = AetherUI:WaitForChild("Screens")
local Shared = ReplicatedStorage:WaitForChild("AetherShared")
local Remotes = Shared:WaitForChild("Remotes")
local ItemsData = require(Shared:WaitForChild("Data"):WaitForChild("Items"))
local Toast = require(script.Parent.Components.Toast)

local window = Screens:FindFirstChild("TradeWindow")
if not window then
    return nil
end

local TradeController = {}

local conns: { RBXScriptConnection } = {}
local toastHost: any = nil
local offerMap: { [string]: number } = {}
local offerRows: { TextButton } = {}

local function disconnectAll()
    for _, c in conns do
        c:Disconnect()
    end
    table.clear(conns)
    for _, row in offerRows do
        row:Destroy()
    end
    table.clear(offerRows)
    table.clear(offerMap)
    if toastHost then
        toastHost.Destroy()
        toastHost = nil
    end
end

local function showToast(text: string, toastType)
    if toastHost then
        toastHost.Queue({ Text = text, Type = toastType })
    else
        toastHost = Toast.enqueue(window, { Text = text, Type = toastType })
    end
end

local function mainFrame(): Instance?
    return window:FindFirstChild("MainFrame")
end

local function refreshOfferList()
    for _, row in offerRows do
        row:Destroy()
    end
    table.clear(offerRows)

    local GetInventory = Remotes:FindFirstChild("GetInventory")
    if not GetInventory then
        return
    end
    local ok, inv = pcall(function()
        return GetInventory:InvokeServer()
    end)
    if not ok or type(inv) ~= "table" then
        return
    end

    local frame = mainFrame()
    if not frame then
        return
    end
    local slots = frame:FindFirstChild("TradeSlots")
    if not slots then
        return
    end

    local order = {}
    for itemId in pairs(inv) do
        table.insert(order, itemId)
    end
    table.sort(order)

    for _, itemId in ipairs(order) do
        local count: number = inv[itemId]
        local def = ItemsData.GetItem(itemId)
        local name = (def and def.Name) or itemId

        local row = Instance.new("TextButton")
        row.Name = "OfferRow_" .. itemId
        row.Size = UDim2.new(1, -8, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(33, 37, 54)
        row.Text = string.format("%s x%d", name, count)
        row.TextColor3 = Color3.fromRGB(230, 235, 245)
        row.Font = Enum.Font.GothamMedium
        row.TextSize = 14
        row.BorderSizePixel = 0

        local selected = false
        row.MouseButton1Click:Connect(function()
            selected = not selected
            if selected then
                offerMap[itemId] = count
                row.BackgroundColor3 = Color3.fromRGB(60, 120, 90)
            else
                offerMap[itemId] = nil
                row.BackgroundColor3 = Color3.fromRGB(33, 37, 54)
            end
        end)

        row.Parent = slots
        table.insert(offerRows, row)
    end
end

function TradeController.Accept(tradeId: string)
    local AcceptTrade = Remotes:FindFirstChild("AcceptTrade")
    if AcceptTrade then
        AcceptTrade:FireServer(tradeId)
    end
end

function TradeController.Cancel(tradeId: string)
    local CancelTrade = Remotes:FindFirstChild("CancelTrade")
    if CancelTrade then
        CancelTrade:FireServer(tradeId)
    end
end

local function wireCreateButton()
    local frame = mainFrame()
    if not frame then
        return
    end
    local createBtn = frame:FindFirstChild("ConfirmButton")
    if not createBtn or not createBtn:IsA("TextButton") then
        return
    end
    conns[#conns + 1] = createBtn.MouseButton1Click:Connect(function()
        -- Request items: no dedicated entry exists in the recovered UI, so default empty.
        local requestItems: { [string]: number } = {}
        local CreateTrade = Remotes:FindFirstChild("CreateTrade")
        if not CreateTrade then
            return
        end
        if next(offerMap) == nil then
            showToast("Select items to offer first", "warning")
            return
        end
        CreateTrade:FireServer(offerMap, requestItems)
        showToast("Trade offer sent", "info")
    end)
end

local function wireServerEvents()
    local TradeCreated = Remotes:FindFirstChild("TradeCreated")
    if TradeCreated then
        conns[#conns + 1] = TradeCreated.OnClientEvent:Connect(function(trade)
            local id = trade and trade.Id or ""
            showToast("Trade created: " .. id, "success")
        end)
    end
    local TradeCompleted = Remotes:FindFirstChild("TradeCompleted")
    if TradeCompleted then
        conns[#conns + 1] = TradeCompleted.OnClientEvent:Connect(function()
            showToast("Trade completed", "success")
        end)
    end
    local TradeCancelled = Remotes:FindFirstChild("TradeCancelled")
    if TradeCancelled then
        conns[#conns + 1] = TradeCancelled.OnClientEvent:Connect(function()
            showToast("Trade cancelled", "warning")
        end)
    end
    local Error = Remotes:FindFirstChild("Error")
    if Error then
        conns[#conns + 1] = Error.OnClientEvent:Connect(function(message)
            showToast(tostring(message), "error")
        end)
    end
end

-- Gate wiring on window Enabled (matches ScreenController onScreenEnabled pattern).
window:GetPropertyChangedSignal("Enabled"):Connect(function()
    if window.Enabled then
        disconnectAll()
        refreshOfferList()
        wireCreateButton()
        wireServerEvents()
    else
        disconnectAll()
    end
end)

-- Wire immediately if the window is already enabled when this script runs.
if window.Enabled then
    disconnectAll()
    refreshOfferList()
    wireCreateButton()
    wireServerEvents()
end

print("[TradeController] Initialized")
