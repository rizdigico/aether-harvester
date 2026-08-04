--!strict
-- Button.luau
-- Variants: primary / secondary / danger / ghost
-- Sizes: small / medium / large (compact/default/large)
-- States: default / hover / active / disabled / loading

local Theme = require(script.Parent.Theme)

export type ButtonVariant = "primary" | "secondary" | "danger" | "ghost"
export type ButtonSize = "small" | "medium" | "large"
export type ButtonProps = {
    Text: string?,
    Variant: ButtonVariant?,
    Size: ButtonSize?,
    Disabled: boolean?,
    Loading: boolean?,
    Parent: Instance?,
    OnClick: (() -> ())?,
}

local Button = {}

local SIZE_MAP = {
    small = Theme.Size.BUTTON_COMPACT,
    medium = Theme.Size.BUTTON_DEFAULT,
    large = Theme.Size.BUTTON_LARGE,
}

local function applyVariant(button: TextButton, variant: ButtonVariant)
    local bg: Color3
    local textColor: Color3
    local border: Color3?
    local borderWidth: number
    local shadow: boolean

    if variant == "primary" then
        bg = Theme.Color.AETHER_CYAN
        textColor = Theme.Color.BG_DEEP
        border = nil
        borderWidth = 0
        shadow = true
    elseif variant == "secondary" then
        bg = Theme.Color.BG_ELEVATED
        textColor = Theme.Color.TEXT_PRIMARY
        border = Theme.Color.BORDER_SUBTLE
        borderWidth = Theme.Stroke.THIN
        shadow = false
    elseif variant == "danger" then
        bg = Theme.Color.DANGER
        textColor = Color3.fromRGB(255, 255, 255)
        border = nil
        borderWidth = 0
        shadow = false
    else -- ghost
        bg = Color3.fromRGB(255, 255, 255)
        textColor = Theme.Color.TEXT_SECONDARY
        border = nil
        borderWidth = 0
        shadow = false
    end

    button.BackgroundColor3 = bg
    button.TextColor3 = textColor
    button.AutoButtonColor = false

    -- stroke
    local stroke = button:FindFirstChild("Stroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = "Stroke"
        stroke.Parent = button
    end
    stroke.Color = border or Theme.Color.BORDER_SUBTLE
    stroke.Thickness = if border then borderWidth else 0

    -- shadow
    local shadowGrad = button:FindFirstChild("ShadowGrad")
    if not shadowGrad then
        shadowGrad = Instance.new("UIGradient")
        shadowGrad.Name = "ShadowGrad"
        shadowGrad.Parent = button
    end
    if shadow then
        shadowGrad.Color = ColorSequence.new(Theme.Color.AETHER_CYAN)
    else
        shadowGrad.Color = ColorSequence.new(Theme.Color.BG_ELEVATED)
    end
end

function Button.new(props: ButtonProps): TextButton
    local text: string = props.Text or "Button"
    local variant: ButtonVariant = props.Variant or "primary"
    local sizeName: ButtonSize = props.Size or "medium"
    local disabled: boolean = props.Disabled or false
    local loading: boolean = props.Loading or false
    local onClick: (() -> ())? = props.OnClick
    local parent: Instance? = props.Parent

    local height: number = SIZE_MAP[sizeName]

    local button = Instance.new("TextButton")
    button.Name = "AetherButton"
    button.Size = UDim2.new(0, 0, 0, height)
    button.AutomaticSize = Enum.AutomaticSize.XY
    button.BackgroundColor3 = Theme.Color.AETHER_CYAN
    button.Text = text
    button.TextColor3 = Theme.Color.BG_DEEP
    button.Font = Theme.Font.BUTTON.Weight
    button.TextSize = Theme.Font.BUTTON.Size
    button.AutoButtonColor = false

    -- corner
    local corner = Instance.new("UICorner")
    corner.Name = "Corner"
    corner.CornerRadius = UDim.new(0, Theme.Radius.MD)
    corner.Parent = button

    -- padding
    local pad = Instance.new("UIPadding")
    pad.Name = "Padding"
    pad.PaddingLeft = UDim.new(0, Theme.Spacing.SP5)
    pad.PaddingRight = UDim.new(0, Theme.Spacing.SP5)
    pad.PaddingTop = UDim.new(0, Theme.Spacing.SP3)
    pad.PaddingBottom = UDim.new(0, Theme.Spacing.SP3)
    pad.Parent = button

    -- focus ring (visible on selection via Selection behavior in StarterGui)
    local focusRing = Instance.new("UIStroke")
    focusRing.Name = "FocusRing"
    focusRing.Color = Theme.Color.FOCUS_RING
    focusRing.Thickness = Theme.Stroke.THICK
    focusRing.Transparency = 0.5
    focusRing.Parent = button

    applyVariant(button, variant)

    -- state: disabled
    if disabled then
        button.TextTransparency = 0.4
        button.AutoButtonColor = false
        button.Interactable = false
    end

    -- state: loading spinner container
    local spinnerParent = Instance.new("Frame")
    spinnerParent.Name = "SpinnerParent"
    spinnerParent.Size = UDim2.new(1, 0, 1, 0)
    spinnerParent.BackgroundTransparency = 1
    spinnerParent.Visible = loading
    spinnerParent.Parent = button

    local loadingLabel = Instance.new("TextLabel")
    loadingLabel.Name = "LoadingLabel"
    loadingLabel.Size = UDim2.new(1, -Theme.Spacing.SP6, 1, 0)
    loadingLabel.Position = UDim2.new(0, Theme.Spacing.SP3, 0, 0)
    loadingLabel.BackgroundTransparency = 1
    loadingLabel.Text = text .. "…"
    loadingLabel.TextColor3 = button.TextColor3
    loadingLabel.Font = button.Font
    loadingLabel.TextSize = button.TextSize
    loadingLabel.TextXAlignment = Enum.TextXAlignment.Center
    loadingLabel.TextYAlignment = Enum.TextYAlignment.Center
    loadingLabel.Parent = button

    -- connections
    local connections: { RBXScriptConnection } = {}

    local function setHover(_active: boolean)
        -- hover feedback handled via UIScale or tint in future iteration
    end

    if not disabled and not loading then
        table.insert(
            connections,
            button.MouseEnter:Connect(function()
                setHover(true)
            end)
        )
        table.insert(
            connections,
            button.MouseLeave:Connect(function()
                setHover(false)
            end)
        )
        table.insert(
            connections,
            button.MouseButton1Click:Connect(function()
                if onClick then
                    onClick()
                end
            end)
        )
    end

    if parent then
        button.Parent = parent
    end

    local function destroy()
        for _, conn in connections do
            conn:Disconnect()
        end
        table.clear(connections)
        button:Destroy()
    end

    button:SetAttribute("_AetherDestroy", destroy)

    return button
end

return Button
