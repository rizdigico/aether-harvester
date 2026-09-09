# Aether Harvester Godot Content Lab

This is the controlled Godot lane for original concept references and deterministic asset assembly. The project root is `assets/` so a selected imagegen output, its derived scene, and the exported model remain in one auditable tree.

Current slice:

- `../concepts/aether_node_concept_v1.png` — original imagegen concept reference.
- `aether_node_factory.gd` — deterministic low-poly crystal-node assembly.
- `ContentLab.tscn` — review scene with lighting, camera, overlay, and reference image.
- `export_aether_node.gd` — headless GLB export script.

Release rule: the GLB is only an intermediate. Before Roblox use, verify studs scale, pivot, collision, materials, triangle/texture budget, streaming behavior, and live Studio placement. Record the result in the autonomy asset registry.
