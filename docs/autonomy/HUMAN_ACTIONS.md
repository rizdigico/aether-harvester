# HUMAN ACTIONS — required items with no automated route

## H-002: Re-toggle "Enable Studio as MCP server" in the NEW Studio instance (BLOCKING live E2E)
**Why:** Studio was restarted (bridge rebind). The persisted AssistantSettings has `mcp-server.enabled: true`, but the fresh instance's Assistant client only connects when the toggle CHANGES while the bridge host (port 13469) is running. The bridge is UP right now — so flipping the toggle will connect immediately.

**Exact steps (30 seconds):**
1. In the open Roblox Studio (Aesther Harvest place, new instance), click the **Assistant** button (top-right).
2. **…** menu → **Manage MCP Servers**.
3. Toggle OFF then ON **"Enable Studio as MCP server"** (off→on is what triggers the connection).
4. The orchestrator will detect the connection and immediately run the full E2E play-mode verification.

**Impact:** Without this, live play-mode verification (boot lines, harvest E2E, HUD checks) cannot run. All filesystem/git/CI/asset work continues regardless.
