@tool
extends Node2D
class_name AIAction

#Called to start/stop execution
func select() -> void:
	pass
func deselect() -> void:
	pass 
	
	
#Called to start/stop execution
func suspend() -> void:
	pass
func resume() -> void:
	pass 
#Called every frame when active
func update() -> void:
	pass
#Some actions will always be considered done, 
# such as looping animations
func is_done() -> bool:
	return true
