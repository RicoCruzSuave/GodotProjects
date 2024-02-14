extends Node2D

@export var inventory_list : = []
@export var inventory_limit : = 16
var current_index : = 0

func get_current_item():
	return inventory_list[current_index]
	
func next():
	current_index = wrapi(current_index + 1, 0, inventory_list.size())
	
func previous():
	current_index = wrapi(current_index - 1, 0, inventory_list.size())
