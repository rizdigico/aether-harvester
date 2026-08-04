--!strict
-- RarityFrame.luau
-- 2px border + corner diamonds + glow + background gradient tinted by rarity.

local Theme = require(script.Parent.Theme)

export type RarityFrameProps = {
    Rarity: string,
    Parent: Instance?,
    Size: UDim2?,
    Position: UDim2?,
}

local RarityFrame = {}

local RARITY_COLORS = {
    common = Theme.Color.RARITY_COMMON,
    uncommon = Theme.Color.RARITY_UNCOMMON,
    rare = Theme.Color.RARITY_RARE,
    epic = Theme.Color.RARITY_EPIC,
    legendary = Theme.Color.RARITY_LEGENDARY,
    mythril = Theme.Color.RARITY_MYTHRIL,
}

function RarityFrame.new(props: RarityFrameProps): Frame
    local rarity: string = string.lower(props.Rarity)
    local parent: Instance? = props.Parent
    local size: UDim2? = props.Size
    local position: UDim2? = props.Position

    local color: Color3 = RARITY_COLORS[rarity] or Theme.Color.RARITY_COMMON

    local frame = Instance.new("Frame")
    frame.Name = "RarityFrame"
    frame.Size = size or UDim2.new(0, 56, 0, 56)
    frame.Position = position or UDim2.new(0, 0, 0, 0)
    frame.BackgroundTransparency = 1

    -- background gradient tinted by rarity at 8% opacity
    local bg = Instance.new("Frame")
    bg.Name = "Background"
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Theme.Color.BG_DIM
    bg.Parent = frame

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Name = "TintGrad"
    bgGrad.Color = ColorSequence.new(color)
    bgGrad.Transparency = NumberSequence.new(0.92)
    bgGrad.Parent = bg

    local bgCorner = Instance.new("UICorner")
    bgCorner.CornerRadius = UDim.new(0, Theme.Radius.MD)
    bgCorner.Parent = bg

    -- outer border stroke
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Border"
    stroke.Color = color
    stroke.Thickness = Theme.Stroke.MEDIUM
    stroke.Parent = frame

    -- glow
    local glow = Instance.new("UIStroke")
    glow.Name = "Glow"
    glow.Color = color
    glow.Thickness = Theme.Stroke.THICK
    glow.Transparency = 0.7
    glow.Parent = frame

    -- corner diamonds
    local DIAMOND_SIZE = 4
    local function makeDiamond(x: number, y: number): Frame
        local d = Instance.new("Frame")
        d.Name = "Diamond"
        d.Size = UDim2.new(0, DIAMOND_SIZE, 0, DIAMOND_SIZE)
        d.Position = UDim2.new(0, x, 0, y)
        d.AnchorPoint = Vector2.new(0.5, 0.5)
        d.BackgroundColor3 = color
        d.Parent = frame

        local rot = Instance.new("UIGradient")
        rot.Rotation = 45
        rot.Parent = d

        local dCorner = Instance.new("UICorner")
        dCorner.CornerRadius = UDim.new(0, 1)
        dCorner.Parent = d
        return d
    end

    makeDiamond(0, 0)
    makeDiamond(1, 0)
    makeDiamond(0, 1)
    makeDiamond(1, 1)

    if parent then
        frame.Parent = parent
    end

    return frame
end

return RarityFrame
