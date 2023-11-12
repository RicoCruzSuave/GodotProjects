extends Command2D
class_name ProjectileCommand2D

@export_node_path("Node2D") var projectile_path : = NodePath("Projectile")

@onready var projectile : = get_node(projectile_path)

var start_pos = null : get = get_start_pos
var target_pos = null : get = get_target_pos
var speed 
var radius 

var full_reset : = true	


## Inputs: start_pos, target_pos, speed, radius
func prepare(variant : Variant = null):
	if variant:
		start_pos = variant[0] 
		target_pos = variant[1] 
		speed = variant[2] 
		radius = variant[3] 
		
	if not can_do():
		return
	prepared = true
	
func _process(delta):
	if running:
		run()
	

func _unhandled_input(event):
	if Input.is_action_just_pressed("left_click"):
		if prepared:
			resume()
			

func run():
	if not prepared:
		return
	
	##TODO: Check conditions
	
	var new_projectile : Node2D = projectile.duplicate()
	
	setup_projectile(new_projectile)
	
	add_child(new_projectile)
	new_projectile.process_mode = Node.PROCESS_MODE_ALWAYS
	
	var dir_to_target : Vector2 = start_pos.direction_to(target_pos)
	new_projectile.global_position = start_pos + (dir_to_target * radius)
	
	complete()
	

func setup_projectile(object : Object):
	if object is RigidBody2D:
		var dir_to_target : Vector2 = start_pos.direction_to(target_pos)
		object.sleeping = false
		object.apply_central_impulse(dir_to_target * speed)

func resume():
	running = true
	
func stop():
	running = false

func complete():
	completed = true
	if is_completed():
		emit_signal("command_done")
		stop()

func can_do():
	if start_pos == null:
		return false
	if target_pos == null:
		return false
	if speed == null:
		return false
	if radius == null:
		return false
	return true
	
func reset():
	super.reset()
	if full_reset:
		start_pos = null
		target_pos = null
		speed = null
		radius = null
	
func get_start_pos():
	if start_pos is Callable:
		return start_pos.call()
	else:
		return start_pos
		
func get_target_pos():
	if target_pos is Callable:
		return target_pos.call()
	else:
		return target_pos

