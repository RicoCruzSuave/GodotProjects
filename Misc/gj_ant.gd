extends CharacterBody2D
class_name GJAnt

@export_group("Physics")
@export var gravity : = 49
@export var friction : = 0.05
@export var speed : = 10
@export_group("Attributes")
@export var launcher : = false
@export var digger : = false
@export var bridger : = false



@onready var parent : = get_parent()
@onready var tilemap : MFM = parent.get_parent()
@onready var world : Array = tilemap.world

@onready var effect_area : = $Area2D
@onready var right_raycast : = $RightRaycast
@onready var left_raycast : = $LeftRaycast
@onready var up_raycast : = $UpRaycast
@onready var down_raycast : = $DownRaycast
@onready var raycast_array : = [
	left_raycast,
	up_raycast,
	right_raycast,
	down_raycast
]

var dir : = DIR.RIGHT
enum DIR {
	LEFT,
	UP,
	RIGHT,
	DOWN,
	MAX
}

var holding = null
var target : Vector2 
var action_timer : = Timer.new()
var doing_action : = false

func _ready():
	action_timer.wait_time = 0.5
	action_timer.one_shot = true
	add_child(action_timer)

func _process(delta):
	var forward_raycast : RayCast2D = raycast_array[dir]
	if forward_raycast and forward_raycast.is_colliding():
		if digger:
			var collision_point : = forward_raycast.get_collision_point()
			pick_up(collision_point)
			action_timer.start()
			doing_action = true
		else:
			change_direction()
	else:
		if doing_action and action_timer.is_stopped():
			digger = false
			doing_action = false
	velocity += Vector2(get_dir(dir)) * speed

	physics_movement(delta)
	move_and_slide()

func change_direction(dir_change : = 2):
	dir = wrapi(dir + dir_change, 0, DIR.MAX)

func physics_movement(delta):	
	velocity.y += gravity
	velocity *= (1.0 - friction)
	
func jump(jump_scalar : float):
	velocity.y -= 16 * jump_scalar
	
func dig(pos : Vector2):
	var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	if not tilemap.is_in_bounds(coords):
		digger = false
		doing_action = false
		action_timer.stop()
		return
	#Grab cell
	#holding = world[coords.x][coords.y].content
	#Delete cell
	world[coords.x][coords.y].content = null
	tilemap.draw_cell(coords)
	
func pick_up(pos : Vector2):
	var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	if not tilemap.is_in_bounds(coords):
		return
		
	if not tilemap.is_space_empty(coords):
		#Grab cell
		holding = world[coords.x][coords.y].content
		#Delete cell
		world[coords.x][coords.y].content = null
		tilemap.draw_cell(coords)
	
func place(pos : Vector2):
	if holding == null:
		return
	var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	#Place cell
	world[coords.x][coords.y].content = holding
	tilemap.draw_cell(coords)
	#Reset holding
	holding = null
	
func get_dir(dir_enum : DIR) -> Vector2i:
	match dir_enum:
		DIR.LEFT:
			return Vector2i.LEFT
		DIR.RIGHT:
			return Vector2i.RIGHT
		DIR.UP:
			return Vector2i.UP
		DIR.DOWN:
			return Vector2i.DOWN
		_:
			print_debug("I guess this would be a new dimension: " + str(dir_enum))
			return Vector2i.ZERO
			
func get_vec_dir(vec : Vector2i) -> DIR:
	if vec == Vector2i.ZERO:
		return dir
	match vec:
		Vector2i.RIGHT:
			return DIR.RIGHT
		Vector2i.UP:
			return DIR.UP
		Vector2i.RIGHT:
			return DIR.RIGHT
		Vector2i.DOWN:
			return DIR.DOWN
		_:
			#print_debug("That is not a direction")
			return dir
