--!strict
-- EventController: renders active events from the server and keeps their
-- remaining time truthful when the screen is opened after an event began.

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local toast = require(script.Parent.Components.Toast)

local screen = screens:FindFirstChild("EventScreen")
if not screen then
    return nil
end
local mainFrame = screen:FindFirstChild("MainFrame")
local eventList = mainFrame and mainFrame:FindFirstChild("EventList")
if not mainFrame or not mainFrame:IsA("Frame") or not eventList or not eventList:IsA("ScrollingFrame") then
    return nil
end

local template = eventList:FindFirstChild("EventTemplate")
if not template or not template:IsA("Frame") then
    return nil
end

local rows: { Frame } = {}
local toastHost: any = nil

local function showToast(message: string, kind: any)
    if toastHost then
        toastHost.Queue({ Text = message, Type = kind })
    else
        toastHost = toast.enqueue(screen, { Text = message, Type = kind })
    end
end

local descriptions: { [string]: string } = {
    DoubleXP = "All experience gains are doubled.",
    ResourceRush = "Harvest yields are increased during the rush.",
    PetWeekend = "Creature encounters receive a weekend bonus.",
    GuildWars = "Guild competition is active across the world.",
    HarvestFestival = "Festival nodes grant increased harvest yields.",
}

local function formatTime(seconds: number): string
    local remaining = math.max(0, math.floor(seconds))
    local hours = math.floor(remaining / 3600)
    local minutes = math.floor((remaining % 3600) / 60)
    local secondsPart = remaining % 60
    return string.format("%02d:%02d:%02d", hours, minutes, secondsPart)
end

local function fetchEvents(): { any }
    local remote = remotes:FindFirstChild("GetActiveEvents")
    if not remote or not remote:IsA("RemoteFunction") then
        return {}
    end
    local ok, result = pcall(function()
        return remote:InvokeServer()
    end)
    return if ok and type(result) == "table" then result else {}
end

local function clearRows()
    for _, row in ipairs(rows) do
        row:Destroy()
    end
    table.clear(rows)
end

local function render(events: { any })
    clearRows()
    eventList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local empty = eventList:FindFirstChild("EmptyState")
    if empty and empty:IsA("TextLabel") then
        empty.Visible = #events == 0
    end
    for index, event in ipairs(events) do
        local row = template:Clone()
        row.Name = "Event_" .. tostring(event.Id or index)
        local endTime = (tonumber(event.StartTime) or os.time()) + (tonumber(event.Duration) or 0)
        row:SetAttribute("EndTime", endTime)
        row.Visible = true
        row.LayoutOrder = index
        local name = row:FindFirstChild("EventName")
        local time = row:FindFirstChild("EventTime")
        local description = row:FindFirstChild("EventDesc")
        local join = row:FindFirstChild("JoinButton")
        if name and name:IsA("TextLabel") then
            name.Text = tostring(event.Type or "Aether Event")
        end
        if time and time:IsA("TextLabel") then
            time.Text = formatTime(endTime - os.time())
        end
        if description and description:IsA("TextLabel") then
            description.Text = descriptions[event.Type] or "A limited-time Aether event is active."
        end
        if join and join:IsA("TextButton") then
            join.Text = "ACTIVE"
            join.Active = false
            join.AutoButtonColor = false
        end
        row.Parent = eventList
        table.insert(rows, row)
    end
end

local function refresh()
    if screen.Enabled then
        render(fetchEvents())
    end
end

local eventStarted = remotes:FindFirstChild("EventStarted")
if eventStarted and eventStarted:IsA("RemoteEvent") then
    eventStarted.OnClientEvent:Connect(function(event)
        showToast("Event started: " .. tostring(event and event.Type or "Aether Event"), "info")
        refresh()
    end)
end
local eventEnded = remotes:FindFirstChild("EventEnded")
if eventEnded and eventEnded:IsA("RemoteEvent") then
    eventEnded.OnClientEvent:Connect(refresh)
end
local errorRemote = remotes:FindFirstChild("Error")
if errorRemote and errorRemote:IsA("RemoteEvent") then
    errorRemote.OnClientEvent:Connect(function(message)
        showToast(tostring(message), "error")
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        render(fetchEvents())
    else
        clearRows()
    end
end)

task.spawn(function()
    while screen.Parent do
        task.wait(1)
        if screen.Enabled then
            for _, row in ipairs(rows) do
                local time = row:FindFirstChild("EventTime")
                local endTime = row:GetAttribute("EndTime")
                if type(endTime) == "number" and time and time:IsA("TextLabel") then
                    time.Text = formatTime(endTime - os.time())
                end
            end
        end
    end
end)

if screen.Enabled then
    render(fetchEvents())
end
print("[EventController] Initialized")
