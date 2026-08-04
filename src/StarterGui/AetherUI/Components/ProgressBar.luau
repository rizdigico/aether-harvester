--!strict
-- ProgressBar.luau
-- Track 8px, fill gradient aether-cyan -> aether-cyan-dim, label above.

local Theme = require(script.Parent.Theme)

export type ProgressBarProps = {
    Value: number,
    Max: number?,
    Label: string?,
    Parent: Instance?,
}

local ProgressBar = {}

function ProgressBar.new(props: ProgressBarProps): Frame
    local value: number = props.Value or 0
    local max: number = props.Max or 100
    local label: string? = props.Label
    local parent: Instance? = props.Parent

    local frame = Instance.new("Frame")
    frame.Name = "AetherProgressBar"
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    -- label
    if label then
        local labelObj = Instance.new("TextLabel")
        labelObj.Name = "Label"
        labelObj.Size = UDim2.new(1, 0, 0, 0)
        labelObj.AutomaticSize = Enum.AutomaticSize.Y
        labelObj.BackgroundTransparency = 1
        labelObj.Text = label
        labelObj.TextColor3 = Theme.Color.TEXT_SECONDARY
        labelObj.Font = Theme.Font.CAPTION.Weight
        labelObj.TextSize = Theme.Font.CAPTION.Size
        labelObj.TextXAlignment = Enum.TextXAlignment.Left
        labelObj.TextYAlignment = Enum.TextYAlignment.Top
        labelObj.LayoutOrder = 1
        labelObj.Parent = frame

        local pad = Instance.new("UIPadding")
        pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP2)
        pad.Parent = labelObj
    end

    -- track
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, Theme.Size.PROGRESS_BAR_HEIGHT)
    track.BackgroundColor3 = Theme.Color.BORDER_SUBTLE
    track.LayoutOrder = 2
    track.Parent = frame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
    trackCorner.Parent = track

    -- fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(math.clamp(value / max, 0, 1), 0, 1, 0)
    fill.BackgroundColor3 = Theme.Color.AETHER_CYAN
    fill.Parent = track

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(Theme.Color.AETHER_CYAN, Theme.Color.AETHER_CYAN_DIM)
    fillGrad.Parent = fill

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
    fillCorner.Parent = fill

    return frame
end

return ProgressBar
