--!strict
-- Screens: deterministic recreation of StarterGui.AetherUI.Screens
-- Generated from artifacts/recovery/StarterGui_AetherUI_Screens_*.json

local AetherUI = script.Parent
local Screens = Instance.new("Folder")
Screens.Name = "Screens"

do
    local inst = Instance.new("ScreenGui")
    inst.Name = "HUD"
    inst.Parent = AetherUI
    do
        local inst = Instance.new("Frame")
        inst.Name = "EnergyBar"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.30000001192092896
        inst.Position = UDim2.new(0.0199999996, 0, 0.0199999996, 0)
        inst.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.180000007, 0, 0.0250000004, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "Fill"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(1.0, 0.654902, 0.14902)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 1, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "HealthBar"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.30000001192092896
        inst.Position = UDim2.new(0.0199999996, 0, 0.0549999997, 0)
        inst.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.180000007, 0, 0.0250000004, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "Fill"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.898039, 0.223529, 0.207843)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 1, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "NotificationArea"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.75, 0, 0.0199999996, 0)
        inst.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.25, 0, 0.0399999991, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("TextLabel")
            inst.Name = "Notification"
            inst.Visible = false
            inst.TextWrapped = true
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.ZIndex = 1
            inst.BorderSizePixel = 1
            inst.Size = UDim2.new(1, 0, 1, 0)
            inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
            inst.LayoutOrder = 0
            inst.Text = ""
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.TextSize = 20
            inst.Rotation = 0
            inst.Font = Enum.Font.GothamMedium
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.TextXAlignment = Enum.TextXAlignment.Left
            inst.TextYAlignment = Enum.TextYAlignment.Center
            inst.TextScaled = true
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("TextLabel")
        inst.Name = "QuestTracker"
        inst.Visible = true
        inst.TextWrapped = true
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.25, 0, 0.0350000001, 0)
        inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
        inst.LayoutOrder = 0
        inst.Text = "No active quest"
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.TextSize = 18
        inst.Rotation = 0
        inst.Font = Enum.Font.Gotham
        inst.BackgroundTransparency = 0.30000001192092896
        inst.Position = UDim2.new(0.75, 0, 0.0700000003, 0)
        inst.TextXAlignment = Enum.TextXAlignment.Left
        inst.TextYAlignment = Enum.TextYAlignment.Center
        inst.TextScaled = true
        inst.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "MinimapFrame"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.879999995, 0, 0.879999995, 0)
        inst.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.119999997, 0, 0.119999997, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "Background"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0.5
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 1, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "PlayerDot"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.5, -8, 0.5, -8)
            inst.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.0299999993, 0, 0.0299999993, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
        end
    end
    do
        local inst = Instance.new("TextLabel")
        inst.Name = "LevelDisplay"
        inst.Visible = true
        inst.TextWrapped = false
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.ZIndex = 5
        inst.BorderSizePixel = 1
        inst.Size = UDim2.new(0.119999997, 0, 0.0350000001, 0)
        inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
        inst.LayoutOrder = 0
        inst.Text = "Lv. 1"
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.TextScaled = true
        inst.Rotation = 0
        inst.Font = Enum.Font.GothamBold
        inst.BackgroundTransparency = 0.5
        inst.Position = UDim2.new(0.0199999996, 0, 0.0900000036, 0)
        inst.TextXAlignment = Enum.TextXAlignment.Center
        inst.TextYAlignment = Enum.TextYAlignment.Center
        inst.TextScaled = false
        inst.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("TextLabel")
        inst.Name = "CurrencyDisplay"
        inst.Visible = true
        inst.TextWrapped = false
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.ZIndex = 5
        inst.BorderSizePixel = 1
        inst.Size = UDim2.new(0.150000006, 0, 0.0350000001, 0)
        inst.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
        inst.LayoutOrder = 0
        inst.Text = "Shards: 0"
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.TextScaled = true
        inst.Rotation = 0
        inst.Font = Enum.Font.GothamBold
        inst.BackgroundTransparency = 0.5
        inst.Position = UDim2.new(0.159999996, 0, 0.0900000036, 0)
        inst.TextXAlignment = Enum.TextXAlignment.Center
        inst.TextYAlignment = Enum.TextYAlignment.Center
        inst.TextScaled = false
        inst.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("TextLabel")
        inst.Name = "ToolDisplay"
        inst.Visible = true
        inst.TextWrapped = false
        inst.AnchorPoint = Vector2.new(0, 1)
        inst.ZIndex = 5
        inst.BorderSizePixel = 1
        inst.Size = UDim2.new(0.119999997, 0, 0.0350000001, 0)
        inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
        inst.LayoutOrder = 0
        inst.Text = "Tool: None"
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.TextScaled = true
        inst.Rotation = 0
        inst.Font = Enum.Font.GothamBold
        inst.BackgroundTransparency = 0.5
        inst.Position = UDim2.new(0.0199999996, 0, 0.944999993, 0)
        inst.TextXAlignment = Enum.TextXAlignment.Center
        inst.TextYAlignment = Enum.TextYAlignment.Center
        inst.TextScaled = false
        inst.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("TextLabel")
        inst.Name = "ActiveCreature"
        inst.Visible = true
        inst.TextWrapped = false
        inst.AnchorPoint = Vector2.new(0, 1)
        inst.ZIndex = 5
        inst.BorderSizePixel = 1
        inst.Size = UDim2.new(0.119999997, 0, 0.0350000001, 0)
        inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
        inst.LayoutOrder = 0
        inst.Text = "Pet: None"
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.TextScaled = true
        inst.Rotation = 0
        inst.Font = Enum.Font.GothamBold
        inst.BackgroundTransparency = 0.5
        inst.Position = UDim2.new(0.159999996, 0, 0.944999993, 0)
        inst.TextXAlignment = Enum.TextXAlignment.Center
        inst.TextYAlignment = Enum.TextYAlignment.Center
        inst.TextScaled = false
        inst.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "EventScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "MainFrame"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.125, 0, 0.150000006, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.75, 0, 0.699999988, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "EVENTS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("ScrollingFrame")
            inst.Name = "EventList"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIListLayout")
                inst.Name = "UIListLayout"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "EmptyState"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "No active events"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "EventTemplate"
                inst.Visible = false
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.949999988, 0, 0.150000006, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "EventName"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.600000024, 0, 0.400000006, 0)
                    inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst.LayoutOrder = 0
                    inst.Text = "Event Name"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 14
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamMedium
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.0299999993, 0, 0.0500000007, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Left
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "EventTime"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.300000012, 0, 0.400000006, 0)
                    inst.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst.LayoutOrder = 0
                    inst.Text = "02:00:00"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 12
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamBold
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.649999976, 0, 0.0500000007, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Right
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "EventDesc"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.899999976, 0, 0.300000012, 0)
                    inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                    inst.LayoutOrder = 0
                    inst.Text = "Event description..."
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 12
                    inst.Rotation = 0
                    inst.Font = Enum.Font.Gotham
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.0299999993, 0, 0.5, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Left
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextButton")
                    inst.Name = "JoinButton"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.200000003, 0, 0.300000012, 0)
                    inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                    inst.LayoutOrder = 0
                    inst.Text = "JOIN"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 12
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamMedium
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0.779999971, 0, 0.600000024, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Center
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIStroke")
                        inst.Name = "UIStroke"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIGradient")
                        inst.Name = "UIGradient"
                        inst.Parent = inst
                    end
                end
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "GuildScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "MainFrame"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.150000006, 0, 0.100000001, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "GUILD"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "GuildInfo"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.150000006, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "GuildName"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
                inst.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst.LayoutOrder = 0
                inst.Text = "No Guild"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0.100000001, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "GuildLevel"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "Lv. 1"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.550000012, 0, 0.100000001, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "GuildXPBar"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.0500000007, 0, 0.550000012, 0)
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.300000012, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "GuildXPFill"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0, 0, 0, 0)
                    inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.300000012, 0, 1, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UIGradient")
                        inst.Name = "UIGradient"
                        inst.Parent = inst
                    end
                end
            end
        end
        do
            local inst = Instance.new("ScrollingFrame")
            inst.Name = "MemberList"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.230000004, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.600000024, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIListLayout")
                inst.Name = "UIListLayout"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "EmptyState"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "No guild members"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "InventoryScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "Panel"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "INVENTORY"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TabBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.0500000007, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "TabItems"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst.LayoutOrder = 0
                inst.Text = "ITEMS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0.30000001192092896
                inst.Position = UDim2.new(0, 0, 0.100000001, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "TabEquipment"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst.LayoutOrder = 0
                inst.Text = "EQUIPMENT"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0.800000011920929
                inst.Position = UDim2.new(0.25, 0, 0.100000001, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "TabResources"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst.LayoutOrder = 0
                inst.Text = "RESOURCES"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0.800000011920929
                inst.Position = UDim2.new(0.5, 0, 0.100000001, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "TabCrafting"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst.LayoutOrder = 0
                inst.Text = "CRAFTING"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0.800000011920929
                inst.Position = UDim2.new(0.75, 0, 0.100000001, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("ScrollingFrame")
            inst.Name = "Content"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGridLayout")
                inst.Name = "UIGridLayout"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "EmptyState"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "Your inventory is empty"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "ItemTemplate"
                inst.Visible = false
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.200000003, 0, 0.200000003, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("ImageLabel")
                    inst.Name = "Icon"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.324999988, 0, 0.0500000007, 0)
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.349999994, 0, 0.349999994, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "ItemName"
                    inst.Visible = true
                    inst.TextWrapped = false
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
                    inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst.LayoutOrder = 0
                    inst.Text = "Item Name"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 11
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamMedium
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.100000001, 0, 0.419999987, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Left
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = false
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "ItemCount"
                    inst.Visible = true
                    inst.TextWrapped = false
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
                    inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                    inst.LayoutOrder = 0
                    inst.Text = "x1"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 10
                    inst.Rotation = 0
                    inst.Font = Enum.Font.Gotham
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.100000001, 0, 0.649999976, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Left
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = false
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "MainMenu"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "Panel"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.224999994, 0, 0.150000006, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.550000012, 0, 0.699999988, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "AETHER HARVESTER"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 32
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "PlayerInfo"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.00499999989, 0, 0.0799999982, 0)
            inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -10, 0.119999997, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "PlayerName"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.600000024, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "PlayerName"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "PlayerLevel"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.349999994, 0, 1, 0)
                inst.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst.LayoutOrder = 0
                inst.Text = "Lv. 1"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.629999995, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Right
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "NavContainer"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.219999999, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.550000012, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIListLayout")
                inst.Name = "UIListLayout"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "NavInventory"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "INVENTORY"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "NavQuests"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "QUESTS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "NavPets"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "PETS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "NavGuild"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "GUILD"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "NavSkillTree"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "SKILL TREE"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "NavMap"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "MAP"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "NavSettings"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "SETTINGS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
        end
    end
    do
        local inst = Instance.new("TextButton")
        inst.Name = "CloseButton"
        inst.Visible = true
        inst.TextWrapped = true
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.ZIndex = 1
        inst.BorderSizePixel = 1
        inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
        inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
        inst.LayoutOrder = 0
        inst.Text = "\u2715"
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.TextSize = 8
        inst.Rotation = 0
        inst.Font = Enum.Font.Gotham
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
        inst.TextXAlignment = Enum.TextXAlignment.Center
        inst.TextYAlignment = Enum.TextYAlignment.Center
        inst.TextScaled = true
        inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "MapScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "Panel"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "MAP"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "MapContent"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "MapBG"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0.5
                inst.Position = UDim2.new(0.0500000007, 0, 0.100000001, 0)
                inst.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.800000012, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "CloudGardensMarker"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0.200000003, 0, 0.200000003, 0)
                    inst.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIStroke")
                        inst.Name = "UIStroke"
                        inst.Parent = inst
                    end
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "CrystalCanyonMarker"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0.5, 0, 0.300000012, 0)
                    inst.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIStroke")
                        inst.Name = "UIStroke"
                        inst.Parent = inst
                    end
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "VoidAltarMarker"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0.800000012, 0, 0.200000003, 0)
                    inst.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIStroke")
                        inst.Name = "UIStroke"
                        inst.Parent = inst
                    end
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "AncientRuinsMarker"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0.300000012, 0, 0.699999988, 0)
                    inst.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIStroke")
                        inst.Name = "UIStroke"
                        inst.Parent = inst
                    end
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "FloatingMarketMarker"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0.699999988, 0, 0.699999988, 0)
                    inst.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIStroke")
                        inst.Name = "UIStroke"
                        inst.Parent = inst
                    end
                end
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "LocationMarker"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.899999976, 0, 0.0500000007, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "Current: CloudGardens"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "PetScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "Panel"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.150000006, 0, 0.100000001, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "PET COMPANION"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "PetList"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.349999994, 0, 0.829999983, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "PetListTitle"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, -10, 0.0500000007, 0)
                inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst.LayoutOrder = 0
                inst.Text = "YOUR PETS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("ScrollingFrame")
                inst.Name = "PetScroll"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(1, -10, 0.899999976, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UIListLayout")
                    inst.Name = "UIListLayout"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "PetTemplate"
                    inst.Visible = false
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0, 0, 0, 0)
                    inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.899999976, 0, 0.119999997, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UICorner")
                        inst.Name = "UICorner"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIStroke")
                        inst.Name = "UIStroke"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("UIGradient")
                        inst.Name = "UIGradient"
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("ImageLabel")
                        inst.Name = "PetIcon"
                        inst.Visible = true
                        inst.LayoutOrder = 0
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.Rotation = 0
                        inst.BackgroundTransparency = 1
                        inst.Position = UDim2.new(0.0199999996, 0, 0.150000006, 0)
                        inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 0
                        inst.Size = UDim2.new(0.150000006, 0, 0.699999988, 0)
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("TextLabel")
                        inst.Name = "PetName"
                        inst.Visible = true
                        inst.TextWrapped = true
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 1
                        inst.Size = UDim2.new(0.600000024, 0, 0.349999994, 0)
                        inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                        inst.LayoutOrder = 0
                        inst.Text = "Pet Name"
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.TextSize = 14
                        inst.Rotation = 0
                        inst.Font = Enum.Font.GothamMedium
                        inst.BackgroundTransparency = 1
                        inst.Position = UDim2.new(0.200000003, 0, 0.0500000007, 0)
                        inst.TextXAlignment = Enum.TextXAlignment.Left
                        inst.TextYAlignment = Enum.TextYAlignment.Center
                        inst.TextScaled = true
                        inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("TextLabel")
                        inst.Name = "PetLevel"
                        inst.Visible = true
                        inst.TextWrapped = true
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 1
                        inst.Size = UDim2.new(0.600000024, 0, 0.25, 0)
                        inst.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                        inst.LayoutOrder = 0
                        inst.Text = "Lv. 1"
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.TextSize = 12
                        inst.Rotation = 0
                        inst.Font = Enum.Font.Gotham
                        inst.BackgroundTransparency = 1
                        inst.Position = UDim2.new(0.200000003, 0, 0.419999987, 0)
                        inst.TextXAlignment = Enum.TextXAlignment.Left
                        inst.TextYAlignment = Enum.TextYAlignment.Center
                        inst.TextScaled = true
                        inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("TextLabel")
                        inst.Name = "PetRarity"
                        inst.Visible = true
                        inst.TextWrapped = true
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 1
                        inst.Size = UDim2.new(0.150000006, 0, 0.300000012, 0)
                        inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                        inst.LayoutOrder = 0
                        inst.Text = "COMMON"
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.TextSize = 10
                        inst.Rotation = 0
                        inst.Font = Enum.Font.Gotham
                        inst.BackgroundTransparency = 1
                        inst.Position = UDim2.new(0.829999983, 0, 0.0500000007, 0)
                        inst.TextXAlignment = Enum.TextXAlignment.Right
                        inst.TextYAlignment = Enum.TextYAlignment.Center
                        inst.TextScaled = true
                        inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("TextButton")
                        inst.Name = "PetEquipBtn"
                        inst.Visible = true
                        inst.TextWrapped = true
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 0
                        inst.Size = UDim2.new(0.400000006, 0, 0.300000012, 0)
                        inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                        inst.LayoutOrder = 0
                        inst.Text = "Equip"
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.TextSize = 12
                        inst.Rotation = 0
                        inst.Font = Enum.Font.GothamMedium
                        inst.BackgroundTransparency = 0
                        inst.Position = UDim2.new(0.579999983, 0, 0.600000024, 0)
                        inst.TextXAlignment = Enum.TextXAlignment.Center
                        inst.TextYAlignment = Enum.TextYAlignment.Center
                        inst.TextScaled = true
                        inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                        inst.Parent = inst
                        do
                            local inst = Instance.new("UICorner")
                            inst.Name = "UICorner"
                            inst.Parent = inst
                        end
                        do
                            local inst = Instance.new("UIStroke")
                            inst.Name = "UIStroke"
                            inst.Parent = inst
                        end
                        do
                            local inst = Instance.new("UIGradient")
                            inst.Name = "UIGradient"
                            inst.Parent = inst
                        end
                    end
                    do
                        local inst = Instance.new("TextLabel")
                        inst.Name = "PetActiveBadge"
                        inst.Visible = false
                        inst.TextWrapped = true
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 1
                        inst.Size = UDim2.new(0.150000006, 0, 0.300000012, 0)
                        inst.TextColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                        inst.LayoutOrder = 0
                        inst.Text = "EQUIPPED"
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.TextSize = 10
                        inst.Rotation = 0
                        inst.Font = Enum.Font.GothamBold
                        inst.BackgroundTransparency = 1
                        inst.Position = UDim2.new(0.829999983, 0, 0.600000024, 0)
                        inst.TextXAlignment = Enum.TextXAlignment.Right
                        inst.TextYAlignment = Enum.TextYAlignment.Center
                        inst.TextScaled = true
                        inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst.Parent = inst
                    end
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "PetDetail"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.370000005, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.600000024, 0, 0.829999983, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "DetailHeader"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, -10, 0.0599999987, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "PET DETAILS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "DetailStats"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0.0599999987, 0)
                inst.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(1, -10, 0.850000024, -10)
                inst.Parent = inst
                do
                    local inst = Instance.new("UIListLayout")
                    inst.Name = "UIListLayout"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "StatRow"
                    inst.Visible = false
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0, 0, 0, 0)
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(1, 0, 0.119999997, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("TextLabel")
                        inst.Name = "StatLabel"
                        inst.Visible = true
                        inst.TextWrapped = true
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 1
                        inst.Size = UDim2.new(0.400000006, 0, 1, 0)
                        inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                        inst.LayoutOrder = 0
                        inst.Text = "ATK"
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.TextSize = 12
                        inst.Rotation = 0
                        inst.Font = Enum.Font.Gotham
                        inst.BackgroundTransparency = 1
                        inst.Position = UDim2.new(0, 0, 0, 0)
                        inst.TextXAlignment = Enum.TextXAlignment.Left
                        inst.TextYAlignment = Enum.TextYAlignment.Center
                        inst.TextScaled = true
                        inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("TextLabel")
                        inst.Name = "StatValue"
                        inst.Visible = true
                        inst.TextWrapped = true
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 1
                        inst.Size = UDim2.new(0.5, 0, 1, 0)
                        inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                        inst.LayoutOrder = 0
                        inst.Text = "15"
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.TextSize = 12
                        inst.Rotation = 0
                        inst.Font = Enum.Font.GothamBold
                        inst.BackgroundTransparency = 1
                        inst.Position = UDim2.new(0.550000012, 0, 0, 0)
                        inst.TextXAlignment = Enum.TextXAlignment.Left
                        inst.TextYAlignment = Enum.TextYAlignment.Center
                        inst.TextScaled = true
                        inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst.Parent = inst
                    end
                    do
                        local inst = Instance.new("Frame")
                        inst.Name = "StatBar"
                        inst.Visible = true
                        inst.LayoutOrder = 0
                        inst.AutomaticSize = Enum.AutomaticSize.None
                        inst.AnchorPoint = Vector2.new(0, 0)
                        inst.Rotation = 0
                        inst.BackgroundTransparency = 0
                        inst.Position = UDim2.new(0.550000012, 0, 0.5, 0)
                        inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                        inst.ZIndex = 1
                        inst.BorderSizePixel = 0
                        inst.Size = UDim2.new(0.5, 0, 0.400000006, 0)
                        inst.Parent = inst
                        do
                            local inst = Instance.new("UICorner")
                            inst.Name = "UICorner"
                            inst.Parent = inst
                        end
                        do
                            local inst = Instance.new("Frame")
                            inst.Name = "StatBarFill"
                            inst.Visible = true
                            inst.LayoutOrder = 0
                            inst.AutomaticSize = Enum.AutomaticSize.None
                            inst.AnchorPoint = Vector2.new(0, 0)
                            inst.Rotation = 0
                            inst.BackgroundTransparency = 0
                            inst.Position = UDim2.new(0, 0, 0, 0)
                            inst.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                            inst.ZIndex = 1
                            inst.BorderSizePixel = 0
                            inst.Size = UDim2.new(0.699999988, 0, 1, 0)
                            inst.Parent = inst
                            do
                                local inst = Instance.new("UICorner")
                                inst.Name = "UICorner"
                                inst.Parent = inst
                            end
                            do
                                local inst = Instance.new("UIGradient")
                                inst.Name = "UIGradient"
                                inst.Parent = inst
                            end
                        end
                    end
                end
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "QuestLogScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "Panel"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "QUEST LOG"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("ScrollingFrame")
            inst.Name = "QuestList"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst.Parent = inst
            do
                local inst = Instance.new("UIListLayout")
                inst.Name = "UIListLayout"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "EmptyState"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "No active quests"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 18
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "QuestTemplate"
                inst.Visible = false
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.949999988, 0, 0.0599999987, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "QuestName"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.699999988, 0, 1, 0)
                    inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst.LayoutOrder = 0
                    inst.Text = "Quest Title"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 14
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamMedium
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Left
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "QuestProgress"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.25, 0, 1, 0)
                    inst.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst.LayoutOrder = 0
                    inst.Text = "0/5"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 12
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamBold
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.720000029, 0, 0, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Right
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "QuestDesc"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.899999976, 0, 0.300000012, 0)
                    inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                    inst.LayoutOrder = 0
                    inst.Text = "Description text..."
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 12
                    inst.Rotation = 0
                    inst.Font = Enum.Font.Gotham
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.0199999996, 0, 0.5, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Left
                    inst.TextYAlignment = Enum.TextYAlignment.Top
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "QuestCheck"
                    inst.Visible = false
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(0.0799999982, 0, 0.400000006, 0)
                    inst.TextColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst.LayoutOrder = 0
                    inst.Text = "\u2713"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 12
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamBold
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0.899999976, 0, 0.300000012, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Center
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "RewardsScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "MainFrame"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.200000003, 0, 0.25, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.600000024, 0, 0.5, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "REWARDS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("ScrollingFrame")
            inst.Name = "RewardsList"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.730000019, -10)
            inst.Parent = inst
            do
                local inst = Instance.new("UIListLayout")
                inst.Name = "UIListLayout"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "EmptyState"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "No rewards to claim"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "SettingsScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "Panel"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "SETTINGS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("ScrollingFrame")
            inst.Name = "SettingsList"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst.Parent = inst
            do
                local inst = Instance.new("UIListLayout")
                inst.Name = "UIListLayout"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "AudioLabel"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, -10, 0.0399999991, 0)
                inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst.LayoutOrder = 0
                inst.Text = "AUDIO"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "MusicSlider"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "MusicSliderFill"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0, 0, 0, 0)
                    inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.5, 0, 1, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UIGradient")
                        inst.Name = "UIGradient"
                        inst.Parent = inst
                    end
                end
                do
                    local inst = Instance.new("TextButton")
                    inst.Name = "MusicClickArea"
                    inst.Visible = true
                    inst.TextWrapped = false
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(1, 0, 1, 0)
                    inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst.LayoutOrder = 0
                    inst.Text = ""
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 8
                    inst.Rotation = 0
                    inst.Font = Enum.Font.Legacy
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0, 0, 0, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Center
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = false
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "MusicLabel"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.300000012, 0, 0.0399999991, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "Music 50%"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "SFXSlider"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("Frame")
                    inst.Name = "SFXSliderFill"
                    inst.Visible = true
                    inst.LayoutOrder = 0
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.Rotation = 0
                    inst.BackgroundTransparency = 0
                    inst.Position = UDim2.new(0, 0, 0, 0)
                    inst.BackgroundColor3 = Color3.new(0.392157, 0.862745, 1.0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 0
                    inst.Size = UDim2.new(0.699999988, 0, 1, 0)
                    inst.Parent = inst
                    do
                        local inst = Instance.new("UIGradient")
                        inst.Name = "UIGradient"
                        inst.Parent = inst
                    end
                end
                do
                    local inst = Instance.new("TextButton")
                    inst.Name = "SFXClickArea"
                    inst.Visible = true
                    inst.TextWrapped = false
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(1, 0, 1, 0)
                    inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst.LayoutOrder = 0
                    inst.Text = ""
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 8
                    inst.Rotation = 0
                    inst.Font = Enum.Font.Legacy
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0, 0, 0, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Center
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = false
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "SFXLabel"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.300000012, 0, 0.0399999991, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "SFX 70%"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "GraphicsLabel"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, -10, 0.0399999991, 0)
                inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst.LayoutOrder = 0
                inst.Text = "GRAPHICS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "QualityDropdown"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "High"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "FullscreenToggle"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "Fullscreen: On"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "Frame"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(1, -10, 0.0500000007, 0)
                inst.Parent = inst
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "SkillTreeScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "MainFrame"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.125, 0, 0.100000001, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.75, 0, 0.800000012, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "SKILL TREE"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("ScrollingFrame")
            inst.Name = "SkillCanvas"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.600000024, -10, 0.829999983, -10)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("Frame")
                inst.Name = "SkillNodeTemplate"
                inst.Visible = false
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0, 50, 0, 50)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "NodeLabel"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(1, 0, 0.300000012, 0)
                    inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                    inst.LayoutOrder = 0
                    inst.Text = "Focus"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 10
                    inst.Rotation = 0
                    inst.Font = Enum.Font.GothamMedium
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0, 0, 0.699999988, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Left
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "SkillDetail"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.639999986, 0, 0.0700000003, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.349999994, 0, 0.829999983, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "DetailTitle"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.899999976, 0, 0.0599999987, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "Select a skill"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "DetailDesc"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.899999976, 0, 0.400000006, 0)
                inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst.LayoutOrder = 0
                inst.Text = "Click a skill node to see details."
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0.200000003, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "UnlockButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.899999976, 0, 0.0799999982, 0)
                inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst.LayoutOrder = 0
                inst.Text = "UNLOCK"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.0500000007, 0, 0.699999988, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIGradient")
                    inst.Name = "UIGradient"
                    inst.Parent = inst
                end
            end
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "StartingScreen"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "LogoContainer"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.25, 0, 0.150000006, 0)
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.5, 0, 0.300000012, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Logo"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, 0, 0.699999988, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "AETHER\nHARVESTER"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 48
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBlack
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Top
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Subtitle"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, 0, 0.300000012, 0)
                inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst.LayoutOrder = 0
                inst.Text = "SIMULATOR"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 20
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0, 0, 0.699999988, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
        end
        do
            local inst = Instance.new("TextButton")
            inst.Name = "PlayButton"
            inst.Visible = true
            inst.TextWrapped = true
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.ZIndex = 10
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.349999994, 0, 0.0799999982, 0)
            inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
            inst.LayoutOrder = 0
            inst.Text = "PLAY"
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.TextSize = 22
            inst.Rotation = 0
            inst.Font = Enum.Font.GothamBold
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.324999988, 0, 0.720000029, 0)
            inst.TextXAlignment = Enum.TextXAlignment.Center
            inst.TextYAlignment = Enum.TextYAlignment.Center
            inst.TextScaled = true
            inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
        end
        do
            local inst = Instance.new("TextButton")
            inst.Name = "SettingsButton"
            inst.Visible = true
            inst.TextWrapped = true
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.ZIndex = 10
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.200000003, 0, 0.0500000007, 0)
            inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
            inst.LayoutOrder = 0
            inst.Text = "SETTINGS"
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.TextSize = 16
            inst.Rotation = 0
            inst.Font = Enum.Font.Gotham
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.400000006, 0, 0.819999993, 0)
            inst.TextXAlignment = Enum.TextXAlignment.Center
            inst.TextYAlignment = Enum.TextYAlignment.Center
            inst.TextScaled = true
            inst.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
        end
        do
            local inst = Instance.new("TextLabel")
            inst.Name = "LoadingText"
            inst.Visible = true
            inst.TextWrapped = true
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.ZIndex = 1
            inst.BorderSizePixel = 1
            inst.Size = UDim2.new(0.300000012, 0, 0.0299999993, 0)
            inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
            inst.LayoutOrder = 0
            inst.Text = "Click PLAY to begin"
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.TextSize = 18
            inst.Rotation = 0
            inst.Font = Enum.Font.Gotham
            inst.BackgroundTransparency = 1
            inst.Position = UDim2.new(0.349999994, 0, 0.660000026, 0)
            inst.TextXAlignment = Enum.TextXAlignment.Center
            inst.TextYAlignment = Enum.TextYAlignment.Center
            inst.TextScaled = true
            inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst.Parent = inst
        end
    end
