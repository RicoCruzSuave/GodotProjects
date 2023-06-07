extends Node2D
class_name AIReasoner

var blackboard : = {}

var enabled : = false
var suspended : = false

var selected_option : AIOption

#Starts and stops decision making
func enable() -> void:
	enabled = true
func disable() -> void:
	enabled = false
	blackboard = {}
#Maintains state so that reasoner can pick up where it left off
func suspend() -> void:
	suspended = true
func resume() -> void:
	suspended = false
#Updates what is known and writes to blackboard
func sense() -> void:
	pass
#Picks an options for execution
func think() -> void:
	pass
#Find out whether the reasoner has anything selcted
func has_selected_option() -> bool:
	return selected_option != null
func get_selected_option():
	return selected_option
