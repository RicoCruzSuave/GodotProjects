extends Command2D
class_name ProjectileCommand2D

@export_node_path("Node2D") var projectile_path : = NodePath("Projectile")
@onready var projectile : = get_node(projectile_path)

var start_pos = null : get = get_start_pos
var target_pos = null : get = get_target_pos
var origin : Target2D 
var target : Target2D
var energy 



func prepare():
	#if not can_do():
		#return
	prepared = true


func set_vars(start, end, energy):
	origin = Target2D.new(start)
	target = Target2D.new(end)
	energy = energy

func _ready():
	set_process(false)
		
##If not prepared, prepare()
##If not running, run()
##If completed, reset()
func _process(delta):
	if not prepared:
		prepare()
	if running:
		run()
	if is_completed():
		complete()
	

func _unhandled_input(event):
	if Input.is_action_just_pressed("left_click"):
		if prepared:
			resume()
			

func run():
	if not prepared:
		return
	
	var new_projectile : Node2D = projectile.duplicate()
	new_projectile.setup()
	#setup_projectile(new_projectile)
	add_child(new_projectile)

func setup_projectile(object : Object):
	
	var dir_to_target : Vector2 = start_pos.direction_to(target_pos)
	var offset : Vector2 = origin.get_node("CollisionShape2D").shape.radius + object.shape.radius
	object.global_position = start_pos + offset
	
	if object is RigidBody2D:
		object.sleeping = false
		object.apply_central_impulse(dir_to_target * energy * object.speed_scalar)

func start():
	set_process(true)

func resume():
	running = true
	set_process(true)
	
func stop():
	running = false
	set_process(false)

func complete():
	completed = true
	emit_signal("command_done")
	stop()
	reset()	
	
func reset():
	prepared = false
	running = false
	completed = false
	origin = null
	target = null
	energy = null
	
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