end
do
    local inst = Instance.new("ScreenGui")
    inst.Name = "TradeWindow"
    inst.Parent = Screens
    do
        local inst = Instance.new("Frame")
        inst.Name = "Background"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0.15000000596046448
        inst.Position = UDim2.new(0, 0, 0, 0)
        inst.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(1, 0, 1, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
    end
    do
        local inst = Instance.new("Frame")
        inst.Name = "MainFrame"
        inst.Visible = true
        inst.LayoutOrder = 0
        inst.AutomaticSize = Enum.AutomaticSize.None
        inst.AnchorPoint = Vector2.new(0, 0)
        inst.Rotation = 0
        inst.BackgroundTransparency = 0
        inst.Position = UDim2.new(0.125, 0, 0.224999994, 0)
        inst.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst.ZIndex = 1
        inst.BorderSizePixel = 0
        inst.Size = UDim2.new(0.75, 0, 0.550000012, 0)
        inst.Parent = inst
        do
            local inst = Instance.new("UICorner")
            inst.Name = "UICorner"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIStroke")
            inst.Name = "UIStroke"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("UIGradient")
            inst.Name = "UIGradient"
            inst.Parent = inst
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TitleBar"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0, 0, 0, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "Title"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(0.5, 0, 1, 0)
                inst.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst.LayoutOrder = 0
                inst.Text = "TRADING"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 24
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamBold
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextButton")
                inst.Name = "CloseButton"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst.LayoutOrder = 0
                inst.Text = "\u2715"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 16
                inst.Rotation = 0
                inst.Font = Enum.Font.Gotham
                inst.BackgroundTransparency = 0
                inst.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Center
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst.Parent = inst
                do
                    local inst = Instance.new("UICorner")
                    inst.Name = "UICorner"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("UIStroke")
                    inst.Name = "UIStroke"
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "PlayerList"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.0399999991, 0, 0.100000001, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.300000012, -10, 0.649999976, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "PlayerListTitle"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, -10, 0.100000001, 0)
                inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst.LayoutOrder = 0
                inst.Text = "NEARBY PLAYERS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
            do
                local inst = Instance.new("ScrollingFrame")
                inst.Name = "PlayerScroll"
                inst.Visible = true
                inst.LayoutOrder = 0
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.Rotation = 0
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0.0500000007, 0, 0.119999997, 0)
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.ZIndex = 1
                inst.BorderSizePixel = 0
                inst.Size = UDim2.new(1, -10, 0.800000012, 0)
                inst.Parent = inst
                do
                    local inst = Instance.new("UIListLayout")
                    inst.Name = "UIListLayout"
                    inst.Parent = inst
                end
                do
                    local inst = Instance.new("TextLabel")
                    inst.Name = "EmptyState"
                    inst.Visible = true
                    inst.TextWrapped = true
                    inst.AnchorPoint = Vector2.new(0, 0)
                    inst.ZIndex = 1
                    inst.BorderSizePixel = 1
                    inst.Size = UDim2.new(1, 0, 0.100000001, 0)
                    inst.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst.LayoutOrder = 0
                    inst.Text = "No nearby players"
                    inst.AutomaticSize = Enum.AutomaticSize.None
                    inst.TextSize = 14
                    inst.Rotation = 0
                    inst.Font = Enum.Font.Gotham
                    inst.BackgroundTransparency = 1
                    inst.Position = UDim2.new(0, 0, 0.400000006, 0)
                    inst.TextXAlignment = Enum.TextXAlignment.Center
                    inst.TextYAlignment = Enum.TextYAlignment.Center
                    inst.TextScaled = true
                    inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst.Parent = inst
                end
            end
        end
        do
            local inst = Instance.new("Frame")
            inst.Name = "TradeSlots"
            inst.Visible = true
            inst.LayoutOrder = 0
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.Rotation = 0
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.360000014, 0, 0.5, 0)
            inst.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.600000024, 0, 0.400000006, 0)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("TextLabel")
                inst.Name = "TradeSlotsTitle"
                inst.Visible = true
                inst.TextWrapped = true
                inst.AnchorPoint = Vector2.new(0, 0)
                inst.ZIndex = 1
                inst.BorderSizePixel = 1
                inst.Size = UDim2.new(1, 0, 0.150000006, 0)
                inst.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst.LayoutOrder = 0
                inst.Text = "TRADE ITEMS"
                inst.AutomaticSize = Enum.AutomaticSize.None
                inst.TextSize = 14
                inst.Rotation = 0
                inst.Font = Enum.Font.GothamMedium
                inst.BackgroundTransparency = 1
                inst.Position = UDim2.new(0, 0, 0, 0)
                inst.TextXAlignment = Enum.TextXAlignment.Left
                inst.TextYAlignment = Enum.TextYAlignment.Center
                inst.TextScaled = true
                inst.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst.Parent = inst
            end
        end
        do
            local inst = Instance.new("TextButton")
            inst.Name = "ConfirmButton"
            inst.Visible = true
            inst.TextWrapped = true
            inst.AnchorPoint = Vector2.new(0, 0)
            inst.ZIndex = 1
            inst.BorderSizePixel = 0
            inst.Size = UDim2.new(0.600000024, 0, 0.0599999987, 0)
            inst.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
            inst.LayoutOrder = 0
            inst.Text = "TRADE"
            inst.AutomaticSize = Enum.AutomaticSize.None
            inst.TextSize = 16
            inst.Rotation = 0
            inst.Font = Enum.Font.GothamBold
            inst.BackgroundTransparency = 0
            inst.Position = UDim2.new(0.200000003, 0, 0.920000017, 0)
            inst.TextXAlignment = Enum.TextXAlignment.Center
            inst.TextYAlignment = Enum.TextYAlignment.Center
            inst.TextScaled = true
            inst.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
            inst.Parent = inst
            do
                local inst = Instance.new("UICorner")
                inst.Name = "UICorner"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIStroke")
                inst.Name = "UIStroke"
                inst.Parent = inst
            end
            do
                local inst = Instance.new("UIGradient")
                inst.Name = "UIGradient"
                inst.Parent = inst
            end
        end
    end
end

Screens.Parent = AetherUI
return Screens
