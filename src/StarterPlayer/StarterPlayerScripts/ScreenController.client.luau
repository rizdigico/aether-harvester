-- ScreenController: populates per-screen content (Inventory, Quests, Pets) when screens open
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local AetherUI = playerGui:WaitForChild("AetherUI")
local Shared = ReplicatedStorage:WaitForChild("AetherShared")
local Remotes = Shared:WaitForChild("Remotes")
local ItemsData = require(Shared:WaitForChild("Data"):WaitForChild("Items"))
local PetsData = require(Shared:WaitForChild("Data"):WaitForChild("Pets"))
local Screens = AetherUI:WaitForChild("Screens")

local ScreenController = {}

local RARITY_COLORS = {
    Common = Color3.fromRGB(180, 180, 180),
    Uncommon = Color3.fromRGB(100, 200, 120),
    Rare = Color3.fromRGB(100, 160, 255),
    Epic = Color3.fromRGB(190, 120, 255),
    Legendary = Color3.fromRGB(255, 190, 60),
}

local TAB_TYPES = {
    TabItems = "Tool",
    TabEquipment = "Consumable",
    TabResources = "Resource",
    TabCrafting = "Material",
}

function ScreenController:PopulateInventory(activeTab)
    local screen = Screens:FindFirstChild("InventoryScreen")
    if not screen then
        return
    end
    local content = screen:FindFirstChild("Content", true)
    if not content or not content:IsA("ScrollingFrame") then
        return
    end

    local template = content:FindFirstChild("ItemTemplate")
    if template then
        for _, child in ipairs(content:GetChildren()) do
            if child ~= template and child.Name ~= "EmptyState" then
                child:Destroy()
            end
        end
    end

    local GetInventory = Remotes:FindFirstChild("GetInventory")
    if not GetInventory then
        return
    end
    local ok, inv = pcall(function()
        return GetInventory:InvokeServer()
    end)
    if not ok or not inv then
        return
    end

    local entries = {}
    local tabType = TAB_TYPES[activeTab]
    for itemId, count in pairs(inv) do
        local def = ItemsData.GetItem(itemId)
        if not tabType or (def and def.Type == tabType) then
            table.insert(entries, { Id = itemId, Count = count, Def = def })
        end
    end
    table.sort(entries, function(a, b)
        return a.Id < b.Id
    end)

    local empty = content:FindFirstChild("EmptyState")
    if empty and empty:IsA("TextLabel") then
        empty.Text = "Your inventory is empty"
    end
    if #entries == 0 then
        if empty then
            empty.Visible = true
        end
        return
    end
    if empty then
        empty.Visible = false
    end
    if not template then
        return
    end

    for index, entry in ipairs(entries) do
        local item = template:Clone()
        item.Name = "Item_" .. entry.Id
        item.Visible = true
        item.LayoutOrder = index

        local name = item:FindFirstChild("ItemName")
        local count = item:FindFirstChild("ItemCount")
        local icon = item:FindFirstChild("Icon")

        local displayName = (entry.Def and entry.Def.Name) or entry.Id
        local color = (entry.Def and entry.Def.Color) or Color3.fromRGB(150, 150, 150)
        local rarity = (entry.Def and entry.Def.Rarity) or "Common"

        if name then
            name.Text = displayName
        end
        if count then
            count.Text = "x" .. tostring(entry.Count)
        end
        if icon then
            icon.BackgroundColor3 = color
        end

        local stroke = item:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = RARITY_COLORS[rarity] or RARITY_COLORS.Common
        end

        item.Parent = content
    end
end

function ScreenController:PopulateQuests()
    local screen = Screens:FindFirstChild("QuestLogScreen")
    if not screen then
        return
    end
    local list = screen:FindFirstChild("QuestList", true)
    if not list then
        return
    end
    local template = list:FindFirstChild("QuestTemplate")

    if template then
        for _, child in ipairs(list:GetChildren()) do
            if child ~= template then
                child:Destroy()
            end
        end
    end

    local GetQuests = Remotes:FindFirstChild("GetQuests")
    if not GetQuests then
        return
    end
    local ok, quests = pcall(function()
        return GetQuests:InvokeServer()
    end)
    if not ok or not quests then
        return
    end

    for id, data in pairs(quests) do
        local q = template and template:Clone()
        if q then
            q.Name = "Quest_" .. id
            q.Visible = true
            local title = q:FindFirstChild("QuestName")
            local desc = q:FindFirstChild("QuestDesc")
            local progress = q:FindFirstChild("QuestProgress")
            local check = q:FindFirstChild("QuestCheck")
            if title then
                title.Text = data.Title or id
            end
            if desc then
                desc.Text = data.Description or ""
            end
            -- Progress: sum objectives, compare against total target amount
            local total = 0
            local done = 0
            for i, obj in ipairs(data.Objectives or {}) do
                local amt = obj.Amount or obj.Target or 1
                total += amt
                done += math.min((data.Progress and data.Progress[i]) or 0, amt)
            end
            if progress then
                progress.Text = tostring(done) .. " / " .. tostring(total)
            end
            if check then
                check.Text = (data.Completed and "✓") or ""
            end
            q.Parent = list
        end
    end
