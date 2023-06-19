@tool
extends AIConsideration

@export_node_path("Node2D") var ca_path
@onready var ca : = get_node(ca_path)

@export var checking_for : = "Sand"

func calculate() -> void:
	for neighbor in ca.get_cell_neighbors(ca.current_cell):
		if ca.get_cell_type(neighbor):
			score = 1.0
			return
	score = 0.0
