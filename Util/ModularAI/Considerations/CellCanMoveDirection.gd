@tool
extends AIConsideration

@export_node_path("Node2D") var ca_path
@onready var ca : = get_node(ca_path)

@export var move_direction : = Vector2i.ZERO

func calculate():
	var desired_destination : Vector2i = ca.current_cell_pos + move_direction
	if ca.is_in_bounds(desired_destination) and ca.get_neighbor_cell(desired_destination).name == "AIR":
		score = 1.0
	else:
		score = 0.0
