--!strict
-- Toggle.luau
-- Track 44x24, thumb 20px, label left, toggle right.

local Theme = require(script.Parent.Theme)

export type ToggleProps = {
    Label: string,
    Value: boolean?,
    Disabled: boolean?,
    Parent: Instance?,
    OnChanged: ((value: boolean) -> ())?,
}

local Toggle = {}

function Toggle.new(props: ToggleProps): Frame
    local label: string = props.Label
    local value: boolean = props.Value or false
    local disabled: boolean = props.Disabled or false
    local parent: Instance? = props.Parent
    local onChanged: ((value: boolean) -> ())? = props.OnChanged

    local frame = Instance.new("Frame")
    frame.Name = "AetherToggle"
    frame.Size = UDim2.new(0, 0, 0, Theme.Size.TOGGLE_TRACK_HEIGHT)
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.Padding = UDim.new(0, Theme.Spacing.SP3)
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.Parent = frame

    local labelObj = Instance.new("TextLabel")
    labelObj.Name = "Label"
    labelObj.Size = UDim2.new(0, 0, 0, 0)
    labelObj.AutomaticSize = Enum.AutomaticSize.XY
    labelObj.BackgroundTransparency = 1
    labelObj.Text = label
    labelObj.TextColor3 = if disabled then Theme.Color.TEXT_SECONDARY else Theme.Color.TEXT_PRIMARY
    labelObj.Font = Theme.Font.BODY.Weight
    labelObj.TextSize = Theme.Font.BODY.Size
    labelObj.TextXAlignment = Enum.TextXAlignment.Left
    labelObj.TextYAlignment = Enum.TextYAlignment.Center
    labelObj.Parent = frame

    -- track
    local track = Instance.new("TextButton")
    track.Name = "Track"
    track.Size = UDim2.new(0, Theme.Size.TOGGLE_TRACK_WIDTH, 0, Theme.Size.TOGGLE_TRACK_HEIGHT)
    track.BackgroundColor3 = if value then Theme.Color.AETHER_CYAN_DIM else Theme.Color.BG_DIM
    track.Text = ""
    track.AutoButtonColor = false
    track.Parent = frame

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
    trackCorner.Parent = track

    -- thumb
    local thumb = Instance.new("Frame")
    thumb.Name = "Thumb"
    thumb.Size = UDim2.new(0, Theme.Size.TOGGLE_THUMB_SIZE, 0, Theme.Size.TOGGLE_THUMB_SIZE)
    thumb.Position = UDim2.new(0, Theme.Spacing.SP2, 0.5, 0)
    thumb.AnchorPoint = Vector2.new(0, 0.5)
    thumb.BackgroundColor3 = Theme.Color.TEXT_PRIMARY
    thumb.Parent = track

    local thumbCorner = Instance.new("UICorner")
    thumbCorner.CornerRadius = UDim.new(0, Theme.Radius.FULL)
    thumbCorner.Parent = thumb

    local function setState(on: boolean)
        value = on
        track.BackgroundColor3 = if on then Theme.Color.AETHER_CYAN_DIM else Theme.Color.BG_DIM
        thumb.Position = UDim2.new(
            0,
            if on
                then Theme.Size.TOGGLE_TRACK_WIDTH - Theme.Size.TOGGLE_THUMB_SIZE - Theme.Spacing.SP2
                else Theme.Spacing.SP2,
            0.5,
            0
        )
        if onChanged then
            onChanged(on)
        end
    end

    local connections: { RBXScriptConnection } = {}

    if not disabled then
        table.insert(
            connections,
            track.MouseButton1Click:Connect(function()
                setState(not value)
            end)
        )
    end

    setState(value)

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

return Toggle
