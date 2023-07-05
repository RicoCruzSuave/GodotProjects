extends Node2D

@export_node_path("Node2D") var pathfinding_node_path
@onready var pathfinding : AStar2D = get_node(pathfinding_node_path).astar

@onready var path : = [global_position]

func get_current_path_point() -> Vector2:
	if path.size() > 0:
		return path[0]
	return Vector2.ZERO
	
func next_path_point() -> void:
	if path.size() > 1:
		path.pop_front()

func path_to(point : Vector2):
	var current_point : = pathfinding.get_closest_point(global_position)
	var target_point : = pathfinding.get_closest_point(point)
	path = pathfinding.get_point_path(current_point, target_point)
	
func guess_path_size(point : Vector2) -> int:
	var current_point : = pathfinding.get_closest_point(global_position)
	var target_point : = pathfinding.get_closest_point(point)
	var temp_path : = pathfinding.get_point_path(current_point, target_point)
	return temp_path.size()
	
func get_path_size() -> int:
	return path.size()
