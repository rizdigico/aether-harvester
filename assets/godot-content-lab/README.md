# Aether Harvester Godot Content Lab

This is the controlled Godot lane for original concept references and deterministic asset assembly. The project root is `assets/` so a selected imagegen output, its derived scene, and the exported model remain in one auditable tree.

Current slice:

- `../concepts/aether_node_concept_v1.png` — original imagegen concept reference.
- `aether_node_factory.gd` — deterministic low-poly crystal-node assembly.
- `ContentLab.tscn` — review scene with lighting, camera, overlay, and reference image.
- `export_aether_node.gd` — headless GLB export script.
- `../concepts/aether_portal_concept_v1.png` — original imagegen portal landmark reference.
- `aether_portal_factory.gd` — deterministic low-poly portal landmark assembly.
- `PortalExportRunner.tscn` — MCP-runnable portal export scene.
- `portal_export_runner.gd` — exports the portal through the Godot runtime.
- `export_aether_portal.gd` — standalone GLB export script for local tooling.
- `../concepts/aether_bloom_concept_v1.png` — new imagegen bloom-node concept reference.
- `aether_bloom_factory.gd` — deterministic, Roblox-friendly bloom assembly derived from that reference.
- `export_aether_bloom.gd` — standalone GLB export script for the bloom candidate.
- `BloomExportRunner.tscn` / `bloom_export_runner.gd` — MCP-runnable Godot scene used to produce the bloom GLB.
- `../concepts/aether_bloom_concept_v2.png` — imagegen production-reference variant for the six-petal bloom.
- `aether_bloom_factory_v2.gd` — deterministic six-petal, low-poly bloom assembly derived from the v2 reference.
- `bloom_export_runner_v2.gd` / `BloomExportRunnerV2.tscn` — headless/MCP-runnable v2 GLB export.

Release rule: the GLB is only an intermediate. Before Roblox use, verify studs scale, pivot, collision, materials, triangle/texture budget, streaming behavior, and live Studio placement. Record the result in the autonomy asset registry.
