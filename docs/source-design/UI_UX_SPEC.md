# Aether Harvester Simulator UI/UX Design Specification

## Table of Contents
1. [Design System](#design-system)
2. [Starting Screen](#starting-screen)
3. [HUD Design](#hud-design)
4. [Menu Screens](#menu-screens)
5. [Special Screens](#special-screens)
6. [Animation Guidelines](#animation-guidelines)
7. [Responsive Design](#responsive-design)
8. [Accessibility](#accessibility)

---

## Design System

### Color Palette
| Type          | Hex Code       | Purpose                          | Usage Examples                     |
|---------------|----------------|----------------------------------|-----------------------------------|
| Primary       | #2563EB        | Main interactive elements      | Buttons, links, active UI        |
| Secondary     | #7C3AED        | Secondary interactive elements  | Secondary buttons, tooltips        |
| Accent        | #EC4899        | Highlight elements              | Progress bars, notifications      |
| Success       | #10B981        | Positive feedback               | Rewards, achievements             |
| Warning       | #F59E0B        | Warnings/alerts                 | Low energy, quest deadlines       |
| Error         | #EF4444        | Errors/mistakes                 | Failed actions, errors            |
| Neutral       | #1F2937        | Backgrounds, text               | Default backgrounds, body text    |
| Neutral Light | #6B7280        | Secondary backgrounds          | Card backgrounds, borders         |

### Typography Scale
| Type          | Font Family    | Font Weight | Font Size (px) | Line Height (px) | Usage Examples                     |
|---------------|----------------|-------------|----------------|----------------|-----------------------------------|
| Heading 1     | Space Grotesk | 700         | 32             | 36             | Main titles                        |
| Heading 2     | Space Grotesk | 600         | 24             | 30             | Section headers                   |
| Heading 3     | Space Grotesk | 500         | 20             | 24             | Subsection headers                |
| Body          | Space Grotesk | 400         | 16             | 24             | Main text                          |
| Caption       | Space Grotesk | 300         | 12             | 16             | Small text, labels               |
| Button        | Space Grotesk | 500         | 14             | 20             | Buttons, interactive elements    |

### Spacing System
| Type          | Value (px) | Usage Examples                     |
|---------------|------------|-----------------------------------|
| XXS           | 4          | Small padding, borders            |
| XS            | 8          | Small elements, icons            |
| SM            | 12         | Medium elements, spacing         |
| MD            | 16         | Default spacing, card margins    |
| LG            | 24         | Large sections, headers          |
| XL            | 32         | Extra-large spacing, full-width   |
| XXL           | 48         | Full-screen elements             |

### Iconography
- **Style:** Outline-based with subtle gradients
- **Sources:** Custom SVG icons (24px × 24px) for consistency
- **Usage:**
  - **Primary Actions:** Filled icons with primary color
  - **Secondary Actions:** Outline icons with neutral color
  - **Status Indicators:** Color-coded (e.g., green for success, red for error)

---

## Starting Screen

### Layout
- **Background:** Gradient animation (dark purple to deep blue) with subtle particle effects
- **Logo:** Centered at the top (10% from top)
- **Play Button:** Large circular button (120px diameter) centered vertically, 20% from the bottom
- **Settings Button:** Top-right corner (20px from edge)
- **Credits:** Bottom-left corner (15px from edge)
- **Music Toggle:** Bottom-right corner (15px from edge)

### Elements
| Element        | Description                                                                 | Size/Position                     |
|---------------|-----------------------------------------------------------------------------|-----------------------------------|
| Logo          | Aether Harvester logo with glowing effect                              | 200px × 60px, centered top       |
| Play Button   | Circular button with "START" text and animated glow effect              | 120px diameter, centered vertically |
| Settings      | Gear icon with tooltip "Game Settings"                                   | 24px × 24px, top-right            |
| Credits       | Small text link "Credits" with subtle animation on hover                 | 12px font, bottom-left             |
| Music Toggle  | Audio icon with play/pause state                                         | 24px × 24px, bottom-right         |

---

## HUD Design

### Energy Bar
- **Position:** Top-left corner
- **Appearance:** Gradient bar (purple to blue) with energy level indicator
- **Animation:** Smooth fill animation when energy regenerates
- **Tooltip:** Shows energy level and regeneration rate

### Health Bar
- **Position:** Top-right corner
- **Appearance:** Gradient bar (green to red) with health level indicator
- **Animation:** Flashes red when health is critically low
- **Tooltip:** Shows health level and healing items available

### Level Display
- **Position:** Center-top of the screen
- **Appearance:** Large number with a subtle glow effect
- **Animation:** Particle effect when leveling up
- **Tooltip:** Shows experience points and next level threshold

### Currency Display
- **Position:** Center-bottom of the screen
- **Appearance:** Bold number with currency symbol
- **Animation:** Confetti effect when earning currency
- **Tooltip:** Shows currency name and current balance

### Tool Display
- **Position:** Bottom-left corner
- **Appearance:** Grid of tool icons with active tool highlighted
- **Animation:** Hover effect on tools
- **Tooltip:** Shows tool name, description, and cooldown timer

### Active Creature Display
- **Position:** Bottom-right corner
- **Appearance:** Miniature creature icon with health bar
- **Animation:** Health bar pulses when creature is active
- **Tooltip:** Shows creature name, level, and stats

### Notification Area
- **Position:** Top-center of the screen
- **Appearance:** Stack of notification cards
- **Animation:** Slide-in from top with fade-out
- **Tooltip:** Shows notification details on hover

### Quest Tracker
- **Position:** Center-right of the screen
- **Appearance:** Quest log with active/completed tabs
- **Animation:** Quest progress bar fills when completing quests
- **Tooltip:** Shows quest details and rewards

### Harvest Progress
- **Position:** Bottom-center of the screen
- **Appearance:** Circular progress bar with harvest type
- **Animation:** Rotating animation when harvesting
- **Tooltip:** Shows harvest type, progress, and yield

### Controls Hint
- **Position:** Bottom-center of the screen (hidden by default)
- **Appearance:** Semi-transparent overlay with control icons
- **Animation:** Fades in on first launch
- **Tooltip:** Shows control descriptions on hover

---

## Menu Screens

### Inventory Screen
- **Layout:** Grid layout with adjustable columns
- **Filters:** Dropdown menu for filtering items (e.g., weapons, tools, consumables)
- **Sorting:** Sort by name, type, or rarity
- **Item Tooltips:** Detailed information on hover

### Quest Log Screen
- **Tabs:** Active/Completed
- **Quest Details:** Quest name, description, rewards, progress
- **Rewards:** Visual preview of rewards

### Map Screen
- **Minimap:** Small map in the top-right corner
- **Full Map:** Expandable map with zone markers
- **Fast Travel:** Markers for fast travel points

### Settings Screen
- **Graphics:** Resolution, quality, shadows
- **Audio:** Volume sliders for music and sound effects
- **Controls:** Keybindings customization
- **Accessibility:** Colorblind modes, font size, screen reader

---

## Special Screens

### Pet Screen
- **Pet Inventory:** Grid of pets with icons
- **Stats:** Health, energy, and skill levels
- **Abilities:** List of available abilities
- **Equip Slots:** Slots for equipping items

### Rewards Screen
- **Daily Rewards:** Calendar-based rewards
- **Achievement Popups:** Animated notifications for achievements
- **Loot Boxes:** Interactive loot box with spinning animation

### Trading Screen
- **Offer/Request:** Fields for trading items
- **Confirm:** Button to confirm trade
- **Trade History:** Log of past trades

### Guild Screen
- **Members:** List of guild members with avatars
- **Perks:** Guild benefits and rewards
- **Chat:** Real-time chat interface

---

## Animation Guidelines

### Transitions
- **Screen Transitions:** Smooth fade or slide animations between screens
- **Button Hover:** Subtle scale and color change
- **Button Click:** Ripple effect with feedback sound

### Notification Animations
- **Slide-in:** From top with fade-out
- **Pulse:** Gentle pulse effect on important notifications

### Progress Bar Animations
- **Fill:** Smooth gradient fill
- **Rotation:** Circular progress bars rotate

### Particle Effects
- **UI:** Subtle particles for actions (e.g., collecting items)
- **Background:** Dynamic particles for immersive feel

---

## Responsive Design

| Device       | Layout Adjustments                          |
|--------------|---------------------------------------------|
| Desktop      | Full-width screens, detailed UI          |
| Tablet       | Adjusted grid layouts, larger touch targets |
| Mobile       | Stacked elements, simplified menus        |

### Key Adjustments
- **Touch Targets:** Minimum 48px × 48px for buttons
- **Text Size:** Adjustable font scaling
- **Navigation:** Hamburger menu for mobile

---

## Accessibility

### Colorblind Modes
- **Options:** Protanopia, Deuteranopia, Tritanopia
- **Implementation:** Adjust color palettes for visibility

### Font Size Scaling
- **Options:** Small, Medium, Large
- **Implementation:** CSS media queries for responsive scaling

### Screen Reader Support
- **ARIA Labels:** All interactive elements have ARIA labels
- **Keyboard Navigation:** Full keyboard support
- **Contrast:** High contrast mode available

---

## Wireframe References

For detailed wireframes, refer to the [WIREFRAMES.md](ui/WIREFRAMES.md) file.