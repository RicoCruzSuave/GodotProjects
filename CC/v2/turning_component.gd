extends Node2D

@export var speed : = TAU/4.0 / 60.0
@export var friction : = 0.1

var angular_velocity = 0.0

func _process(_delta):
	var body : CharacterBody2D = get_parent()
	#var angle_diff : = body.global_rotation - get_dir().angle()
	#angular_velocity += min(abs(angle_diff), speed) * sign(angle_diff)
	#body.rotate(angular_velocity)
	#angular_velocity *= 1.0 - friction

	body.look_at(get_global_mouse_position())

func get_dir() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())
