--!strict
-- Input.luau
-- Height 44px, focus ring + glow, error state, helper text.

local Theme = require(script.Parent.Theme)

export type InputProps = {
    Placeholder: string?,
    Value: string?,
    Error: string?,
    Disabled: boolean?,
    Parent: Instance?,
    OnChanged: ((value: string) -> ())?,
}

local Input = {}

function Input.new(props: InputProps): Frame
    local placeholder: string? = props.Placeholder
    local value: string? = props.Value or ""
    local errorText: string? = props.Error
    local disabled: boolean = props.Disabled or false
    local parent: Instance? = props.Parent
    local onChanged: ((value: string) -> ())? = props.OnChanged

    local frame = Instance.new("Frame")
    frame.Name = "AetherInput"
    frame.Size = UDim2.new(1, 0, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    -- textbox container
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(1, 0, 0, Theme.Size.INPUT_HEIGHT)
    box.BackgroundColor3 = Theme.Color.BG_ELEVATED
    box.Parent = frame

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, Theme.Radius.MD)
    boxCorner.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Name = "Border"
    boxStroke.Color = if errorText then Theme.Color.DANGER else Theme.Color.BORDER_SUBTLE
    boxStroke.Thickness = Theme.Stroke.THIN
    boxStroke.Parent = box

    local boxPad = Instance.new("UIPadding")
    boxPad.PaddingLeft = UDim.new(0, Theme.Spacing.SP5)
    boxPad.PaddingRight = UDim.new(0, Theme.Spacing.SP5)
    boxPad.Parent = box

    local textbox = Instance.new("TextBox")
    textbox.Name = "Text"
    textbox.Size = UDim2.new(1, 0, 1, 0)
    textbox.BackgroundTransparency = 1
    textbox.Text = value or ""
    textbox.PlaceholderText = placeholder or ""
    textbox.PlaceholderColor3 = Theme.Color.TEXT_SECONDARY
    textbox.TextColor3 = Theme.Color.TEXT_PRIMARY
    textbox.Font = Theme.Font.BODY.Weight
    textbox.TextSize = Theme.Font.BODY.Size
    textbox.TextXAlignment = Enum.TextXAlignment.Left
    textbox.ClearTextOnFocus = false
    textbox.Parent = box

    if disabled then
        textbox.Interactable = false
        textbox.TextTransparency = 0.4
    end

    -- error helper
    if errorText then
        local helper = Instance.new("TextLabel")
        helper.Name = "Helper"
        helper.Size = UDim2.new(1, 0, 0, 0)
        helper.AutomaticSize = Enum.AutomaticSize.Y
        helper.BackgroundTransparency = 1
        helper.Text = errorText
        helper.TextColor3 = Theme.Color.DANGER
        helper.Font = Theme.Font.CAPTION.Weight
        helper.TextSize = Theme.Font.CAPTION.Size
        helper.TextXAlignment = Enum.TextXAlignment.Left
        helper.TextYAlignment = Enum.TextYAlignment.Top
        helper.LayoutOrder = 1
        helper.Parent = frame

        local helperPad = Instance.new("UIPadding")
        helperPad.PaddingTop = UDim.new(0, Theme.Spacing.SP2)
        helperPad.PaddingLeft = UDim.new(0, Theme.Spacing.SP2)
        helperPad.Parent = helper
    end

    -- focus glow
    local function onFocus()
        boxStroke.Color = Theme.Color.AETHER_CYAN
        boxStroke.Thickness = Theme.Stroke.MEDIUM
    end

    local function onFocusLost()
        boxStroke.Color = if errorText then Theme.Color.DANGER else Theme.Color.BORDER_SUBTLE
        boxStroke.Thickness = Theme.Stroke.THIN
    end

    textbox.Focused:Connect(onFocus)
    textbox.FocusLost:Connect(onFocusLost)

    local connections: { RBXScriptConnection } = {}
    table.insert(
        connections,
        textbox.TextChanged:Connect(function()
            if onChanged then
                onChanged(textbox.Text)
            end
        end)
    )

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

return Input
