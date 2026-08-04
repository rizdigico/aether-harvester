--!strict
-- LoadingSpinner.luau
-- 40px ring with animated arc.

local Theme = require(script.Parent.Theme)

export type LoadingSpinnerProps = {
    Parent: Instance?,
    Size: number?,
    Label: string?,
}

local LoadingSpinner = {}

function LoadingSpinner.new(props: LoadingSpinnerProps): Frame
    local parent: Instance? = props.Parent
    local size: number = props.Size or Theme.Size.SPINNER_SIZE
    local label: string? = props.Label

    local frame = Instance.new("Frame")
    frame.Name = "AetherSpinner"
    frame.Size = UDim2.new(0, size, 0, size)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    -- static ring
    local ring = Instance.new("Frame")
    ring.Name = "Ring"
    ring.Size = UDim2.new(1, 0, 1, 0)
    ring.BackgroundTransparency = 1
    ring.Parent = frame

    local ringStroke = Instance.new("UIStroke")
    ringStroke.Name = "RingStroke"
    ringStroke.Color = Theme.Color.BORDER_SUBTLE
    ringStroke.Thickness = Theme.Size.SPINNER_STROKE
    ringStroke.Transparency = 0
    ringStroke.Parent = ring

    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent = ring

    -- spinning arc
    local arc = Instance.new("Frame")
    arc.Name = "Arc"
    arc.Size = UDim2.new(1, 0, 1, 0)
    arc.BackgroundTransparency = 1
    arc.Parent = frame

    local arcStroke = Instance.new("UIStroke")
    arcStroke.Name = "ArcStroke"
    arcStroke.Color = Theme.Color.AETHER_CYAN
    arcStroke.Thickness = Theme.Size.SPINNER_STROKE
    arcStroke.Transparency = 0.2
    arcStroke.Parent = arc

    local arcCorner = Instance.new("UICorner")
    arcCorner.CornerRadius = UDim.new(1, 0)
    arcCorner.Parent = arc

    -- rotate via TweenService
    local TweenService = game:GetService("TweenService")
    local spinInfo = TweenInfo.new(0.8, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
    local spinTween = TweenService:Create(arc, spinInfo, { Rotation = 360 })
    spinTween:Play()

    -- label below
    if label then
        local labelObj = Instance.new("TextLabel")
        labelObj.Name = "Label"
        labelObj.Size = UDim2.new(0, 0, 0, 16)
        labelObj.AutomaticSize = Enum.AutomaticSize.XY
        labelObj.Position = UDim2.new(0.5, 0, 1, Theme.Spacing.SP3)
        labelObj.AnchorPoint = Vector2.new(0.5, 0)
        labelObj.BackgroundTransparency = 1
        labelObj.Text = label
        labelObj.TextColor3 = Theme.Color.TEXT_SECONDARY
        labelObj.Font = Theme.Font.CAPTION.Weight
        labelObj.TextSize = Theme.Font.CAPTION.Size
        labelObj.Parent = frame
    end

    local connections: { RBXScriptConnection } = {}

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        spinTween:Cancel()
        frame:Destroy()
    end

    frame:SetAttribute("_AetherDestroy", destroy)

    return frame
end

return LoadingSpinner
