--!strict
-- Screens: deterministic recreation of StarterGui.AetherUI.Screens
-- Generated from artifacts/recovery/StarterGui_AetherUI_Screens_*.json

local AetherUI = script.Parent
local Screens = Instance.new("Folder")
Screens.Name = "Screens"

do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "HUD"
    inst4.Parent = AetherUI
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "EnergyBar"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.30000001192092896
        inst8.Position = UDim2.new(0.0199999996, 0, 0.0199999996, 0)
        inst8.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.180000007, 0, 0.0250000004, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "Fill"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(1.0, 0.654902, 0.14902)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 1, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "HealthBar"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.30000001192092896
        inst8.Position = UDim2.new(0.0199999996, 0, 0.0549999997, 0)
        inst8.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.180000007, 0, 0.0250000004, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "Fill"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.898039, 0.223529, 0.207843)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 1, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "NotificationArea"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.75, 0, 0.0199999996, 0)
        inst8.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.25, 0, 0.0399999991, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("TextLabel")
            inst12.Name = "Notification"
            inst12.Visible = false
            inst12.TextWrapped = true
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 1
            inst12.Size = UDim2.new(1, 0, 1, 0)
            inst12.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
            inst12.LayoutOrder = 0
            inst12.Text = ""
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.TextSize = 20
            inst12.Rotation = 0
            inst12.Font = Enum.Font.GothamMedium
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.TextXAlignment = Enum.TextXAlignment.Left
            inst12.TextYAlignment = Enum.TextYAlignment.Center
            inst12.TextScaled = true
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("TextLabel")
        inst8.Name = "QuestTracker"
        inst8.Visible = true
        inst8.TextWrapped = true
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.25, 0, 0.0350000001, 0)
        inst8.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
        inst8.LayoutOrder = 0
        inst8.Text = "No active quest"
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.TextSize = 18
        inst8.Rotation = 0
        inst8.Font = Enum.Font.Gotham
        inst8.BackgroundTransparency = 0.30000001192092896
        inst8.Position = UDim2.new(0.75, 0, 0.0700000003, 0)
        inst8.TextXAlignment = Enum.TextXAlignment.Left
        inst8.TextYAlignment = Enum.TextYAlignment.Center
        inst8.TextScaled = true
        inst8.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "MinimapFrame"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.879999995, 0, 0.879999995, 0)
        inst8.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.119999997, 0, 0.119999997, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "Background"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0.5
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 1, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "PlayerDot"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.5, -8, 0.5, -8)
            inst12.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.0299999993, 0, 0.0299999993, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
        end
    end
    do
        local inst8 = Instance.new("TextLabel")
        inst8.Name = "LevelDisplay"
        inst8.Visible = true
        inst8.TextWrapped = false
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.ZIndex = 5
        inst8.BorderSizePixel = 1
        inst8.Size = UDim2.new(0.119999997, 0, 0.0350000001, 0)
        inst8.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
        inst8.LayoutOrder = 0
        inst8.Text = "Lv. 1"
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.TextScaled = true
        inst8.Rotation = 0
        inst8.Font = Enum.Font.GothamBold
        inst8.BackgroundTransparency = 0.5
        inst8.Position = UDim2.new(0.0199999996, 0, 0.0900000036, 0)
        inst8.TextXAlignment = Enum.TextXAlignment.Center
        inst8.TextYAlignment = Enum.TextYAlignment.Center
        inst8.TextScaled = false
        inst8.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("TextLabel")
        inst8.Name = "CurrencyDisplay"
        inst8.Visible = true
        inst8.TextWrapped = false
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.ZIndex = 5
        inst8.BorderSizePixel = 1
        inst8.Size = UDim2.new(0.150000006, 0, 0.0350000001, 0)
        inst8.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
        inst8.LayoutOrder = 0
        inst8.Text = "Shards: 0"
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.TextScaled = true
        inst8.Rotation = 0
        inst8.Font = Enum.Font.GothamBold
        inst8.BackgroundTransparency = 0.5
        inst8.Position = UDim2.new(0.159999996, 0, 0.0900000036, 0)
        inst8.TextXAlignment = Enum.TextXAlignment.Center
        inst8.TextYAlignment = Enum.TextYAlignment.Center
        inst8.TextScaled = false
        inst8.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("TextLabel")
        inst8.Name = "ToolDisplay"
        inst8.Visible = true
        inst8.TextWrapped = false
        inst8.AnchorPoint = Vector2.new(0, 1)
        inst8.ZIndex = 5
        inst8.BorderSizePixel = 1
        inst8.Size = UDim2.new(0.119999997, 0, 0.0350000001, 0)
        inst8.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
        inst8.LayoutOrder = 0
        inst8.Text = "Tool: None"
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.TextScaled = true
        inst8.Rotation = 0
        inst8.Font = Enum.Font.GothamBold
        inst8.BackgroundTransparency = 0.5
        inst8.Position = UDim2.new(0.0199999996, 0, 0.944999993, 0)
        inst8.TextXAlignment = Enum.TextXAlignment.Center
        inst8.TextYAlignment = Enum.TextYAlignment.Center
        inst8.TextScaled = false
        inst8.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("TextLabel")
        inst8.Name = "ActiveCreature"
        inst8.Visible = true
        inst8.TextWrapped = false
        inst8.AnchorPoint = Vector2.new(0, 1)
        inst8.ZIndex = 5
        inst8.BorderSizePixel = 1
        inst8.Size = UDim2.new(0.119999997, 0, 0.0350000001, 0)
        inst8.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
        inst8.LayoutOrder = 0
        inst8.Text = "Pet: None"
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.TextScaled = true
        inst8.Rotation = 0
        inst8.Font = Enum.Font.GothamBold
        inst8.BackgroundTransparency = 0.5
        inst8.Position = UDim2.new(0.159999996, 0, 0.944999993, 0)
        inst8.TextXAlignment = Enum.TextXAlignment.Center
        inst8.TextYAlignment = Enum.TextYAlignment.Center
        inst8.TextScaled = false
        inst8.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "EventScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "MainFrame"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.125, 0, 0.150000006, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.75, 0, 0.699999988, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "EVENTS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("ScrollingFrame")
            inst12.Name = "EventList"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIListLayout")
                inst16.Name = "UIListLayout"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "EmptyState"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "No active events"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "EventTemplate"
                inst16.Visible = false
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.949999988, 0, 0.150000006, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "EventName"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.600000024, 0, 0.400000006, 0)
                    inst20.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst20.LayoutOrder = 0
                    inst20.Text = "Event Name"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 14
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamMedium
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.0299999993, 0, 0.0500000007, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Left
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "EventTime"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.300000012, 0, 0.400000006, 0)
                    inst20.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst20.LayoutOrder = 0
                    inst20.Text = "02:00:00"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 12
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamBold
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.649999976, 0, 0.0500000007, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Right
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "EventDesc"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.899999976, 0, 0.300000012, 0)
                    inst20.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                    inst20.LayoutOrder = 0
                    inst20.Text = "Event description..."
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 12
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.Gotham
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.0299999993, 0, 0.5, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Left
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextButton")
                    inst20.Name = "JoinButton"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.200000003, 0, 0.300000012, 0)
                    inst20.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                    inst20.LayoutOrder = 0
                    inst20.Text = "JOIN"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 12
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamMedium
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0.779999971, 0, 0.600000024, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Center
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIStroke")
                        inst24.Name = "UIStroke"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIGradient")
                        inst24.Name = "UIGradient"
                        inst24.Parent = inst20
                    end
                end
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "GuildScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "MainFrame"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.150000006, 0, 0.100000001, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "GUILD"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "GuildInfo"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.150000006, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "GuildName"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
                inst16.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst16.LayoutOrder = 0
                inst16.Text = "No Guild"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0.100000001, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "GuildLevel"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.400000006, 0, 0.400000006, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "Lv. 1"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.550000012, 0, 0.100000001, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "GuildXPBar"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.0500000007, 0, 0.550000012, 0)
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.300000012, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "GuildXPFill"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0, 0, 0, 0)
                    inst20.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.300000012, 0, 1, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UIGradient")
                        inst24.Name = "UIGradient"
                        inst24.Parent = inst20
                    end
                end
            end
        end
        do
            local inst12 = Instance.new("ScrollingFrame")
            inst12.Name = "MemberList"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.230000004, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.600000024, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIListLayout")
                inst16.Name = "UIListLayout"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "EmptyState"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "No guild members"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "InventoryScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Panel"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "INVENTORY"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TabBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.0500000007, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "TabItems"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst16.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst16.LayoutOrder = 0
                inst16.Text = "ITEMS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0.30000001192092896
                inst16.Position = UDim2.new(0, 0, 0.100000001, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "TabEquipment"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst16.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst16.LayoutOrder = 0
                inst16.Text = "EQUIPMENT"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0.800000011920929
                inst16.Position = UDim2.new(0.25, 0, 0.100000001, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "TabResources"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst16.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst16.LayoutOrder = 0
                inst16.Text = "RESOURCES"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0.800000011920929
                inst16.Position = UDim2.new(0.5, 0, 0.100000001, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "TabCrafting"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.25, 0, 0.800000012, 0)
                inst16.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst16.LayoutOrder = 0
                inst16.Text = "CRAFTING"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0.800000011920929
                inst16.Position = UDim2.new(0.75, 0, 0.100000001, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("ScrollingFrame")
            inst12.Name = "Content"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGridLayout")
                inst16.Name = "UIGridLayout"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "EmptyState"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "Your inventory is empty"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "ItemTemplate"
                inst16.Visible = false
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.200000003, 0, 0.200000003, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("ImageLabel")
                    inst20.Name = "Icon"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.324999988, 0, 0.0500000007, 0)
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.349999994, 0, 0.349999994, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "ItemName"
                    inst20.Visible = true
                    inst20.TextWrapped = false
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
                    inst20.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst20.LayoutOrder = 0
                    inst20.Text = "Item Name"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 11
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamMedium
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.100000001, 0, 0.419999987, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Left
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = false
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "ItemCount"
                    inst20.Visible = true
                    inst20.TextWrapped = false
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.800000012, 0, 0.200000003, 0)
                    inst20.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                    inst20.LayoutOrder = 0
                    inst20.Text = "x1"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 10
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.Gotham
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.100000001, 0, 0.649999976, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Left
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = false
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "MainMenu"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Panel"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.224999994, 0, 0.150000006, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.550000012, 0, 0.699999988, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "AETHER HARVESTER"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 32
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "PlayerInfo"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.00499999989, 0, 0.0799999982, 0)
            inst12.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -10, 0.119999997, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "PlayerName"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.600000024, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "PlayerName"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "PlayerLevel"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.349999994, 0, 1, 0)
                inst16.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst16.LayoutOrder = 0
                inst16.Text = "Lv. 1"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.629999995, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Right
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "NavContainer"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.219999999, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.550000012, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIListLayout")
                inst16.Name = "UIListLayout"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "NavInventory"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "INVENTORY"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "NavQuests"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "QUESTS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "NavPets"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "PETS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "NavGuild"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "GUILD"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "NavSkillTree"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "SKILL TREE"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "NavMap"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "MAP"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "NavSettings"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.129999995, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "SETTINGS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
        end
    end
    do
        local inst8 = Instance.new("TextButton")
        inst8.Name = "CloseButton"
        inst8.Visible = true
        inst8.TextWrapped = true
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 1
        inst8.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
        inst8.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
        inst8.LayoutOrder = 0
        inst8.Text = "\u2715"
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.TextSize = 8
        inst8.Rotation = 0
        inst8.Font = Enum.Font.Gotham
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.920000017, 0, 0.25, 0)
        inst8.TextXAlignment = Enum.TextXAlignment.Center
        inst8.TextYAlignment = Enum.TextYAlignment.Center
        inst8.TextScaled = true
        inst8.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "MapScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Panel"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "MAP"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "MapContent"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "MapBG"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0.5
                inst16.Position = UDim2.new(0.0500000007, 0, 0.100000001, 0)
                inst16.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.800000012, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "CloudGardensMarker"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0.200000003, 0, 0.200000003, 0)
                    inst20.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIStroke")
                        inst24.Name = "UIStroke"
                        inst24.Parent = inst20
                    end
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "CrystalCanyonMarker"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0.5, 0, 0.300000012, 0)
                    inst20.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIStroke")
                        inst24.Name = "UIStroke"
                        inst24.Parent = inst20
                    end
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "VoidAltarMarker"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0.800000012, 0, 0.200000003, 0)
                    inst20.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIStroke")
                        inst24.Name = "UIStroke"
                        inst24.Parent = inst20
                    end
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "AncientRuinsMarker"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0.300000012, 0, 0.699999988, 0)
                    inst20.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIStroke")
                        inst24.Name = "UIStroke"
                        inst24.Parent = inst20
                    end
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "FloatingMarketMarker"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0.699999988, 0, 0.699999988, 0)
                    inst20.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIStroke")
                        inst24.Name = "UIStroke"
                        inst24.Parent = inst20
                    end
                end
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "LocationMarker"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.899999976, 0, 0.0500000007, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "Current: CloudGardens"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "PetScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Panel"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.150000006, 0, 0.100000001, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.699999988, 0, 0.800000012, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "PET COMPANION"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "PetList"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.349999994, 0, 0.829999983, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "PetListTitle"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, -10, 0.0500000007, 0)
                inst16.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst16.LayoutOrder = 0
                inst16.Text = "YOUR PETS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("ScrollingFrame")
                inst16.Name = "PetScroll"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0.0500000007, 0)
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(1, -10, 0.899999976, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UIListLayout")
                    inst20.Name = "UIListLayout"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "PetTemplate"
                    inst20.Visible = false
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0, 0, 0, 0)
                    inst20.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.899999976, 0, 0.119999997, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UICorner")
                        inst24.Name = "UICorner"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIStroke")
                        inst24.Name = "UIStroke"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("UIGradient")
                        inst24.Name = "UIGradient"
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("ImageLabel")
                        inst24.Name = "PetIcon"
                        inst24.Visible = true
                        inst24.LayoutOrder = 0
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.Rotation = 0
                        inst24.BackgroundTransparency = 1
                        inst24.Position = UDim2.new(0.0199999996, 0, 0.150000006, 0)
                        inst24.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 0
                        inst24.Size = UDim2.new(0.150000006, 0, 0.699999988, 0)
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("TextLabel")
                        inst24.Name = "PetName"
                        inst24.Visible = true
                        inst24.TextWrapped = true
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 1
                        inst24.Size = UDim2.new(0.600000024, 0, 0.349999994, 0)
                        inst24.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                        inst24.LayoutOrder = 0
                        inst24.Text = "Pet Name"
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.TextSize = 14
                        inst24.Rotation = 0
                        inst24.Font = Enum.Font.GothamMedium
                        inst24.BackgroundTransparency = 1
                        inst24.Position = UDim2.new(0.200000003, 0, 0.0500000007, 0)
                        inst24.TextXAlignment = Enum.TextXAlignment.Left
                        inst24.TextYAlignment = Enum.TextYAlignment.Center
                        inst24.TextScaled = true
                        inst24.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("TextLabel")
                        inst24.Name = "PetLevel"
                        inst24.Visible = true
                        inst24.TextWrapped = true
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 1
                        inst24.Size = UDim2.new(0.600000024, 0, 0.25, 0)
                        inst24.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                        inst24.LayoutOrder = 0
                        inst24.Text = "Lv. 1"
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.TextSize = 12
                        inst24.Rotation = 0
                        inst24.Font = Enum.Font.Gotham
                        inst24.BackgroundTransparency = 1
                        inst24.Position = UDim2.new(0.200000003, 0, 0.419999987, 0)
                        inst24.TextXAlignment = Enum.TextXAlignment.Left
                        inst24.TextYAlignment = Enum.TextYAlignment.Center
                        inst24.TextScaled = true
                        inst24.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("TextLabel")
                        inst24.Name = "PetRarity"
                        inst24.Visible = true
                        inst24.TextWrapped = true
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 1
                        inst24.Size = UDim2.new(0.150000006, 0, 0.300000012, 0)
                        inst24.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                        inst24.LayoutOrder = 0
                        inst24.Text = "COMMON"
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.TextSize = 10
                        inst24.Rotation = 0
                        inst24.Font = Enum.Font.Gotham
                        inst24.BackgroundTransparency = 1
                        inst24.Position = UDim2.new(0.829999983, 0, 0.0500000007, 0)
                        inst24.TextXAlignment = Enum.TextXAlignment.Right
                        inst24.TextYAlignment = Enum.TextYAlignment.Center
                        inst24.TextScaled = true
                        inst24.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("TextButton")
                        inst24.Name = "PetEquipBtn"
                        inst24.Visible = true
                        inst24.TextWrapped = true
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 0
                        inst24.Size = UDim2.new(0.400000006, 0, 0.300000012, 0)
                        inst24.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                        inst24.LayoutOrder = 0
                        inst24.Text = "Equip"
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.TextSize = 12
                        inst24.Rotation = 0
                        inst24.Font = Enum.Font.GothamMedium
                        inst24.BackgroundTransparency = 0
                        inst24.Position = UDim2.new(0.579999983, 0, 0.600000024, 0)
                        inst24.TextXAlignment = Enum.TextXAlignment.Center
                        inst24.TextYAlignment = Enum.TextYAlignment.Center
                        inst24.TextScaled = true
                        inst24.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                        inst24.Parent = inst20
                        do
                            local inst28 = Instance.new("UICorner")
                            inst28.Name = "UICorner"
                            inst28.Parent = inst24
                        end
                        do
                            local inst28 = Instance.new("UIStroke")
                            inst28.Name = "UIStroke"
                            inst28.Parent = inst24
                        end
                        do
                            local inst28 = Instance.new("UIGradient")
                            inst28.Name = "UIGradient"
                            inst28.Parent = inst24
                        end
                    end
                    do
                        local inst24 = Instance.new("TextLabel")
                        inst24.Name = "PetActiveBadge"
                        inst24.Visible = false
                        inst24.TextWrapped = true
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 1
                        inst24.Size = UDim2.new(0.150000006, 0, 0.300000012, 0)
                        inst24.TextColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                        inst24.LayoutOrder = 0
                        inst24.Text = "EQUIPPED"
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.TextSize = 10
                        inst24.Rotation = 0
                        inst24.Font = Enum.Font.GothamBold
                        inst24.BackgroundTransparency = 1
                        inst24.Position = UDim2.new(0.829999983, 0, 0.600000024, 0)
                        inst24.TextXAlignment = Enum.TextXAlignment.Right
                        inst24.TextYAlignment = Enum.TextYAlignment.Center
                        inst24.TextScaled = true
                        inst24.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst24.Parent = inst20
                    end
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "PetDetail"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.370000005, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.600000024, 0, 0.829999983, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "DetailHeader"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, -10, 0.0599999987, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "PET DETAILS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "DetailStats"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0.0599999987, 0)
                inst16.BackgroundColor3 = Color3.new(0.0, 0.0, 0.0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(1, -10, 0.850000024, -10)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UIListLayout")
                    inst20.Name = "UIListLayout"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "StatRow"
                    inst20.Visible = false
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0, 0, 0, 0)
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(1, 0, 0.119999997, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("TextLabel")
                        inst24.Name = "StatLabel"
                        inst24.Visible = true
                        inst24.TextWrapped = true
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 1
                        inst24.Size = UDim2.new(0.400000006, 0, 1, 0)
                        inst24.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                        inst24.LayoutOrder = 0
                        inst24.Text = "ATK"
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.TextSize = 12
                        inst24.Rotation = 0
                        inst24.Font = Enum.Font.Gotham
                        inst24.BackgroundTransparency = 1
                        inst24.Position = UDim2.new(0, 0, 0, 0)
                        inst24.TextXAlignment = Enum.TextXAlignment.Left
                        inst24.TextYAlignment = Enum.TextYAlignment.Center
                        inst24.TextScaled = true
                        inst24.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("TextLabel")
                        inst24.Name = "StatValue"
                        inst24.Visible = true
                        inst24.TextWrapped = true
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 1
                        inst24.Size = UDim2.new(0.5, 0, 1, 0)
                        inst24.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                        inst24.LayoutOrder = 0
                        inst24.Text = "15"
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.TextSize = 12
                        inst24.Rotation = 0
                        inst24.Font = Enum.Font.GothamBold
                        inst24.BackgroundTransparency = 1
                        inst24.Position = UDim2.new(0.550000012, 0, 0, 0)
                        inst24.TextXAlignment = Enum.TextXAlignment.Left
                        inst24.TextYAlignment = Enum.TextYAlignment.Center
                        inst24.TextScaled = true
                        inst24.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                        inst24.Parent = inst20
                    end
                    do
                        local inst24 = Instance.new("Frame")
                        inst24.Name = "StatBar"
                        inst24.Visible = true
                        inst24.LayoutOrder = 0
                        inst24.AutomaticSize = Enum.AutomaticSize.None
                        inst24.AnchorPoint = Vector2.new(0, 0)
                        inst24.Rotation = 0
                        inst24.BackgroundTransparency = 0
                        inst24.Position = UDim2.new(0.550000012, 0, 0.5, 0)
                        inst24.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                        inst24.ZIndex = 1
                        inst24.BorderSizePixel = 0
                        inst24.Size = UDim2.new(0.5, 0, 0.400000006, 0)
                        inst24.Parent = inst20
                        do
                            local inst28 = Instance.new("UICorner")
                            inst28.Name = "UICorner"
                            inst28.Parent = inst24
                        end
                        do
                            local inst28 = Instance.new("Frame")
                            inst28.Name = "StatBarFill"
                            inst28.Visible = true
                            inst28.LayoutOrder = 0
                            inst28.AutomaticSize = Enum.AutomaticSize.None
                            inst28.AnchorPoint = Vector2.new(0, 0)
                            inst28.Rotation = 0
                            inst28.BackgroundTransparency = 0
                            inst28.Position = UDim2.new(0, 0, 0, 0)
                            inst28.BackgroundColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                            inst28.ZIndex = 1
                            inst28.BorderSizePixel = 0
                            inst28.Size = UDim2.new(0.699999988, 0, 1, 0)
                            inst28.Parent = inst24
                            do
                                local inst32 = Instance.new("UICorner")
                                inst32.Name = "UICorner"
                                inst32.Parent = inst28
                            end
                            do
                                local inst32 = Instance.new("UIGradient")
                                inst32.Name = "UIGradient"
                                inst32.Parent = inst28
                            end
                        end
                    end
                end
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "QuestLogScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Panel"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "QUEST LOG"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("ScrollingFrame")
            inst12.Name = "QuestList"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIListLayout")
                inst16.Name = "UIListLayout"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "EmptyState"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "No active quests"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 18
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "QuestTemplate"
                inst16.Visible = false
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.949999988, 0, 0.0599999987, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "QuestName"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.699999988, 0, 1, 0)
                    inst20.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst20.LayoutOrder = 0
                    inst20.Text = "Quest Title"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 14
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamMedium
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.0199999996, 0, 0, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Left
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "QuestProgress"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.25, 0, 1, 0)
                    inst20.TextColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst20.LayoutOrder = 0
                    inst20.Text = "0/5"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 12
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamBold
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.720000029, 0, 0, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Right
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "QuestDesc"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.899999976, 0, 0.300000012, 0)
                    inst20.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                    inst20.LayoutOrder = 0
                    inst20.Text = "Description text..."
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 12
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.Gotham
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.0199999996, 0, 0.5, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Left
                    inst20.TextYAlignment = Enum.TextYAlignment.Top
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "QuestCheck"
                    inst20.Visible = false
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(0.0799999982, 0, 0.400000006, 0)
                    inst20.TextColor3 = Color3.new(0.298039, 0.686275, 0.313726)
                    inst20.LayoutOrder = 0
                    inst20.Text = "\u2713"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 12
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamBold
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0.899999976, 0, 0.300000012, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Center
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "RewardsScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "MainFrame"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.200000003, 0, 0.25, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.600000024, 0, 0.5, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "REWARDS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("ScrollingFrame")
            inst12.Name = "RewardsList"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.730000019, -10)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIListLayout")
                inst16.Name = "UIListLayout"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "EmptyState"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.800000012, 0, 0.100000001, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "No rewards to claim"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.100000001, 0, 0.400000006, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "SettingsScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Panel"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.150000006, 0, 0.125, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.699999988, 0, 0.75, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "SETTINGS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("ScrollingFrame")
            inst12.Name = "SettingsList"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, -20, 0.829999983, -10)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIListLayout")
                inst16.Name = "UIListLayout"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "AudioLabel"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, -10, 0.0399999991, 0)
                inst16.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst16.LayoutOrder = 0
                inst16.Text = "AUDIO"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "MusicSlider"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "MusicSliderFill"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0, 0, 0, 0)
                    inst20.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.5, 0, 1, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UIGradient")
                        inst24.Name = "UIGradient"
                        inst24.Parent = inst20
                    end
                end
                do
                    local inst20 = Instance.new("TextButton")
                    inst20.Name = "MusicClickArea"
                    inst20.Visible = true
                    inst20.TextWrapped = false
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(1, 0, 1, 0)
                    inst20.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst20.LayoutOrder = 0
                    inst20.Text = ""
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 8
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.Legacy
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0, 0, 0, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Center
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = false
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "MusicLabel"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.300000012, 0, 0.0399999991, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "Music 50%"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "SFXSlider"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("Frame")
                    inst20.Name = "SFXSliderFill"
                    inst20.Visible = true
                    inst20.LayoutOrder = 0
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.Rotation = 0
                    inst20.BackgroundTransparency = 0
                    inst20.Position = UDim2.new(0, 0, 0, 0)
                    inst20.BackgroundColor3 = Color3.new(0.392157, 0.862745, 1.0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 0
                    inst20.Size = UDim2.new(0.699999988, 0, 1, 0)
                    inst20.Parent = inst16
                    do
                        local inst24 = Instance.new("UIGradient")
                        inst24.Name = "UIGradient"
                        inst24.Parent = inst20
                    end
                end
                do
                    local inst20 = Instance.new("TextButton")
                    inst20.Name = "SFXClickArea"
                    inst20.Visible = true
                    inst20.TextWrapped = false
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(1, 0, 1, 0)
                    inst20.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst20.LayoutOrder = 0
                    inst20.Text = ""
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 8
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.Legacy
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0, 0, 0, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Center
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = false
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "SFXLabel"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.300000012, 0, 0.0399999991, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "SFX 70%"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "GraphicsLabel"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, -10, 0.0399999991, 0)
                inst16.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst16.LayoutOrder = 0
                inst16.Text = "GRAPHICS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "QualityDropdown"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "High"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "FullscreenToggle"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.0399999991, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "Fullscreen: On"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.14902, 0.164706, 0.235294)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "Frame"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(1, -10, 0.0500000007, 0)
                inst16.Parent = inst12
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "SkillTreeScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "MainFrame"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.125, 0, 0.100000001, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.75, 0, 0.800000012, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "SKILL TREE"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("ScrollingFrame")
            inst12.Name = "SkillCanvas"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.00999999978, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.600000024, -10, 0.829999983, -10)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("Frame")
                inst16.Name = "SkillNodeTemplate"
                inst16.Visible = false
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0, 50, 0, 50)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "NodeLabel"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(1, 0, 0.300000012, 0)
                    inst20.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                    inst20.LayoutOrder = 0
                    inst20.Text = "Focus"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 10
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.GothamMedium
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0, 0, 0.699999988, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Left
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "SkillDetail"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.639999986, 0, 0.0700000003, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.349999994, 0, 0.829999983, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "DetailTitle"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.899999976, 0, 0.0599999987, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "Select a skill"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "DetailDesc"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.899999976, 0, 0.400000006, 0)
                inst16.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst16.LayoutOrder = 0
                inst16.Text = "Click a skill node to see details."
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0.200000003, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "UnlockButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.899999976, 0, 0.0799999982, 0)
                inst16.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
                inst16.LayoutOrder = 0
                inst16.Text = "UNLOCK"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.0500000007, 0, 0.699999988, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIGradient")
                    inst20.Name = "UIGradient"
                    inst20.Parent = inst16
                end
            end
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "StartingScreen"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "LogoContainer"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.25, 0, 0.150000006, 0)
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.5, 0, 0.300000012, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Logo"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, 0, 0.699999988, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "AETHER\nHARVESTER"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 48
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBlack
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Top
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Subtitle"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, 0, 0.300000012, 0)
                inst16.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst16.LayoutOrder = 0
                inst16.Text = "SIMULATOR"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 20
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0, 0, 0.699999988, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
        end
        do
            local inst12 = Instance.new("TextButton")
            inst12.Name = "PlayButton"
            inst12.Visible = true
            inst12.TextWrapped = true
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.ZIndex = 10
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.349999994, 0, 0.0799999982, 0)
            inst12.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
            inst12.LayoutOrder = 0
            inst12.Text = "PLAY"
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.TextSize = 22
            inst12.Rotation = 0
            inst12.Font = Enum.Font.GothamBold
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.324999988, 0, 0.720000029, 0)
            inst12.TextXAlignment = Enum.TextXAlignment.Center
            inst12.TextYAlignment = Enum.TextYAlignment.Center
            inst12.TextScaled = true
            inst12.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
        end
        do
            local inst12 = Instance.new("TextButton")
            inst12.Name = "SettingsButton"
            inst12.Visible = true
            inst12.TextWrapped = true
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.ZIndex = 10
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.200000003, 0, 0.0500000007, 0)
            inst12.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
            inst12.LayoutOrder = 0
            inst12.Text = "SETTINGS"
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.TextSize = 16
            inst12.Rotation = 0
            inst12.Font = Enum.Font.Gotham
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.400000006, 0, 0.819999993, 0)
            inst12.TextXAlignment = Enum.TextXAlignment.Center
            inst12.TextYAlignment = Enum.TextYAlignment.Center
            inst12.TextScaled = true
            inst12.BackgroundColor3 = Color3.new(0.0392157, 0.0392157, 0.0705882)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
        end
        do
            local inst12 = Instance.new("TextLabel")
            inst12.Name = "LoadingText"
            inst12.Visible = true
            inst12.TextWrapped = true
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 1
            inst12.Size = UDim2.new(0.300000012, 0, 0.0299999993, 0)
            inst12.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
            inst12.LayoutOrder = 0
            inst12.Text = "Click PLAY to begin"
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.TextSize = 18
            inst12.Rotation = 0
            inst12.Font = Enum.Font.Gotham
            inst12.BackgroundTransparency = 1
            inst12.Position = UDim2.new(0.349999994, 0, 0.660000026, 0)
            inst12.TextXAlignment = Enum.TextXAlignment.Center
            inst12.TextYAlignment = Enum.TextYAlignment.Center
            inst12.TextScaled = true
            inst12.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
            inst12.Parent = inst8
        end
    end
