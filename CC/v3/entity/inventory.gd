extends Node2D

var holding : = false
@onready var holding_spot: Marker2D = $Holding

func add_item(item : Object) -> bool:
	if holding:
		return false
	var item_parent : Node = item.get_parent()
	if item_parent != null:
		item_parent.remove_child(item)
	holding_spot.add_child(item)
	holding = true
	return true

func get_holding_item() -> Object:
	if holding and holding_spot.get_child_count() > 0:
		return holding_spot.get_child(0)
	else:
		return null

func remove_item(item : Object) -> void:
	if holding_spot.get_children().has(item):
		holding_spot.remove_child(item)
	holding = false
