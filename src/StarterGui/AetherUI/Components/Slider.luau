--!strict
-- Slider.luau
-- Track 4px, thumb 20px, touch target 44px tall, value bubble on drag.

local Theme = require(script.Parent.Theme)

export type SliderProps = {
    Min: number,
    Max: number,
    Value: number?,
    Step: number?,
    Parent: Instance?,
    OnChanged: ((value: number) -> ())?,
}

local Slider = {}

function Slider.new(props: SliderProps): Frame
    local min: number = props.Min or 0
    local max: number = props.Max or 100
    local value: number = props.Value or min
    local step: number = props.Step or 1
    local parent: Instance? = props.Parent
    local onChanged: ((value: number) -> ())? = props.OnChanged

    local frame = Instance.new("Frame")
    frame.Name = "AetherSlider"
    frame.Size = UDim2.new(1, 0, 0, Theme.Size.INPUT_HEIGHT)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP2)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP2)
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP2)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP2)
    pad.Parent = frame

    -- track background
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.new(1, 0, 0, Theme.Size.SLIDER_TRACK_HEIGHT)
    track.Position = UDim2.new(0, 0, 0.5, 0)
    track.AnchorPoint = Vector2.new(0, 0.5)
    track.BackgroundColor3 = Theme.Color.BORDER_SUBTLE
    track.Parent = frame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, Theme.Radius.SM)
    trackCorner.Parent = track

    -- fill
    local fill = Instance.new("Frame")
    fill.Name = "Fill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Theme.Color.AETHER_CYAN
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, Theme.Radius.SM)
    fillCorner.Parent = fill

    -- thumb (invisible but 44px tall for touch target)
    local thumb = Instance.new("TextButton")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, Theme.Size.SLIDER_THUMB_SIZE, 0, Theme.Size.TOUCH_MIN)
    thumb.Position = UDim2.new(0, 0, 0.5, 0)
    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    thumb.BackgroundColor3 = Theme.Color.BG_ELEVATED
    thumb.Text = ""
    thumb.AutoButtonColor = false
    thumb.Parent = frame

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
    thumbCorner.Parent = thumb

    local thumbStroke = Instance.new("UIStroke")
    thumbStroke.Color = Theme.Color.AETHER_CYAN
    thumbStroke.Thickness = Theme.Stroke.MEDIUM
    thumbStroke.Parent = thumb

    -- value bubble
    local bubble = Instance.new("TextLabel")
    bubble.Name = "Bubble"
    bubble.Size = UDim2.new(0, 40, 0, 24)
    bubble.AnchorPoint = Vector2.new(0.5, 1)
    bubble.Position = UDim2.new(0.5, 0, 0, -12)
    bubble.BackgroundColor3 = Theme.Color.AETHER_CYAN
    bubble.Text = tostring(value)
    bubble.TextColor3 = Theme.Color.BG_DEEP
    bubble.Font = Theme.Font.BUTTON.Weight
    bubble.TextSize = Theme.Font.BUTTON.Size
    bubble.Visible = false
    bubble.Parent = thumb

    local bubbleCorner = Instance.new("UICorner")
    bubbleCorner.CornerRadius = UDim.new(0, Theme.Radius.SM)
    bubbleCorner.Parent = bubble

    local function updateFromInput(inputPos: number)
        local relative = math.clamp((inputPos - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        local raw = min + relative * (max - min)
        local stepped = math.floor(raw / step + 0.5) * step
        value = math.clamp(stepped, min, max)
        local fraction = (value - min) / (max - min)
        fill.Size = UDim2.new(fraction, 0, 1, 0)
        thumb.Position = UDim2.new(fraction, 0, 0.5, 0)
        bubble.Text = tostring(math.floor(value))
        if onChanged then
            onChanged(value)
        end
    end

    local dragging: boolean = false
    local connections: { RBXScriptConnection } = {}

    local function onInputBegan(input: InputObject)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragging = true
            bubble.Visible = true
            updateFromInput(input.Position.X)
        end
    end

    local function onInputChanged(input: InputObject)
        if
            dragging
            and (
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            )
        then
            updateFromInput(input.Position.X)
        end
    end

    local function onInputEnded()
        dragging = false
        bubble.Visible = false
    end

    thumb.InputBegan:Connect(onInputBegan)
    thumb.InputChanged:Connect(onInputChanged)
    frame.InputBegan:Connect(onInputBegan)
    frame.InputChanged:Connect(onInputChanged)
    table.insert(connections, frame.InputEnded:Connect(onInputEnded))
    table.insert(connections, thumb.InputEnded:Connect(onInputEnded))

    -- initial value
    local initFraction = (value - min) / (max - min)
    fill.Size = UDim2.new(initFraction, 0, 1, 0)
    thumb.Position = UDim2.new(initFraction, 0, 0.5, 0)

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        frame:Destroy()
    end

    frame:SetAttribute("_AetherDestroy", destroy)

    return frame
end

return Slider
