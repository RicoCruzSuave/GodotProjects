extends Node2D

func run(variant : Variant):
	var child : = get_child(randi() % get_child_count())
	return child.run(variant)
