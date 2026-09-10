extends Node3D

const AetherPortalFactory = preload("res://godot-content-lab/aether_portal_factory.gd")
const AetherNodeFactory = preload("res://godot-content-lab/aether_node_factory.gd")
const AetherBloomFactory = preload("res://godot-content-lab/aether_bloom_factory_v2.gd")

var _portal: Node3D
var _node: Node3D
var _bloom: Node3D

func _ready() -> void:
	_build_showcase()
	_build_lighting()
	_build_camera()
	_build_overlay()

func _process(delta: float) -> void:
	if is_instance_valid(_portal):
		_portal.rotation.y += delta * 0.12
	if is_instance_valid(_node):
		_node.rotation.y -= delta * 0.08
	if is_instance_valid(_bloom):
		_bloom.rotation.y += delta * 0.18

func _build_showcase() -> void:
	_portal = Node3D.new()
	_portal.name = "AetherPortalPreview"
	_portal.position = Vector3(-8.0, 2.6, 0.0)
	add_child(_portal)
	AetherPortalFactory.build(_portal)
	_add_stage("PortalStage", Vector3(-8.0, -2.2, 0.0), Color("#26304b"))

	_node = Node3D.new()
	_node.name = "AetherNodePreview"
	_node.position = Vector3(0.0, 2.3, 0.0)
	add_child(_node)
	AetherNodeFactory.build(_node)
	_add_stage("NodeStage", Vector3(0.0, -2.5, 0.0), Color("#26304b"))

	_bloom = Node3D.new()
	_bloom.name = "AetherBloomGodotV2Preview"
	_bloom.position = Vector3(8.0, 0.2, 0.0)
	add_child(_bloom)
	AetherBloomFactory.build(_bloom)
	_add_stage("BloomStage", Vector3(8.0, -2.05, 0.0), Color("#26304b"))

func _add_stage(stage_name: String, position: Vector3, color: Color) -> void:
	var stage := MeshInstance3D.new()
	stage.name = stage_name
	var mesh := CylinderMesh.new()
	mesh.top_radius = 3.4
	mesh.bottom_radius = 3.0
	mesh.height = 0.42
	mesh.radial_segments = 12
	stage.mesh = mesh
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.metallic = 0.2
	material.roughness = 0.45
	stage.material_override = material
	stage.position = position
	add_child(stage)

func _build_lighting() -> void:
	var world_environment := WorldEnvironment.new()
	world_environment.name = "PreviewEnvironment"
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#080d18")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#5a6da0")
	environment.ambient_light_energy = 0.68
	environment.glow_enabled = true
	environment.glow_intensity = 0.9
	world_environment.environment = environment
	add_child(world_environment)

	var key_light := DirectionalLight3D.new()
	key_light.name = "KeyLight"
	key_light.rotation_degrees = Vector3(-52.0, -28.0, 0.0)
	key_light.light_color = Color("#c6d7ff")
	key_light.light_energy = 1.35
	key_light.shadow_enabled = true
	add_child(key_light)

	var bloom_light := OmniLight3D.new()
	bloom_light.name = "BloomLight"
	bloom_light.position = Vector3(8.0, 3.7, 1.0)
	bloom_light.light_color = Color("#59dfff")
	bloom_light.light_energy = 7.0
	bloom_light.omni_range = 10.0
	add_child(bloom_light)

	var portal_light := OmniLight3D.new()
	portal_light.name = "PortalLight"
	portal_light.position = Vector3(-8.0, 4.0, 1.0)
	portal_light.light_color = Color("#8e6bff")
	portal_light.light_energy = 5.0
	portal_light.omni_range = 9.0
	add_child(portal_light)

func _build_camera() -> void:
	var camera := Camera3D.new()
	camera.name = "ShowcaseCamera"
	camera.position = Vector3(16.5, 9.5, 20.0)
	camera.look_at_from_position(camera.position, Vector3(0.0, 1.6, 0.0))
	camera.fov = 42.0
	add_child(camera)

func _build_overlay() -> void:
	var layer := CanvasLayer.new()
	layer.name = "ShowcaseOverlay"
	add_child(layer)

	var panel := ColorRect.new()
	panel.position = Vector2(28.0, 28.0)
	panel.size = Vector2(398.0, 196.0)
	panel.color = Color(0.035, 0.055, 0.11, 0.9)
	layer.add_child(panel)

	var title := Label.new()
	title.position = Vector2(18.0, 14.0)
	title.text = "AETHER HARVEST / GODOT CONTENT LAB"
	title.add_theme_color_override("font_color", Color("#7eeaff"))
	title.add_theme_font_size_override("font_size", 18)
	panel.add_child(title)

	var details := Label.new()
	details.position = Vector2(18.0, 52.0)
	details.text = "PORTAL     NODE     BLOOM V2\n\nGodot-authored low-poly showcase\nAnimated review scene • emissive materials\nRoblox companion: native-runtime install\n\nGLB import remains a Studio verification gate"
	details.add_theme_color_override("font_color", Color("#d7e5ff"))
	details.add_theme_font_size_override("font_size", 13)
	panel.add_child(details)

	var reference := TextureRect.new()
	reference.position = Vector2(1080.0, 42.0)
	reference.size = Vector2(164.0, 164.0)
	reference.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	reference.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	reference.modulate = Color(1.0, 1.0, 1.0, 0.82)
	if DisplayServer.get_name() != "headless":
		var reference_texture = load("res://concepts/aether_bloom_concept_v2.png")
		if reference_texture is Texture2D:
			reference.texture = reference_texture
	layer.add_child(reference)
