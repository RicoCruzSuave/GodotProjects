extends Node2D

@export_node_path("Node2D") var oob_path
@onready var oob : Node2D = get_node(oob_path)


@export_node_path("Node2D") var collision_path
@onready var collision : Node2D = get_node(collision_path)

func run(current_pos : Vector2i) -> Vector2i:
	if oob.check(current_pos):
		for child in get_children():
			var result = child.run(current_pos)
			if result != null and not collision.check(result):
				return result
	return current_pos
