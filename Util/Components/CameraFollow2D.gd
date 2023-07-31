extends Node2D

@onready var camera : Camera2D = get_node(camera_path)
@export_node_path("Camera2D") var camera_path

var focused : = false

func _process(delta):
	if focused:
		camera.global_position = global_position
