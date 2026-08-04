--!strict
-- Tooltip.luau
-- Anchored to a target, max width 280px, delay show 400ms, hide 200ms.

local Theme = require(script.Parent.Theme)

export type TooltipProps = {
    Text: string,
    Target: GuiObject,
    Parent: Instance?,
    Delay: number?,
}

local Tooltip = {}

function Tooltip.new(props: TooltipProps): Frame
    local text: string = props.Text
    local target: GuiObject = props.Target
    local parent: Instance? = props.Parent
    local delay: number = props.Delay or 0.4

    local frame = Instance.new("Frame")
    frame.Name = "AetherTooltip"
    frame.Size = UDim2.new(0, Theme.Size.TOOLTIP_MAX_WIDTH, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = Theme.Color.BG_ELEVATED
    frame.ZIndex = Theme.ZIndex.TOOLTIP
    frame.Visible = false
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.Radius.MD)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Color.BORDER_SUBTLE
    stroke.Thickness = Theme.Stroke.THIN
    stroke.Parent = frame

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP4)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP4)
    pad.Parent = frame

    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.Size = UDim2.new(1, 0, 0, 0)
    label.AutomaticSize = Enum.AutomaticSize.Y
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Color.TEXT_PRIMARY
    label.Font = Theme.Font.CAPTION.Weight
    label.TextSize = Theme.Font.CAPTION.Size
    label.TextWrapped = true
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.Parent = frame

    -- arrow
    local arrow = Instance.new("Frame")
    arrow.Name = "Arrow"
    arrow.Size = UDim2.new(0, 8, 0, 8)
    arrow.BackgroundColor3 = Theme.Color.BG_ELEVATED
    arrow.Rotation = 45
    arrow.Parent = frame

    local arrowStroke = Instance.new("UIStroke")
    arrowStroke.Color = Theme.Color.BORDER_SUBTLE
    arrowStroke.Thickness = Theme.Stroke.THIN
    arrowStroke.Transparency = 0.5
    arrowStroke.Parent = arrow

    local arrowCorner = Instance.new("UICorner")
    arrowCorner.CornerRadius = UDim.new(0, 1)
    arrowCorner.Parent = arrow

    -- positioning helper
    local function position()
        local absPos = target.AbsolutePosition
        local absSize = target.AbsoluteSize
        frame.Position = UDim2.new(
            0,
            absPos.X - (Theme.Size.TOOLTIP_MAX_WIDTH / 2) + (absSize.X / 2),
            0,
            absPos.Y - frame.AbsoluteSize.Y - 8
        )
    end

    -- delay show
    local showThread: thread? = nil
    local hideThread: thread? = nil

    local function show()
        hideThread = task.cancel(hideThread)
        showThread = task.delay(delay, function()
            frame.Visible = true
            position()
        end)
    end

    local function hide()
        showThread = task.cancel(showThread)
        hideThread = task.delay(0.2, function()
            frame.Visible = false
        end)
    end

    target.MouseEnter:Connect(show)
    target.MouseLeave:Connect(hide)
    target.Destroying:Connect(hide)

    local connections: { RBXScriptConnection } = {}

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        showThread = task.cancel(showThread)
        hideThread = task.cancel(hideThread)
        frame:Destroy()
    end

    frame:SetAttribute("_AetherDestroy", destroy)

    return frame
end

return Tooltip
