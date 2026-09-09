extends SceneTree

const AetherNodeFactory = preload("res://godot-content-lab/aether_node_factory.gd")
const OUTPUT_PATH := "res://godot-content-lab/exports/AetherNode_Godot_v1.glb"

func _init() -> void:
	var root := Node3D.new()
	root.name = "AetherNode_Godot_v1"
	AetherNodeFactory.build(root)

	var document := GLTFDocument.new()
	var state := GLTFState.new()
	var append_error := document.append_from_scene(root, state)
	if append_error != OK:
		printerr("AetherNode export append failed: ", append_error)
		quit(1)
		return

	var write_error := document.write_to_filesystem(state, OUTPUT_PATH)
	if write_error != OK:
		printerr("AetherNode export write failed: ", write_error)
		quit(1)
		return

	print("AetherNode export complete: ", OUTPUT_PATH)
	root.free()
	quit(0)
