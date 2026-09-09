extends RefCounted

const BASE_COLOR := Color("#252c40")
const CRYSTAL_COLOR := Color("#45dfff")
const CRYSTAL_EMISSION := Color("#2d98ff")

static func _material(color: Color, emission: Color = Color.BLACK) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.15
	material.roughness = 0.42
	if emission != Color.BLACK:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = 2.0
	return material

static func _mesh_instance(parent: Node3D, mesh: Mesh, material: Material, name: String) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = name
	instance.mesh = mesh
	instance.material_override = material
	parent.add_child(instance)
	return instance

static func build(root: Node3D) -> void:
	var base_mesh := CylinderMesh.new()
	base_mesh.top_radius = 2.6
	base_mesh.bottom_radius = 2.25
	base_mesh.height = 0.72
	base_mesh.radial_segments = 10
	_mesh_instance(root, base_mesh, _material(BASE_COLOR), "StonePlinth")

	var lower_mesh := CylinderMesh.new()
	lower_mesh.top_radius = 0.9
	lower_mesh.bottom_radius = 1.35
	lower_mesh.height = 1.4
	lower_mesh.radial_segments = 8
	var lower := _mesh_instance(root, lower_mesh, _material(BASE_COLOR), "FloatingCore")
	lower.position.y = -0.82

	var crystal_material := _material(CRYSTAL_COLOR, CRYSTAL_EMISSION)
	var crystal_specs := [
		{ "name": "CrystalCore", "radius": 0.68, "height": 3.8, "position": Vector3(0, 2.18, 0), "rotation": Vector3(0, 0, 0) },
		{ "name": "CrystalNorth", "radius": 0.42, "height": 2.55, "position": Vector3(0.9, 1.68, -0.1), "rotation": Vector3(0, 0.12, -0.18) },
		{ "name": "CrystalWest", "radius": 0.4, "height": 2.35, "position": Vector3(-0.92, 1.56, 0.08), "rotation": Vector3(0, -0.18, 0.16) },
		{ "name": "CrystalFront", "radius": 0.32, "height": 1.85, "position": Vector3(0.4, 1.2, 0.74), "rotation": Vector3(0.12, 0, -0.12) },
	]

	for spec in crystal_specs:
		var crystal_mesh := CylinderMesh.new()
		crystal_mesh.top_radius = 0.045
		crystal_mesh.bottom_radius = spec.radius
		crystal_mesh.height = spec.height
		crystal_mesh.radial_segments = 6
		var crystal := _mesh_instance(root, crystal_mesh, crystal_material, spec.name)
		crystal.position = spec.position
		crystal.rotation = spec.rotation

	var accent_mesh := CylinderMesh.new()
	accent_mesh.top_radius = 0.14
	accent_mesh.bottom_radius = 0.14
	accent_mesh.height = 0.08
	accent_mesh.radial_segments = 6
	var accent := _mesh_instance(root, accent_mesh, _material(CRYSTAL_COLOR, CRYSTAL_EMISSION), "CoreAccent")
	accent.position = Vector3(0, 0.4, 2.12)
	accent.rotation_degrees.x = 90
