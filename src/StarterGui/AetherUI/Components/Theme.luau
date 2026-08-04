--!strict
-- Theme.luau
-- Centralized design tokens for Aether Harvester UI.
-- All colors, typography, spacing, radius, strokes, shadows, and animation timings
-- are defined here. Components must reference these tokens and never hard-code magic numbers.

local Theme = {}

-- === 2.1 Color Tokens ===

Theme.Color = {
    -- Semantic
    BG_DEEP = Color3.fromRGB(10, 12, 20),
    BG_BASE = Color3.fromRGB(20, 22, 35),
    BG_DIM = Color3.fromRGB(26, 29, 46),
    BG_ELEVATED = Color3.fromRGB(34, 38, 57),
    BG_OVERLAY = Color3.fromRGB(10, 12, 20), -- overlay uses deep with alpha
    BG_MODAL = Color3.fromRGB(34, 38, 57),
    BG_TOAST = Color3.fromRGB(34, 38, 57),
    BG_TOOLTIP = Color3.fromRGB(34, 38, 57),

    AETHER_CYAN = Color3.fromRGB(100, 200, 255),
    AETHER_CYAN_DIM = Color3.fromRGB(58, 138, 179),

    TEXT_PRIMARY = Color3.fromRGB(232, 234, 246),
    TEXT_SECONDARY = Color3.fromRGB(154, 160, 184),

    BORDER_SUBTLE = Color3.fromRGB(42, 46, 66),

    SUCCESS = Color3.fromRGB(52, 211, 153),
    WARNING = Color3.fromRGB(251, 191, 36),
    DANGER = Color3.fromRGB(248, 113, 113),
    FOCUS_RING = Color3.fromRGB(100, 200, 255),

    -- Rarity ladder
    RARITY_COMMON = Color3.fromRGB(232, 234, 246),
    RARITY_UNCOMMON = Color3.fromRGB(52, 211, 153),
    RARITY_RARE = Color3.fromRGB(96, 165, 250),
    RARITY_EPIC = Color3.fromRGB(167, 139, 250),
    RARITY_LEGENDARY = Color3.fromRGB(251, 191, 36),
    RARITY_MYTHRIL = Color3.fromRGB(240, 171, 252),
}

-- === 2.2 Typography ===

Theme.Font = {
    FAMILY = Enum.Font.Gotham,

    -- { Weight, Size, LineHeight }
    H1 = { Weight = Enum.Font.Gotham, Size = 32, LineHeight = 38 },
    H2 = { Weight = Enum.Font.Gotham, Size = 24, LineHeight = 30 },
    H3 = { Weight = Enum.Font.Gotham, Size = 20, LineHeight = 26 },
    BODY = { Weight = Enum.Font.Gotham, Size = 16, LineHeight = 24 },
    CAPTION = { Weight = Enum.Font.Gotham, Size = 12, LineHeight = 16 },
    BUTTON = { Weight = Enum.Font.Gotham, Size = 14, LineHeight = 18 },
    NUMERAL = { Weight = Enum.Font.Gotham, Size = 20, LineHeight = 24 },
}

-- === 2.3 Spacing ===

Theme.Spacing = {
    SP2 = 4,
    SP3 = 8,
    SP4 = 12,
    SP5 = 16,
    SP6 = 24,
    SP8 = 32,
    SP10 = 48,
}

-- === 2.4 Corner Radius ===

Theme.Radius = {
    SM = 4,
    MD = 8,
    LG = 12,
    XL = 16,
    FULL = 9999,
}

-- === 2.5 Stroke Weights ===

Theme.Stroke = {
    THIN = 1,
    MEDIUM = 2,
    THICK = 3,
}

-- === 2.6 Shadow System (UIGradient / UIStroke values) ===

Theme.Shadow = {
    -- { Blur, OffsetY, Color }
    SM = { Blur = 4, OffsetY = 2, Color = Color3.fromRGB(0, 0, 0), Alpha = 0.3 },
    MD = { Blur = 8, OffsetY = 4, Color = Color3.fromRGB(0, 0, 0), Alpha = 0.4 },
    LG = { Blur = 16, OffsetY = 8, Color = Color3.fromRGB(0, 0, 0), Alpha = 0.5 },
    GLOW = { Blur = 12, OffsetY = 0, Color = Theme.Color.AETHER_CYAN, Alpha = 0.25 },
}

-- === 2.7 Surface Hierarchy (z-index bands) ===

Theme.ZIndex = {
    BG = 0,
    PANEL = 10,
    DIM = 20,
    ELEVATED = 30,
    OVERLAY = 40,
    MODAL = 50,
    TOAST = 60,
    TOOLTIP = 70,
}

-- === 2.8 Animation Timings ===

Theme.Animation = {
    FAST = 0.1, -- ease-out
    BASE = 0.2, -- ease-out
    SLOW = 0.4, -- ease-in-out
    GLOW = 1.2, -- ease-in-out
}

-- === 2.9 Sizes ===

Theme.Size = {
    TOUCH_MIN = 44, -- minimum touch target px
    BUTTON_COMPACT = 32,
    BUTTON_DEFAULT = 44,
    BUTTON_LARGE = 56,
    PANEL_PADDING = Theme.Spacing.SP6,
    CARD_RADIUS = Theme.Radius.XL,
    MODAL_MAX_WIDTH = 520,
    TOOLTIP_MAX_WIDTH = 280,
    TOAST_BORDER = 3,
    LIST_ITEM_HEIGHT = 56,
    TAB_BAR_HEIGHT = 44,
    SLIDER_TRACK_HEIGHT = 4,
    SLIDER_THUMB_SIZE = 20,
    TOGGLE_TRACK_WIDTH = 44,
    TOGGLE_TRACK_HEIGHT = 24,
    TOGGLE_THUMB_SIZE = 20,
    INPUT_HEIGHT = 44,
    BADGE_HEIGHT = 20,
    PROGRESS_BAR_HEIGHT = 8,
    CURRENCY_ICON_SIZE = 16,
    SPINNER_SIZE = 40,
    SPINNER_STROKE = 3,
    SCROLLBAR_WIDTH = 4,
}

-- === Rarity lookup helper ===

function Theme.GetRarityColor(rarity: string?): Color3
    if not rarity then
        return Theme.Color.RARITY_COMMON
    end
    local lower = string.lower(rarity)
    if lower == "common" then
        return Theme.Color.RARITY_COMMON
    elseif lower == "uncommon" then
        return Theme.Color.RARITY_UNCOMMON
    elseif lower == "rare" then
        return Theme.Color.RARITY_RARE
    elseif lower == "epic" then
        return Theme.Color.RARITY_EPIC
    elseif lower == "legendary" then
        return Theme.Color.RARITY_LEGENDARY
    elseif lower == "mythril" then
        return Theme.Color.RARITY_MYTHRIL
    end
    return Theme.Color.RARITY_COMMON
end

return Theme
