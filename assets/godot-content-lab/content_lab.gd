extends Node3D

const AetherNodeFactory = preload("res://godot-content-lab/aether_node_factory.gd")

func _ready() -> void:
	AetherNodeFactory.build(self)
	_build_lighting()
	_build_camera()
	_build_review_panel()

func _build_lighting() -> void:
	var world_environment := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#080d18")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#52648c")
	environment.ambient_light_energy = 0.58
	world_environment.environment = environment
	add_child(world_environment)

	var key_light := DirectionalLight3D.new()
	key_light.name = "KeyLight"
	key_light.rotation_degrees = Vector3(-52, -28, 0)
	key_light.light_color = Color("#c6d7ff")
	key_light.light_energy = 1.2
	key_light.shadow_enabled = true
	add_child(key_light)

	var rim_light := OmniLight3D.new()
	rim_light.name = "CrystalRimLight"
	rim_light.position = Vector3(0, 1.4, 2.2)
	rim_light.light_color = Color("#31cfff")
	rim_light.light_energy = 5.0
	rim_light.omni_range = 8.0
	add_child(rim_light)

func _build_camera() -> void:
	var camera := Camera3D.new()
	camera.name = "ReviewCamera"
	camera.position = Vector3(8.3, 5.2, 10.2)
	camera.look_at_from_position(camera.position, Vector3(0, 1.1, 0))
	camera.fov = 38.0
	add_child(camera)

func _build_review_panel() -> void:
	var layer := CanvasLayer.new()
	layer.name = "ReviewOverlay"
	add_child(layer)

	var panel := ColorRect.new()
	panel.position = Vector2(28, 28)
	panel.size = Vector2(318, 176)
	panel.color = Color(0.035, 0.055, 0.11, 0.9)
	layer.add_child(panel)

	var title := Label.new()
	title.position = Vector2(18, 14)
	title.text = "AETHER NODE / GODOT LAB"
	title.add_theme_color_override("font_color", Color("#7eeaff"))
	title.add_theme_font_size_override("font_size", 18)
	panel.add_child(title)

	var details := Label.new()
	details.position = Vector2(18, 52)
	details.text = "Concept reference loaded\nProcedural low-poly assembly active\nMaterial: emissive crystal + stone\nTarget: Roblox-friendly silhouette\n\nExport gate: scale / pivot / collision / budget"
	details.add_theme_color_override("font_color", Color("#d7e5ff"))
	details.add_theme_font_size_override("font_size", 13)
	panel.add_child(details)

	var reference := TextureRect.new()
	reference.position = Vector2(1010, 40)
	reference.size = Vector2(230, 230)
	reference.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	reference.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	reference.modulate = Color(1, 1, 1, 0.72)
	if DisplayServer.get_name() != "headless":
		var reference_texture = load("res://concepts/aether_node_concept_v1.png")
		if reference_texture is Texture2D:
			reference.texture = reference_texture
	layer.add_child(reference)
