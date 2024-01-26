extends CharacterBody2D
class_name GJAnt

@export_group("Physics")
@export var gravity : = 49
@export var friction : = 0.05
@export var speed : = 10
@export_group("Attributes")
@export var launcher : = false
@export var bridger : = false
@export var grabber : = false
@export var digger : = false

@onready var parent : = get_parent()
@onready var tilemap : MFM = parent.get_parent()
@onready var world : Array = tilemap.world

@onready var effect_area : Area2D = $Area2D
@onready var holding_polygon = $HoldingPolygon
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
	action_timer.wait_time = 0.4
	action_timer.one_shot = true
	add_child(action_timer)

func _process(delta):
	#Move in direction
	velocity += Vector2(get_dir(dir)) * speed
	var current_coords : = tilemap.local_to_map(tilemap.to_local(global_position))
	#Collision checking
	var forward_raycast : RayCast2D = raycast_array[dir]
	if forward_raycast and forward_raycast.is_colliding():
		var collision_point : = forward_raycast.get_collision_point()
		var collision_coords : = tilemap.local_to_map(tilemap.to_local(collision_point))
		if digger:
			dig(current_coords + get_dir(dir))
			action_timer.start()
			doing_action = true
		elif grabber and holding == null:
			if not tilemap.is_wall(current_coords + get_dir(dir)):
				pick_up(current_coords + get_dir(dir))
			change_direction()
		elif launcher:
			doing_action = true
		else:
			change_direction()
	else:
		if digger and doing_action and action_timer.is_stopped():
			digger = false
			doing_action = false
			free()
			return
	
	#Check for launch
	if launcher and doing_action:
		velocity *= 0.0
		for ant in effect_area.get_overlapping_bodies():
			if ant is GJAnt:
				if ant != self:
					ant.jump(15.0)
	if grabber:
		for ant in effect_area.get_overlapping_bodies():
			if ant.name == "AntQueen" and holding != null:
				print("feed")
				ant.energy += holding.energy
				holding = null
				change_direction()
	if bridger:
		if not is_on_floor():
			var down_coords : = tilemap.local_to_map(tilemap.to_local(global_position + Vector2(0, 16)))
			if not tilemap.is_wall(down_coords):
				tilemap.place_wall(down_coords)
				doing_action = true
				action_timer.start()
		else:
			if doing_action and action_timer.is_stopped():
				free()
				return
	
	#Check for eated
	#var current_coords : = tilemap.local_to_map(tilemap.to_local(global_position))
	if tilemap.is_trap(current_coords):
		world[current_coords.x][current_coords.y].content.energy += 100
		free()
		return
	physics_movement(delta)
	move_and_slide()
	update_holding()

func change_direction(dir_change : = 2):
	dir = wrapi(dir + dir_change, 0, DIR.MAX)

func physics_movement(delta):	
	velocity.y += gravity
	velocity *= (1.0 - friction)
	
func jump(jump_scalar : float):
	velocity.y -= 16 * jump_scalar

func update_holding():
	if holding:
		var color : Color = tilemap.get_color(holding.id)
		holding_polygon.color = color
		#else:
			#print_debug("What did you pick up?")
	else:
		holding_polygon.color = Color.TRANSPARENT

func dig(coords : Vector2i):
	#var coords : = tilemap.local_to_map(tilemap.to_local(pos))
	if not tilemap.is_in_bounds(coords) or not tilemap.is_wall(coords):
		digger = false
		doing_action = false
		action_timer.stop()
		return
	#Grab cell
	#holding = world[coords.x][coords.y].content
	#Delete cell
	world[coords.x][coords.y].content = null
	tilemap.draw_cell(coords)
	
func pick_up(coords : Vector2i):
	if not tilemap.is_in_bounds(coords):
		return
		
	if not tilemap.is_space_empty(coords) and holding == null:
		#Grab cell
		holding = world[coords.x][coords.y].content
		#Delete cell
		world[coords.x][coords.y].content = null
		tilemap.draw_cell(coords)
	
func place(coords : Vector2i):
	if holding == null:
		return
	if tilemap.is_in_bounds(coords) and tilemap.is_space_empty(coords):
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
		Vector2i.LEFT:
			return DIR.LEFT
		Vector2i.UP:
			return DIR.UP
		Vector2i.RIGHT:
			return DIR.RIGHT
		Vector2i.DOWN:
			return DIR.DOWN
		_:
			#print_debug("That is not a direction")
			return dir
