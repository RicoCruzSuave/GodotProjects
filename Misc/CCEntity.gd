extends RigidBody2D

@export var speed : = 1.0
@export var action_speed : = 1.0

@onready var l_hand : RigidBody2D = $LeftHand
@onready var r_hand : RigidBody2D = $RightHand
@onready var inventory : = $Inventory
@onready var ray_cast : = $RayCast2D

const BASE_ACTION_SPEED_SCALAR : = 	1000.0
const BASE_LINEAR_SPEED_SCALAR : = 	15000.0
const BASE_ANGULAR_SPEED_SCALAR : = 10000000.0

#func _input(event):
	#if Input.is_action_just_pressed("left_click"):
		#var dir : = l_hand.global_position.direction_to(get_global_mouse_position())
		#l_hand.apply_central_impulse(dir * action_speed * BASE_ACTION_SPEED_SCALAR)
	#if Input.is_action_just_pressed("right_click"):
		#var dir : = r_hand.global_position.direction_to(get_global_mouse_position())
		#r_hand.apply_central_impulse(dir * action_speed * BASE_ACTION_SPEED_SCALAR)
		
#func _process(delta):
	#
	#var l_dir : = global_position.direction_to(l_hand.global_position).rotated(TAU/4.0)
	#l_hand.apply_central_impulse(l_dir * action_speed * BASE_ACTION_SPEED_SCALAR * delta)
	#var r_dir : = global_position.direction_to(r_hand.global_position).rotated(TAU/4.0)	
	#r_hand.apply_central_impulse(r_dir * action_speed * BASE_ACTION_SPEED_SCALAR * delta)
	

func _physics_process(delta : float):
	apply_central_impulse(
		Vector2(
			Input.get_action_raw_strength("right") - Input.get_action_raw_strength("left"), 
			Input.get_action_raw_strength("down") - Input.get_action_raw_strength("up") 
		) * speed * BASE_LINEAR_SPEED_SCALAR * delta
	)
	
	#Get collision point as raycast collision point or the end of the raycast
	var col_point : Vector2 = ray_cast.get_collision_point() if ray_cast.is_colliding() else global_position + ray_cast.target_position.rotated(global_rotation)
	var collider = ray_cast.get_collider()
	
	#Left hand
	if Input.is_action_just_pressed("left_click"):
		var dir : = l_hand.global_position.direction_to(col_point)
		l_hand.apply_central_impulse(dir * action_speed * BASE_ACTION_SPEED_SCALAR * delta)
		if collider is TileMap:
			collider.set_cell(0, collider.local_to_map(col_point + ray_cast.target_position.rotated(global_rotation).normalized() * 8.0))
		
	if Input.is_key_label_pressed(KEY_Q):
		if ray_cast.is_colliding():
			var other = ray_cast.get_collider()
			if other is RigidBody2D:
				other.global_transform.origin = l_hand.global_position
				l_hand.attach(other)
				
	#Right hand
	if Input.is_action_just_pressed("right_click"):
		var dir : = r_hand.global_position.direction_to(get_global_mouse_position())
		r_hand.apply_central_impulse(dir * action_speed * BASE_ACTION_SPEED_SCALAR * delta)
		
	if Input.is_key_label_pressed(KEY_E):
		if ray_cast.is_colliding():
			var other = ray_cast.get_collider()
			if other is RigidBody2D:
				other.global_transform.origin = r_hand.global_position
				r_hand.attach(other)
	
	var angular_force : = speed * BASE_ANGULAR_SPEED_SCALAR * delta
	var target : = get_global_mouse_position()
	var dir = transform.y.dot(global_position.direction_to(target))
	constant_torque = dir * angular_force
	l_hand.constant_torque = dir * angular_force
	r_hand.constant_torque = dir * angular_force
	
