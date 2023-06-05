@tool
extends Node2D

@export var bounds : Rect2

@export var randomize_locations : = false : 
	set(new_bool) : _randomize_locations()


func _randomize_locations():
	for child in get_children():
		child.position = Vector2(
			randi_range(bounds.position.x, bounds.end.x),
			randi_range(bounds.position.y, bounds.end.y)
		)
