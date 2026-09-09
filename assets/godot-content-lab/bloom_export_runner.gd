extends Node3D

const AetherBloomFactory = preload("res://godot-content-lab/aether_bloom_factory.gd")
const OUTPUT_PATH := "res://godot-content-lab/exports/AetherBloom_Godot_v1.glb"

func _ready() -> void:
	AetherBloomFactory.build(self)
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	var append_error := document.append_from_scene(self, state)
	if append_error != OK:
		push_error("AetherBloom export append failed: %s" % append_error)
		get_tree().quit(1)
		return

	var write_error := document.write_to_filesystem(state, OUTPUT_PATH)
	if write_error != OK:
		push_error("AetherBloom export write failed: %s" % write_error)
		get_tree().quit(1)
		return

	print("AetherBloom export complete: ", OUTPUT_PATH)
	get_tree().quit(0)