end

function ScreenController:PopulatePets()
    local screen = Screens:FindFirstChild("PetScreen")
    if not screen then
        return
    end
    local scroll = screen:FindFirstChild("PetScroll", true)
    if not scroll then
        return
    end
    local template = scroll:FindFirstChild("PetTemplate")

    if template then
        for _, child in ipairs(scroll:GetChildren()) do
            if child ~= template then
                child:Destroy()
            end
        end
    end

    local GetPets = Remotes:FindFirstChild("GetPets")
    if not GetPets then
        return
    end
    local ok, pets = pcall(function()
        return GetPets:InvokeServer()
    end)
    if not ok or not pets then
        return
    end

    for _, pet in ipairs(pets) do
        local p = template and template:Clone()
        if p then
            p.Name = "Pet_" .. tostring(pet.PetId) .. "_" .. tostring(pet.InstanceId or "legacy")
            p.Visible = true
            local def = PetsData.GetPet(pet.PetId)
            local pname = p:FindFirstChild("PetName")
            local plvl = p:FindFirstChild("PetLevel")
            local prarity = p:FindFirstChild("PetRarity")
            local active = p:FindFirstChild("PetActiveBadge")
            if pname then
                pname.Text = (def and def.Name) or pet.PetId
            end
            if plvl then
                plvl.Text = "Lv. " .. tostring(pet.Level or 1)
            end
            if prarity and def then
                prarity.Text = def.Rarity or ""
            end
            if active then
                active.Visible = pet.IsEquipped == true
            end

            local petKey = pet.InstanceId or pet.PetId
            local equipButton = p:FindFirstChild("PetEquipBtn")
            if equipButton and equipButton:IsA("TextButton") then
                equipButton.Text = pet.IsEquipped and "Unequip" or "Equip"
                equipButton.Activated:Connect(function()
                    local remoteName = pet.IsEquipped and "UnequipPet" or "EquipPet"
                    local remote = Remotes:FindFirstChild(remoteName)
                    if remote then
                        remote:FireServer(petKey)
                        task.delay(0.15, function()
                            if screen.Enabled then
                                ScreenController:PopulatePets()
                            end
                        end)
                    end
                end)

                local feedButton = p:FindFirstChild("PetFeedBtn")
                if not feedButton then
                    feedButton = equipButton:Clone()
                    feedButton.Name = "PetFeedBtn"
                    feedButton.Text = "Feed"
                    feedButton.Position = UDim2.new(0.58, 0, 0.27, 0)
                    feedButton.Size = UDim2.new(0.4, 0, 0.25, 0)
                    feedButton.Parent = p
                end
                if feedButton:IsA("TextButton") then
                    feedButton.Activated:Connect(function()
                        local feedRemote = Remotes:FindFirstChild("FeedPet")
                        if feedRemote then
                            feedRemote:FireServer(petKey)
                            task.delay(0.15, function()
                                if screen.Enabled then
                                    ScreenController:PopulatePets()
                                end
                            end)
                        end
                    end)
                end
            end
            p.Parent = scroll
        end
    end
end

-- Watch screen Enabled changes (GameClient:OpenScreen sets Enabled directly)
local function onScreenEnabled(screenName, populateFn)
    local screen = Screens:FindFirstChild(screenName)
    if not screen then
        return
    end
    screen:GetPropertyChangedSignal("Enabled"):Connect(function()
        if screen.Enabled then
            task.defer(populateFn)
        end
    end)
end
onScreenEnabled("InventoryScreen", function()
    ScreenController:PopulateInventory(nil)
end)
onScreenEnabled("QuestLogScreen", function()
    ScreenController:PopulateQuests()
end)
onScreenEnabled("PetScreen", function()
    ScreenController:PopulatePets()
end)

local invScreen = Screens:FindFirstChild("InventoryScreen")
if invScreen then
    local tabBar = invScreen:FindFirstChild("TabBar", true)
    if tabBar then
        for _, tab in ipairs(tabBar:GetChildren()) do
            if tab:IsA("TextButton") then
                if tab.Name ~= "TabCrafting" then
                    tab.MouseButton1Click:Connect(function()
                        ScreenController:PopulateInventory(tab.Name)
                    end)
                end
            end
        end
    end
end

print("[ScreenController] Initialized")
