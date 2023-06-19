@tool
extends AIAction

@export_node_path("Node2D") var ca_path
@onready var ca : = get_node(ca_path)

@export var move_direction : = Vector2i.ZERO

func update() -> void:
	ca.current_cell.data.desired_direction = move_direction

