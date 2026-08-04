# TOOL CAPABILITIES — verified 2026-08-04

| Tool | Status | Evidence |
|---|---|---|
| git (repo access, write) | ✅ | branches created, commits on revamp/aether-reforge |
| GitHub CLI (gh) | ✅ | authenticated `rizdigico`, CI runs queried |
| Blender MCP | ✅ | `get_scene_info` OK (3 objects, port 9876) |
| Blender Python exec | ✅ (addon active) | auto-start registered |
| Roblox Studio MCP (StudioMCP.exe proxy) | ⚠️ server probe OK; tools NOT in orchestrator session tool list | initialize handshake OK; needs session restart to expose tools |
| Rojo 7.7.0 | ✅ | builds main + test projects |
| Rokit 1.2.0 | ✅ | pins 5 tools |
| StyLua 2.5.2 | ✅ | gates pass |
| Selene 0.31.0 | ✅ | gates pass |
| Luau LSP 1.69.0 | ✅ | analyze passes with defs+sourcemap |
| Lune 0.10.5 | ✅ | unit tests 5/5 |
| TestEZ (vendored) | ✅ | test place builds |
| pixelmatch/pngjs | ✅ | visual regression script verified |
| rbxcloud 0.17.0 | ✅ | CLI help + publish command verified |
| unlimited-research engine | ✅ | SearXNG reachable, deps OK |
| CI (GitHub Actions) | ✅ | green on master |
| Open Cloud API key | ✅ | introspect OK, full scopes |

## Missing / deferred
- Studio MCP tools in orchestrator session (restart required).
- In-Studio device emulation, MicroProfiler capture, multi-client — pending Studio MCP exposure.
- Production publishing — policy-gated (no).
