extends Node3D

@export_node_path("Node3D") var target_path

@onready var target : = get_node(target_path)
@onready var raycast : = $Camera3D/RayCast3D

func _process(delta):
	if target != null:
		position = target.global_position

func get_mouse_position() -> Vector3:
	var mouse_pos : = get_viewport().get_mouse_position()
	var resolution : = DisplayServer.window_get_size()
	mouse_pos -= Vector2(resolution) / 2.0
	mouse_pos *= 2
	raycast.target_position.x = mouse_pos.x
	raycast.target_position.y = -mouse_pos.y
	raycast.target_position.z = -1000
	raycast.force_raycast_update()
	return raycast.get_collision_point()
