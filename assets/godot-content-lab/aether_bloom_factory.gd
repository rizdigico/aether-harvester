extends RefCounted

const STEM_COLOR := Color("#244b4b")
const LEAF_COLOR := Color("#327969")
const CRYSTAL_COLOR := Color("#8feaff")
const CRYSTAL_EMISSION := Color("#3a9cff")
const GOLD_COLOR := Color("#e6b84f")

static func _material(color: Color, emission: Color = Color.BLACK) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.12
	material.roughness = 0.38
	if emission != Color.BLACK:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = 2.2
	return material

static func _mesh_instance(
		parent: Node3D,
		mesh: Mesh,
		material: Material,
		mesh_name: String,
		position: Vector3,
		rotation: Vector3 = Vector3.ZERO,
		scale: Vector3 = Vector3.ONE
	) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = mesh_name
	instance.mesh = mesh
	instance.material_override = material
	instance.position = position
	instance.rotation = rotation
	instance.scale = scale
	parent.add_child(instance)
	return instance

static func _crystal(parent: Node3D, mesh_name: String, radius: float, height: float, position: Vector3, rotation: Vector3) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.045
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 6
	_mesh_instance(parent, mesh, _material(CRYSTAL_COLOR, CRYSTAL_EMISSION), mesh_name, position, rotation)

static func _leaf(parent: Node3D, mesh_name: String, position: Vector3, rotation: Vector3, scale: Vector3) -> void:
	var mesh := SphereMesh.new()
	mesh.radius = 1.0
	mesh.height = 2.0
	mesh.radial_segments = 8
	mesh.rings = 4
	_mesh_instance(parent, mesh, _material(LEAF_COLOR), mesh_name, position, rotation, scale)

static func build(root: Node3D) -> void:
	var stem_mesh := CylinderMesh.new()
	stem_mesh.top_radius = 0.09
	stem_mesh.bottom_radius = 0.18
	stem_mesh.height = 3.6
	stem_mesh.radial_segments = 8
	_mesh_instance(root, stem_mesh, _material(STEM_COLOR), "BloomStem", Vector3(0, -0.15, 0))

	_leaf(root, "LeafLeft", Vector3(-0.68, -0.75, 0.05), Vector3(0.1, 0.2, -0.78), Vector3(0.72, 0.14, 1.1))
	_leaf(root, "LeafRight", Vector3(0.7, -0.58, 0.02), Vector3(-0.08, -0.22, 0.76), Vector3(0.72, 0.14, 1.1))
	_leaf(root, "LeafFront", Vector3(0.1, -1.08, 0.64), Vector3(0.46, 0.05, 0.05), Vector3(0.58, 0.12, 0.92))

	var gold_mesh := CylinderMesh.new()
	gold_mesh.top_radius = 0.16
	gold_mesh.bottom_radius = 0.2
	gold_mesh.height = 0.16
	gold_mesh.radial_segments = 6
	_mesh_instance(root, gold_mesh, _material(GOLD_COLOR), "BloomCollar", Vector3(0, 1.48, 0))

	_crystal(root, "BloomCore", 0.72, 3.6, Vector3(0, 2.85, 0), Vector3.ZERO)
	_crystal(root, "BloomLeft", 0.42, 2.45, Vector3(-0.72, 2.55, 0.02), Vector3(0.0, 0.0, 0.18))
	_crystal(root, "BloomRight", 0.44, 2.55, Vector3(0.78, 2.48, -0.02), Vector3(0.0, 0.0, -0.2))
	_crystal(root, "BloomFront", 0.34, 2.0, Vector3(0.22, 2.15, 0.64), Vector3(0.16, 0.0, -0.1))
	_crystal(root, "BloomRear", 0.28, 1.65, Vector3(-0.18, 2.05, -0.5), Vector3(-0.12, 0.0, 0.08))
