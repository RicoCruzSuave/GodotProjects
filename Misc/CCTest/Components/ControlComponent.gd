extends Node2D

@export_node_path("RigidBody2D") var body_path : NodePath
@export_node_path("Node2D") var inventory_path : NodePath
@export_node_path("Node2D") var combat_path : NodePath
@export var temp_move_speed : = 10.0
@export var temp_turn_speed : = 10.0

@onready var inventory : = get_node(inventory_path)
@onready var combat : = get_node(combat_path)



func _process(_delta):
	"""
	TODO:
		Add in all control bits
		Hook into other components
		Use momevement componenet
"""
	var body : RigidBody2D = get_node(body_path)
	if body is RigidBody2D:
		var current_direction : = Vector2(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			Input.get_action_strength("down") - Input.get_action_strength("up")
		).normalized()
		#Change this out for movement thing
		var desired_angle : float = body.global_position.angle_to_point(get_global_mouse_position())
		var current_angle : float = body.global_rotation
		body.apply_central_impulse(temp_move_speed * current_direction)
		###FIX THE WRAPPING
		body.apply_torque_impulse(temp_turn_speed * (desired_angle - current_angle)) 
		#This is for changing the movement based on facing direction
#		body.apply_central_impulse(temp_move_speed * current_direction.rotated(body.rotation))

func _input(_event):
	if Input.is_action_just_pressed("left_click"):
		combat.get_node("LeftHand/Fist/LightAttacks/Jab").run(get_global_mouse_position())
	if Input.is_action_just_pressed("right_click"):
		pass
	if Input.is_action_just_pressed("ui_accept"):
		get_parent().get_node("Combat").active = not get_parent().get_node("Combat").active 
