extends RefCounted

const STONE_COLOR := Color("#252c40")
const STONE_ACCENT := Color("#3b4563")
const CYAN_COLOR := Color("#45dfff")
const CYAN_EMISSION := Color("#2d98ff")
const VIOLET_COLOR := Color("#8e6bff")
const VIOLET_EMISSION := Color("#6845ff")

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

static func _box(parent: Node3D, size: Vector3, position: Vector3, material: Material, name: String) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	var instance := _mesh_instance(parent, mesh, material, name)
	instance.position = position
	return instance

static func _crystal(parent: Node3D, position: Vector3, radius: float, height: float, material: Material, name: String) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.04
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = 6
	var instance := _mesh_instance(parent, mesh, material, name)
	instance.position = position
	return instance

static func build(root: Node3D) -> void:
	var stone := _material(STONE_COLOR)
	var accent := _material(STONE_ACCENT)
	var cyan := _material(CYAN_COLOR, CYAN_EMISSION)
	var violet := _material(VIOLET_COLOR, VIOLET_EMISSION)

	var island_mesh := CylinderMesh.new()
	island_mesh.top_radius = 4.5
	island_mesh.bottom_radius = 3.7
	island_mesh.height = 0.62
	island_mesh.radial_segments = 10
	_mesh_instance(root, island_mesh, stone, "FloatingIslandTop").position.y = 0.1

	var island_drop_mesh := CylinderMesh.new()
	island_drop_mesh.top_radius = 2.5
	island_drop_mesh.bottom_radius = 3.65
	island_drop_mesh.height = 2.9
	island_drop_mesh.radial_segments = 8
	_mesh_instance(root, island_drop_mesh, stone, "FloatingIslandDrop").position.y = -1.65

	_box(root, Vector3(5.8, 0.32, 3.9), Vector3(0, 0.65, 0.12), accent, "PortalPlatform")
	_box(root, Vector3(4.4, 0.22, 0.62), Vector3(0, 0.93, 1.7), accent, "PortalThreshold")
	for index in range(3):
		_box(root, Vector3(4.2 - index * 0.28, 0.22, 0.58), Vector3(0, 0.54 - index * 0.2, 1.82 + index * 0.46), accent, "PortalStep%02d" % index)

	_box(root, Vector3(1.15, 4.45, 0.92), Vector3(-2.08, 3.0, 0), stone, "PortalPillarLeft")
	_box(root, Vector3(1.15, 4.45, 0.92), Vector3(2.08, 3.0, 0), stone, "PortalPillarRight")
	_box(root, Vector3(4.75, 0.92, 0.92), Vector3(0, 5.08, 0), stone, "PortalKeystone")
	_box(root, Vector3(0.24, 3.1, 0.12), Vector3(-1.35, 2.85, 0.54), cyan, "PortalLightLeft")
	_box(root, Vector3(0.24, 3.1, 0.12), Vector3(1.35, 2.85, 0.54), cyan, "PortalLightRight")

	var core_mesh := CylinderMesh.new()
	core_mesh.top_radius = 1.72
	core_mesh.bottom_radius = 1.72
	core_mesh.height = 0.16
	core_mesh.radial_segments = 24
	var core := _mesh_instance(root, core_mesh, _material(Color("#111638"), VIOLET_EMISSION), "PortalEnergyCore")
	core.position = Vector3(0, 3.0, 0.52)
	core.rotation_degrees.x = 90

	var ring_radius := 2.12
	for index in range(14):
		var angle := TAU * float(index) / 14.0
		var ring_material := cyan if index % 2 == 0 else violet
		var ring_piece := _box(root, Vector3(0.72, 0.22, 0.18), Vector3(cos(angle) * ring_radius, 3.0 + sin(angle) * ring_radius, 0.64), ring_material, "PortalRing%02d" % index)
		ring_piece.rotation.z = angle

	_crystal(root, Vector3(-3.1, 1.12, 1.25), 0.42, 1.45, cyan, "CrystalLeft")
	_crystal(root, Vector3(3.05, 1.02, 1.35), 0.36, 1.2, cyan, "CrystalRight")
	_crystal(root, Vector3(0, 6.05, -0.05), 0.32, 1.45, cyan, "CrystalCrown")
	_crystal(root, Vector3(-4.0, 1.05, -1.0), 0.24, 0.85, violet, "CrystalEdgeLeft")
	_crystal(root, Vector3(4.0, 1.05, -1.0), 0.24, 0.85, violet, "CrystalEdgeRight")
