extends Node2D
class_name Command2D

var running : = false
var prepared : = false
var completed : = false

signal prepare_done
signal command_done
signal command_reset

func prepare(variant : Variant = null):
	if not can_do():
		return 
	if not running:
		running = true
	prepared = true
	
func run(): 
	if not prepared:
		return
	
func undo(): 
	pass

func can_do() -> bool:
	return true
#func can_do(variant : Variant) -> bool:
	#for child in get_children():
		#if child is Condition:
			#if child.check(variant) == false:
				#return false
	#return true

func is_completed() -> bool:
	return completed

func reset() -> void:
	running = false
	prepared = false
	completed = false	
	emit_signal("command_reset")
