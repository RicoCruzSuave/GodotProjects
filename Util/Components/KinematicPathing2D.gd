extends Node2D

@export_node_path("Node2D") var pathfinding_path
@onready var pathfinding : Node2D = get_node(pathfinding_path)

@export_node_path("CharacterBody2D") var body_path
@onready var body : CharacterBody2D = get_node(body_path)

@export var speed : = 300.0
@export var friction : = 0.25
@export var arrive_threshold : = 16.0
@export var smooth_threshold : = 24.0

@export var arrive_smoothly : = false

var target_point

func _physics_process(delta):
#	target_point = pathfinding.get_current_path_point()
	if target_point != null:
#		if not global_position.distance_to(target_point) < arrive_threshold:
		move_towards(target_point)
	
	if body.velocity != Vector2.ZERO:
		body.velocity *= 1.0 - friction
		
	body.move_and_slide()
	
func add_impulse(impulse : Vector2):
	body.velocity += impulse

func move_towards(point : Vector2, speed_scale : = 1.0):
	var direction_to_point : = global_position.direction_to(point)
	if arrive_smoothly:
		var projected_position : = body.global_position + (body.velocity / 60.0)
		var projected_direction_to_point : = projected_position.direction_to(point)
		var projected_distance : = projected_position.distance_to(point) 
		var projected_distance_normalized : float = min(projected_distance, smooth_threshold) / smooth_threshold
#		projected_distance_normalized = pow(projected_distance_normalized,  10)
		var projected_speed : = projected_distance_normalized * speed
		add_impulse(projected_direction_to_point * projected_speed * speed_scale)		
	else:
		add_impulse(direction_to_point * speed * speed_scale)

func move_to(point : Vector2):
	target_point = point
	
#func move_to_next_point() -> void:
#	pathfinding.next_path_point()
