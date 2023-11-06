extends Node2D
class_name Command2D

var running : = false
var prepared : = false
var completed : = false

signal prepare_done
signal command_done
signal command_reset

func prepare():
	prepared = true

func run(variant : Variant): 
	if not can_do(variant):
		return 
	if not running:
		running = true
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
	running = false
	return completed

func reset() -> void:
	running = false
	prepared = false
	completed = false	
	emit_signal("command_reset")
