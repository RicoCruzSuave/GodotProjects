@tool
extends Node2D

@export_node_path("Node2D") var points_node_path
@onready var points_node : = get_node(points_node_path)

@export_node_path("Node2D") var pathfinding_node 
@onready var astar : AStar2D = get_node(pathfinding_node).astar if pathfinding_node != null else null

@export var follow_pathes : = false

@export var draw_lines : = false : 
	set(new_bool) : _draw_lines()
	

@export var clear_lines : = false : 
	set(new_bool) : _clear_lines()


func _clear_lines():
	for child in get_children():
		child.free()

func _draw_lines():
	if not points_node:
		return
		
	_clear_lines()
		
	var points : = []
	for child in points_node.get_children():
		for _i in randi_range(2, 5):
			points.append(child.global_position - global_position)
	var point_targets : = points.duplicate()
	
	for current_point in points:
		var next_point : Vector2 = point_targets.pick_random()
		while current_point == next_point:
			next_point = point_targets.pick_random()
			
		if follow_pathes and pathfinding_node != null:
			var _astar : AStar2D = get_node(pathfinding_node).astar
			if _astar:
				var current_point_astar_node : = _astar.get_closest_point(current_point)
				var next_point_astar_node : = _astar.get_closest_point(next_point)
				if _astar.get_id_path(current_point_astar_node, next_point_astar_node).size() > 0:
					continue
			
		var new_line : = Line2D.new()
		new_line.width = 1.5
		new_line.default_color = Color.ANTIQUE_WHITE
		new_line.add_point(current_point)
		new_line.add_point(next_point)
		add_child(new_line)
		new_line.owner = owner
		
		var point_index : = point_targets.find(current_point)
		if point_index:
			point_targets.remove_at(point_index)	
			
##Add func to make sure essential nodes are connected
