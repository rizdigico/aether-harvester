# HUMAN ACTIONS — required items with no automated route

## H-001: Enable Studio MCP server in Roblox Studio (BLOCKING direct Studio control)
**Why:** The StudioMCP.exe proxy connects to the running Studio instance via WebSocket. The in-Studio WS host only activates when "Enable Studio as MCP server" is toggled ON in Studio's Assistant, and the setting appears enabled in AssistantSettings (2995327390.json: `mcp-server.enabled: true`) but the running instance (RobloxStudioBeta) is NOT hosting the WS ("Not connected to the WS host" from list_roblox_studios).

**Exact steps (30 seconds):**
1. In the open Roblox Studio (Aether Harvester place), click the **Assistant** button (top-right, robot/AI icon).
2. Click the **…** (more) menu → **Manage MCP Servers**.
3. Toggle ON **"Enable Studio as MCP server"**.
4. If a green indicator appears → connected. If not, **restart Studio** (close + reopen the place), the setting persists.
5. Confirm: the plugin icon or indicator shows connected clients.

**Impact of not doing it:** Orchestrator cannot read/dump the live 24-service game source from Studio into the repo, cannot run play-mode verification, screenshots, or in-Studio tests. All filesystem work continues regardless.

**Do it when convenient — everything else proceeds autonomously.**
