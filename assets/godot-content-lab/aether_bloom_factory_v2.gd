extends RefCounted

const STEM_COLOR := Color("#244b4b")
const LEAF_COLOR := Color("#347b70")
const CRYSTAL_COLOR := Color("#9eeeff")
const CRYSTAL_EMISSION := Color("#3c9cff")
const CORE_COLOR := Color("#806dff")
const CORE_EMISSION := Color("#6c4cff")
const GOLD_COLOR := Color("#e6b84f")

static func _material(color: Color, emission: Color = Color.BLACK) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.12
	material.roughness = 0.38
	if emission != Color.BLACK:
		material.emission_enabled = true
		material.emission = emission
		material.emission_energy_multiplier = 2.0
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

static func _crystal_petal(parent: Node3D, index: int, angle: float) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.05
	mesh.bottom_radius = 0.43
	mesh.height = 2.55
	mesh.radial_segments = 6
	var radius := 0.82
	var position := Vector3(cos(angle) * radius, 2.55, sin(angle) * radius)
	var tilt := Vector3(0.0, 0.0, cos(angle) * 0.18)
	_mesh_instance(
		parent,
		mesh,
		_material(CRYSTAL_COLOR, CRYSTAL_EMISSION),
		"CrystalPetal" + str(index),
		position,
		Vector3(tilt.x, angle, tilt.z),
		Vector3(0.82, 1.0, 0.56)
	)

static func _leaf(parent: Node3D, mesh_name: String, position: Vector3, rotation: Vector3) -> void:
	var mesh := SphereMesh.new()
	mesh.radius = 1.0
	mesh.height = 2.0
	mesh.radial_segments = 8
	mesh.rings = 4
	_mesh_instance(parent, mesh, _material(LEAF_COLOR), mesh_name, position, rotation, Vector3(0.72, 0.13, 1.05))

static func build(root: Node3D) -> void:
	var stem_mesh := CylinderMesh.new()
	stem_mesh.top_radius = 0.08
	stem_mesh.bottom_radius = 0.16
	stem_mesh.height = 3.8
	stem_mesh.radial_segments = 8
	_mesh_instance(root, stem_mesh, _material(STEM_COLOR), "BloomStem", Vector3(0, -0.18, 0))

	_leaf(root, "LeafLeft", Vector3(-0.62, -0.82, 0.04), Vector3(0.1, 0.2, -0.78))
	_leaf(root, "LeafRight", Vector3(0.64, -0.68, 0.02), Vector3(-0.08, -0.22, 0.76))

	var collar_mesh := CylinderMesh.new()
	collar_mesh.top_radius = 0.17
	collar_mesh.bottom_radius = 0.22
	collar_mesh.height = 0.18
	collar_mesh.radial_segments = 6
	_mesh_instance(root, collar_mesh, _material(GOLD_COLOR), "BloomCollar", Vector3(0, 1.52, 0))

	var core_mesh := SphereMesh.new()
	core_mesh.radius = 0.68
	core_mesh.height = 1.36
	core_mesh.radial_segments = 8
	core_mesh.rings = 4
	_mesh_instance(root, core_mesh, _material(CORE_COLOR, CORE_EMISSION), "BloomCore", Vector3(0, 2.45, 0))

	for index in range(6):
		_crystal_petal(root, index + 1, TAU * float(index) / 6.0)