end
do
    local inst4 = Instance.new("ScreenGui")
    inst4.Name = "TradeWindow"
    inst4.Parent = Screens
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "Background"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0.15000000596046448
        inst8.Position = UDim2.new(0, 0, 0, 0)
        inst8.BackgroundColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(1, 0, 1, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
    end
    do
        local inst8 = Instance.new("Frame")
        inst8.Name = "MainFrame"
        inst8.Visible = true
        inst8.LayoutOrder = 0
        inst8.AutomaticSize = Enum.AutomaticSize.None
        inst8.AnchorPoint = Vector2.new(0, 0)
        inst8.Rotation = 0
        inst8.BackgroundTransparency = 0
        inst8.Position = UDim2.new(0.125, 0, 0.224999994, 0)
        inst8.BackgroundColor3 = Color3.new(0.109804, 0.12549, 0.188235)
        inst8.ZIndex = 1
        inst8.BorderSizePixel = 0
        inst8.Size = UDim2.new(0.75, 0, 0.550000012, 0)
        inst8.Parent = inst4
        do
            local inst12 = Instance.new("UICorner")
            inst12.Name = "UICorner"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIStroke")
            inst12.Name = "UIStroke"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("UIGradient")
            inst12.Name = "UIGradient"
            inst12.Parent = inst8
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TitleBar"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0, 0, 0, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(1, 0, 0.0700000003, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "Title"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(0.5, 0, 1, 0)
                inst16.TextColor3 = Color3.new(0.392157, 0.862745, 1.0)
                inst16.LayoutOrder = 0
                inst16.Text = "TRADING"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 24
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamBold
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0199999996, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextButton")
                inst16.Name = "CloseButton"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(0.0799999982, 0, 0.5, 0)
                inst16.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                inst16.LayoutOrder = 0
                inst16.Text = "\u2715"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 16
                inst16.Rotation = 0
                inst16.Font = Enum.Font.Gotham
                inst16.BackgroundTransparency = 0
                inst16.Position = UDim2.new(0.920000017, 0, 0.25, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Center
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UICorner")
                    inst20.Name = "UICorner"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("UIStroke")
                    inst20.Name = "UIStroke"
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "PlayerList"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.0399999991, 0, 0.100000001, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.300000012, -10, 0.649999976, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "PlayerListTitle"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, -10, 0.100000001, 0)
                inst16.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst16.LayoutOrder = 0
                inst16.Text = "NEARBY PLAYERS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("ScrollingFrame")
                inst16.Name = "PlayerScroll"
                inst16.Visible = true
                inst16.LayoutOrder = 0
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.Rotation = 0
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0.0500000007, 0, 0.119999997, 0)
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 0
                inst16.Size = UDim2.new(1, -10, 0.800000012, 0)
                inst16.Parent = inst12
                do
                    local inst20 = Instance.new("UIListLayout")
                    inst20.Name = "UIListLayout"
                    inst20.Parent = inst16
                end
                do
                    local inst20 = Instance.new("TextLabel")
                    inst20.Name = "EmptyState"
                    inst20.Visible = true
                    inst20.TextWrapped = true
                    inst20.AnchorPoint = Vector2.new(0, 0)
                    inst20.ZIndex = 1
                    inst20.BorderSizePixel = 1
                    inst20.Size = UDim2.new(1, 0, 0.100000001, 0)
                    inst20.TextColor3 = Color3.new(0.901961, 0.921569, 0.960784)
                    inst20.LayoutOrder = 0
                    inst20.Text = "No nearby players"
                    inst20.AutomaticSize = Enum.AutomaticSize.None
                    inst20.TextSize = 14
                    inst20.Rotation = 0
                    inst20.Font = Enum.Font.Gotham
                    inst20.BackgroundTransparency = 1
                    inst20.Position = UDim2.new(0, 0, 0.400000006, 0)
                    inst20.TextXAlignment = Enum.TextXAlignment.Center
                    inst20.TextYAlignment = Enum.TextYAlignment.Center
                    inst20.TextScaled = true
                    inst20.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                    inst20.Parent = inst16
                end
            end
        end
        do
            local inst12 = Instance.new("Frame")
            inst12.Name = "TradeSlots"
            inst12.Visible = true
            inst12.LayoutOrder = 0
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.Rotation = 0
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.360000014, 0, 0.5, 0)
            inst12.BackgroundColor3 = Color3.new(0.0784314, 0.0862745, 0.137255)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.600000024, 0, 0.400000006, 0)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("TextLabel")
                inst16.Name = "TradeSlotsTitle"
                inst16.Visible = true
                inst16.TextWrapped = true
                inst16.AnchorPoint = Vector2.new(0, 0)
                inst16.ZIndex = 1
                inst16.BorderSizePixel = 1
                inst16.Size = UDim2.new(1, 0, 0.150000006, 0)
                inst16.TextColor3 = Color3.new(0.54902, 0.588235, 0.666667)
                inst16.LayoutOrder = 0
                inst16.Text = "TRADE ITEMS"
                inst16.AutomaticSize = Enum.AutomaticSize.None
                inst16.TextSize = 14
                inst16.Rotation = 0
                inst16.Font = Enum.Font.GothamMedium
                inst16.BackgroundTransparency = 1
                inst16.Position = UDim2.new(0, 0, 0, 0)
                inst16.TextXAlignment = Enum.TextXAlignment.Left
                inst16.TextYAlignment = Enum.TextYAlignment.Center
                inst16.TextScaled = true
                inst16.BackgroundColor3 = Color3.new(0.639216, 0.635294, 0.647059)
                inst16.Parent = inst12
            end
        end
        do
            local inst12 = Instance.new("TextButton")
            inst12.Name = "ConfirmButton"
            inst12.Visible = true
            inst12.TextWrapped = true
            inst12.AnchorPoint = Vector2.new(0, 0)
            inst12.ZIndex = 1
            inst12.BorderSizePixel = 0
            inst12.Size = UDim2.new(0.600000024, 0, 0.0599999987, 0)
            inst12.TextColor3 = Color3.new(0.0509804, 0.105882, 0.164706)
            inst12.LayoutOrder = 0
            inst12.Text = "TRADE"
            inst12.AutomaticSize = Enum.AutomaticSize.None
            inst12.TextSize = 16
            inst12.Rotation = 0
            inst12.Font = Enum.Font.GothamBold
            inst12.BackgroundTransparency = 0
            inst12.Position = UDim2.new(0.200000003, 0, 0.920000017, 0)
            inst12.TextXAlignment = Enum.TextXAlignment.Center
            inst12.TextYAlignment = Enum.TextYAlignment.Center
            inst12.TextScaled = true
            inst12.BackgroundColor3 = Color3.new(1.0, 0.717647, 0.301961)
            inst12.Parent = inst8
            do
                local inst16 = Instance.new("UICorner")
                inst16.Name = "UICorner"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIStroke")
                inst16.Name = "UIStroke"
                inst16.Parent = inst12
            end
            do
                local inst16 = Instance.new("UIGradient")
                inst16.Name = "UIGradient"
                inst16.Parent = inst12
            end
        end
    end
end

Screens.Parent = AetherUI
return Screens
