--!strict
-- TabBar.luau
-- Height 44px, active bottom border, inactive secondary text.

local Theme = require(script.Parent.Theme)

export type TabBarProps = {
    Tabs: { string },
    ActiveTab: number?,
    Parent: Instance?,
    OnTabChanged: ((index: number) -> ())?,
}

local TabBar = {}

function TabBar.new(props: TabBarProps): Frame
    local tabs: { string } = props.Tabs
    local activeTab: number = props.ActiveTab or 1
    local parent: Instance? = props.Parent
    local onTabChanged: ((index: number) -> ())? = props.OnTabChanged

    local frame = Instance.new("Frame")
    frame.Name = "AetherTabBar"
    frame.Size = UDim2.new(1, 0, 0, Theme.Size.TAB_BAR_HEIGHT)
    frame.BackgroundColor3 = Theme.Color.BG_DIM
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Radius.SM)
    corner.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, Theme.Spacing.SP2)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP3)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP3)
    pad.Parent = frame

    local buttons: { TextButton } = {}
    local connections: { RBXScriptConnection } = {}

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = tabName
        btn.Size = UDim2.new(0, 0, 0, Theme.Size.TAB_BAR_HEIGHT - Theme.Spacing.SP2)
        btn.AutomaticSize = Enum.AutomaticSize.XY
        btn.BackgroundTransparency = 1
        btn.Text = tabName
        btn.TextColor3 = if i == activeTab then Theme.Color.TEXT_PRIMARY else Theme.Color.TEXT_SECONDARY
        btn.Font = Theme.Font.BUTTON.Weight
        btn.TextSize = Theme.Font.BUTTON.Size
        btn.AutoButtonColor = false
        btn.Parent = frame

        -- indicator
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(1, 0, 0, Theme.Stroke.MEDIUM)
        indicator.Position = UDim2.new(0, 0, 1, 0)
        indicator.BackgroundColor3 = if i == activeTab then Theme.Color.AETHER_CYAN else Theme.Color.BG_DIM
        indicator.Parent = btn

        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, Theme.Radius.SM)
        indicatorCorner.Parent = indicator

        local currentIndex: number = i
        local currentIndicator: Frame = indicator

        table.insert(
            connections,
            btn.MouseButton1Click:Connect(function()
                for _, b in ipairs(buttons) do
                    b.TextColor3 = Theme.Color.TEXT_SECONDARY
                    local ind = b:FindFirstChild("Indicator")
                    if ind then
                        ind.BackgroundColor3 = Theme.Color.BG_DIM
                    end
                end
                btn.TextColor3 = Theme.Color.TEXT_PRIMARY
                currentIndicator.BackgroundColor3 = Theme.Color.AETHER_CYAN
                if onTabChanged then
                    onTabChanged(currentIndex)
                end
            end)
        )

        table.insert(buttons, btn)
    end

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        table.clear(buttons)
        frame:Destroy()
    end

    frame:SetAttribute("_AetherDestroy", destroy)

    return frame
end

return TabBar
