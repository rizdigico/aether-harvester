extends SceneTree

const AetherBloomFactory = preload("res://godot-content-lab/aether_bloom_factory_v2.gd")
const OUTPUT_PATH := "res://godot-content-lab/exports/AetherBloom_Godot_v2.glb"

func _init() -> void:
	var root := Node3D.new()
	root.name = "AetherBloom_Godot_v2"
	AetherBloomFactory.build(root)

	var document := GLTFDocument.new()
	var state := GLTFState.new()
	var append_error := document.append_from_scene(root, state)
	if append_error != OK:
		printerr("AetherBloom v2 export append failed: ", append_error)
		quit(1)
		return

	var write_error := document.write_to_filesystem(state, OUTPUT_PATH)
	if write_error != OK:
		printerr("AetherBloom v2 export write failed: ", write_error)
		quit(1)
		return

	print("AetherBloom v2 export complete: ", OUTPUT_PATH)
	root.free()
	quit(0)
