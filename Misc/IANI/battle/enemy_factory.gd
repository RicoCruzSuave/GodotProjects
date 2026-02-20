extends Node2D

@onready var templates: Node2D = $Templates

func spawn():
	var enemy : = templates.get_child(
		randi_range(0, templates.get_child_count() - 1)
	).duplicate()
	enemy.global_position = global_position
	enemy.scale *= randf_range(0.25, 4.0)
	enemy.add_to_group("enemy")
	add_sibling(enemy)
	enemy.active = true
