@tool
extends AIAction

@export_node_path("Node2D") var ca_path
@onready var ca : = get_node(ca_path)

@export var change_to : = "Sand"

func update() -> void:
	ca.change_cell_type(ca.current_cell_pos, change_to)
