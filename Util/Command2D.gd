extends Node2D
class_name Command2D

var prepared : = false
var completed : = false

func prepare():
	prepared = true

func run(variant : Variant): 
#	if not can_do(variant):
#		return 
	if not prepared:
		prepare()
	
func undo(variant : Variant): 
	pass

func can_do(variant : Variant) -> bool:
	for child in get_children():
		if child is Condition:
			if child.check(variant) == false:
				return false
	return true

func is_completed() -> bool:
	return completed

func reset() -> void:
	prepared = false
	completed = false	
