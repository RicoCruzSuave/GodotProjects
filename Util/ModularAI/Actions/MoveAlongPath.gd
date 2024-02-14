extends AIAction

@export_node_path("Node2D") var movement_path
@onready var movement : Node2D = get_node(movement_path)

@export_node_path("Node2D") var pathfinding_path
@onready var pathfinding : Node2D = get_node(pathfinding_path)

@export var threshold : = 8.0
var time_cost : = 1.0
var skipped : = false
var object 
var end_point 


func setup(object : Object, end_point : Vector2):
	self.object = object
	self.end_point = end_point
#	time_cost = pathfinding.guess_path_size(end_point)

#Called to start/stop execution
func select() -> void:
	pathfinding.path_to(end_point)
	movement.move_to(pathfinding.get_current_path_point())
	time_cost = pathfinding.get_path_size()
	
func deselect() -> void:
	pass 

#Called every frame when active
func update() -> void:
	if object.global_position.distance_to(pathfinding.get_current_path_point()) < threshold:
		pathfinding.next_path_point()
		movement.move_to(pathfinding.get_current_path_point())
	
func is_done() -> bool:
	return skipped or object.global_position.distance_to(end_point) < threshold
