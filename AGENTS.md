# Aether Harvester — Project Instructions for Coding Agents

> Aether Harvester Simulator is a Roblox game developed with **Rojo** (filesystem-first),
> **TestEZ** (unit tests), and the **Blender MCP** (3D assets). This file is the source of
> truth for how agents must work in this repo.

## Toolchain (all pinned by Rokit — `rokit.toml`)

Run every command from the project root (`aether-harvester/`). Shims resolve via
`C:\Users\aariz\.rokit\bin` (on user PATH).

| Tool | Purpose | Command |
|---|---|---|
| rojo 7.7.0 | Filesystem ↔ Studio sync / build | `rojo build`, `rojo serve` |
| stylua 2.5.2 | Formatting | `stylua src tests` |
| selene 0.31.0 | Linting | `selene src tests` |
| lune 0.10.5 | Standalone Luau runtime | `lune run scripts/...` |
| luau-lsp 1.69.0 | Type checking | `luau-lsp check` |
| TestEZ (vendored) | BDD unit tests in Studio | `test.project.json` build |

## Layout

```
aether-harvester/
├── default.project.json      # main game (Rojo build)
├── test.project.json         # game + TestEZ + TestRunner (tests build)
├── rokit.toml                # pinned tool versions
├── selene.toml / stylua.toml # lint + format config
├── testez.yml                # TestEZ globals for selene
├── src/
│   ├── ReplicatedStorage/AetherShared/       # shared modules (+ *.spec.luau next to code)
│   ├── ServerScriptService/AetherServer/     # server-only services (server-authoritative)
│   ├── StarterPlayer/StarterPlayerScripts/   # client scripts (*.client.luau)
│   ├── StarterGui/AetherUI/                  # UI screens
│   └── Workspace/AetherWorld/                # world data (nodes/creatures/islands)
├── tests/
│   └── test-runner.server.luau               # TestEZ bootstrap (prints JSON summary)
├── scripts/
│   ├── compare-screenshots.js                # pixelmatch visual regression
│   └── (deploy/smoke-test stubs)
├── vendor/testez/                            # pinned TestEZ
└── assets/                                   # Blender/MCP-produced models + textures
```

## Non-negotiable rules

1. **Server owns all sensitive state.** Currency, inventory, quests, pets, upgrades:
   validated server-side; client only displays. Never trust client remotes.
2. **Format + lint + typecheck before reporting done.**
   ```bash
   stylua src tests && selene src tests
   ```
   Both must exit 0. Selene chain: `std = "roblox+testez"`.
3. **Tests accompany behavior.** New shared module → add `*.spec.luau` next to it.
   Run via `rojo build test.project.json` → open in Studio → TestRunner prints
   `{"status": "...", "passed": N, "failed": N}`.
4. **Blender assets** come from the Blender MCP addon. Save Blender models to
   `assets/models/`, textures to `assets/textures/`. Reference from Lua via `rbxassetid`
   only after upload to Roblox, or via Rojo `$path` for local `.obj/.fbx` import stubs.
5. **No paid assets, no paid tools.** Free/open-source only.
6. **Studio API access notes:** DataStore calls warn in Studio (environmental).
   `require` from the Assistant plugin uses an isolated cache — test server modules
   through remotes, not by requiring server modules directly.
7. **Definition of Done** (full checklist) lives in `docs/definition-of-done.md` — read it
   before marking any task complete.

## Common flows

- **Live-sync to Studio:** `rojo serve` → in Studio install the Rojo plugin
  (`rojo.space/download`) → connect. Edits on disk propagate instantly.
- **Fresh build:** `rojo build --output aether-harvester.rbxlx`
- **Test build:** `rojo build test.project.json --output test-place.rbxlx`
- **Visual regression:** capture Studio screenshot → `tests/current/<name>.png`,
  compare: `node scripts/compare-screenshots.js <name>`
- **Blender:** keep Blender open with the MCP addon (port 9876) when generating assets.
