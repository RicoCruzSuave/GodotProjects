extends Node2D
class_name Command2D

var prepared : = false
var running : = false
var completed : = false

signal prepare_done
signal command_done
signal command_reset

#@export_node_path("Node2D") var conditions_path : = NodePath("Conditions")
#@onready var conditions : = get_node(conditions_path)

#func old_prepare(variant : Variant = null):
	#if not can_do():
		#return 
	#if not running:
		#running = true
	#prepared = true
	
func run(): 
	if not prepared:
		return
	
func undo(): 
	pass

#func can_do() -> bool:
	#for child in conditions.get_children():
		#if child is Condition:
			#if child.check(self) == false:
				#return false
	#return true

func is_completed() -> bool:
	return completed

func reset() -> void:
	running = false
	prepared = false
	completed = false	
	emit_signal("command_reset")
