extends Node2D

@export_node_path("RigidBody2D") var parent_path
@onready var parent : RigidBody2D = get_node(parent_path)

@export var impulse_strength : = 100.0

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		parent.apply_central_impulse(parent.global_position.direction_to(get_global_mouse_position()) * impulse_strength)
