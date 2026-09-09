--!strict
-- MapController: turns the recovered map markers into server-validated travel
-- controls. The client only requests an island; WorldManager decides whether
-- that island is actually playable.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local aetherUI = playerGui:WaitForChild("AetherUI")
local screens = aetherUI:WaitForChild("Screens")
local shared = ReplicatedStorage:WaitForChild("AetherShared")
local remotes = shared:WaitForChild("Remotes")
local toast = require(script.Parent.Components.Toast)

local screen = screens:FindFirstChild("MapScreen")
if not screen then
    return nil
end

local panel = screen:FindFirstChild("Panel")
local mapContent = panel and panel:FindFirstChild("MapContent")
local mapBackground = mapContent and mapContent:FindFirstChild("MapBG")
if
    not panel
    or not panel:IsA("Frame")
    or not mapContent
    or not mapContent:IsA("Frame")
    or not mapBackground
    or not mapBackground:IsA("Frame")
then
    return nil
end

local markerButtons: { TextButton } = {}
local uiConnections: { RBXScriptConnection } = {}
local toastHost: any = nil

local positions: { [string]: UDim2 } = {
    SpawnIsland = UDim2.fromScale(0.12, 0.52),
    CloudGardens = UDim2.fromScale(0.2, 0.2),
    StormPeaks = UDim2.fromScale(0.38, 0.12),
    VoidRifts = UDim2.fromScale(0.8, 0.2),
    CrystalCanyons = UDim2.fromScale(0.5, 0.3),
    AncientRuins = UDim2.fromScale(0.3, 0.7),
    FloatingMarket = UDim2.fromScale(0.7, 0.7),
    CrystalSpires = UDim2.fromScale(0.58, 0.52),
    EmberPeaks = UDim2.fromScale(0.82, 0.55),
    VerdantIsle = UDim2.fromScale(0.12, 0.78),
    SkySanctum = UDim2.fromScale(0.5, 0.82),
}

local displayNames: { [string]: string } = {
    SpawnIsland = "Spawn Island",
    CloudGardens = "Cloud Gardens",
    StormPeaks = "Storm Peaks",
    VoidRifts = "Void Rifts",
    CrystalCanyons = "Crystal Canyons",
    AncientRuins = "Ancient Ruins",
    FloatingMarket = "Floating Market",
    CrystalSpires = "Crystal Spires",
    EmberPeaks = "Ember Peaks",
    VerdantIsle = "Verdant Isle",
    SkySanctum = "Sky Sanctum",
}

local function showToast(message: string, kind: any)
    if toastHost then
        toastHost.Queue({ Text = message, Type = kind })
    else
        toastHost = toast.enqueue(screen, { Text = message, Type = kind })
    end
end

local function clearMarkers()
    for _, connection in ipairs(uiConnections) do
        connection:Disconnect()
    end
    table.clear(uiConnections)
    for _, marker in ipairs(markerButtons) do
        marker:Destroy()
    end
    table.clear(markerButtons)
end

local function getLocationLabel(): TextLabel?
    local label = mapContent:FindFirstChild("LocationMarker")
    if label and label:IsA("TextLabel") then
        return label
    end
    return nil
end

local function getPlayableIds(): { string }
    local ids: { string } = {}
    local world = workspace:FindFirstChild("AetherWorld")
    local islands = world and world:FindFirstChild("Islands")
    if islands then
        for _, island in ipairs(islands:GetChildren()) do
            if positions[island.Name] then
                table.insert(ids, island.Name)
            end
        end
    end
    table.sort(ids, function(first, second)
        return (displayNames[first] or first) < (displayNames[second] or second)
    end)
    return ids
end

local function render()
    clearMarkers()
    local locationLabel = getLocationLabel()
    if locationLabel then
        locationLabel.Text = "Select a discovered island to travel"
    end

    local ids = getPlayableIds()
    for index, islandId in ipairs(ids) do
        local marker = Instance.new("TextButton")
        marker.Name = "Travel_" .. islandId
        marker.AnchorPoint = Vector2.new(0.5, 0.5)
        marker.Position = positions[islandId]
        marker.Size = UDim2.fromScale(0.12, 0.09)
        marker.BackgroundColor3 = Color3.fromRGB(47, 54, 77)
        marker.BorderSizePixel = 0
        marker.TextColor3 = Color3.fromRGB(230, 235, 245)
        marker.Font = Enum.Font.GothamMedium
        marker.TextSize = 11
        marker.TextWrapped = true
        marker.Text = displayNames[islandId] or islandId
        marker.LayoutOrder = index
        marker.Parent = mapBackground
        table.insert(markerButtons, marker)
        uiConnections[#uiConnections + 1] = marker.MouseButton1Click:Connect(function()
            local changeIsland = remotes:FindFirstChild("ChangeIsland")
            if not changeIsland or not changeIsland:IsA("RemoteEvent") then
                showToast("Travel is unavailable", "error")
                return
            end
            marker.Active = false
            marker.Text = "TRAVELLING..."
            changeIsland:FireServer(islandId)
            task.delay(2, function()
                if marker.Parent then
                    marker.Active = true
                    marker.Text = displayNames[islandId] or islandId
                end
            end)
        end)
    end
end

local updateHUD = remotes:FindFirstChild("UpdateHUD")
if updateHUD and updateHUD:IsA("RemoteEvent") then
    updateHUD.OnClientEvent:Connect(function(data)
        if type(data) == "table" and type(data.Island) == "string" then
            local label = getLocationLabel()
            if label then
                label.Text = "Current: " .. data.Island
            end
        end
    end)
end

screen:GetPropertyChangedSignal("Enabled"):Connect(function()
    if screen.Enabled then
        render()
    else
        clearMarkers()
    end
end)

if screen.Enabled then
    render()
end

print("[MapController] Initialized")
