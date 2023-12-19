extends RigidBody2D

@export var speed : = 1.0

@onready var l_hand : RigidBody2D = $LeftHand
@onready var r_hand : RigidBody2D = $RightHand

const BASE_ACTION_SPEED_SCALAR : = 	1000.0
const BASE_LINEAR_SPEED_SCALAR : = 	15000.0
const BASE_ANGULAR_SPEED_SCALAR : = 10000000.0

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		var dir : = l_hand.global_position.direction_to(get_global_mouse_position())
		l_hand.apply_central_impulse(dir * speed * BASE_ACTION_SPEED_SCALAR)
	if Input.is_action_just_pressed("right_click"):
		var dir : = r_hand.global_position.direction_to(get_global_mouse_position())
		r_hand.apply_central_impulse(dir * speed * BASE_ACTION_SPEED_SCALAR)

func _physics_process(delta : float):
	apply_central_impulse(
		Vector2(
			Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left"), 
			Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up") 
		) * speed * BASE_LINEAR_SPEED_SCALAR * delta
	)
	
	var angular_force : = speed * BASE_ANGULAR_SPEED_SCALAR * delta
	var target : = get_global_mouse_position()
	var dir = transform.y.dot(global_position.direction_to(target))
	constant_torque = dir * angular_force
	#var current_angle : = global_rotationa
	#var desired_angle : = global_position.direction_to(get_global_mouse_position()).angle()
	#var rotation_speed : = TAU / 3.0
	#var full_rotation : = lerp_angle(current_angle, desired_angle, 1.0)
	#var limited_rotation : = clampf(full_rotation, current_angle - rotation_speed, current_angle + rotation_speed)
	#apply_torque_impulse(limited_rotation)
	
