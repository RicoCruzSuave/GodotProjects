extends Node2D

@export_node_path("Node2D") var pathfinding_node_path
@onready var pathfinding : AStar2D = get_node(pathfinding_node_path).astar

@export_node_path("CharacterBody2D") var body_path
@onready var body : CharacterBody2D = get_node(body_path)

@export var speed : = 1.0
@export var friction : = 0.1
@export var arrive_threshold : = 5.0
@export var smooth_threshold : = 5.0

@export var arrive_smoothly : = false

var target_point
var path : = []

var using_path : = false
###Maybe split node this into two components

func _physics_process(delta):
	if path.is_empty():
		using_path = false
	else:
		if using_path and target_point == null:
			target_point = path.pop_front()
	
	if target_point != null:
		move_towards(target_point)
		if global_position.distance_to(target_point) < arrive_threshold:
			target_point = null
	
	if body.velocity != Vector2.ZERO:
		body.velocity *= 1.0 - friction
		
	body.move_and_slide()
	
func add_impulse(impulse : Vector2):
	body.velocity += impulse

func move_towards(point : Vector2):
	var direction_to_point : = global_position.direction_to(point)
	if arrive_smoothly:
		var projected_position : = body.global_position + body.velocity / 10.0
		var projected_direction_to_point : = projected_position.direction_to(point)
		var projected_distance : = projected_position.distance_to(point) 
		var projected_distance_normalized : float = min(projected_distance, smooth_threshold) / smooth_threshold
#		projected_distance_normalized = pow(projected_distance_normalized,  10)
		print(projected_distance_normalized)
		var projected_speed : = projected_distance_normalized * speed
		add_impulse(projected_direction_to_point * projected_speed)		
	else:
		add_impulse(direction_to_point * speed)

func move_to(point : Vector2):
	target_point = point
	
func path_to(point : Vector2):
	var current_point : = pathfinding.get_closest_point(global_position)
	var target_point : = pathfinding.get_closest_point(point)
	path = pathfinding.get_point_path(current_point, target_point)

func move_along_path():
	using_path = true
