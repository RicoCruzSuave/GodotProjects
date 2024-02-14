extends Node2D

@export var camera_path : NodePath
@export var enabled : = true

func _process(_delta):
	"""
	TODO:
		Make camera work properly with primary and secondary targeting
		Use this to target register as a target for the camera
		Add in export for primary or secondary
	"""
	
	if not enabled:
		return
	if camera_path:
		var camera : = get_node(camera_path)
		if camera is Camera2D:
			camera.position = global_position
