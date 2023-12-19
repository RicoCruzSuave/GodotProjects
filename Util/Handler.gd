@tool
extends Node2D
class_name ChainHandler

@export var run_tool : = false : 
	set(_bool) : handle({})

## Handler
enum HANDLER_TYPE {
	SEQUENTIAL,
	CONCURRENT
}

@export var handler_order : HANDLER_TYPE = HANDLER_TYPE.CONCURRENT

var current_data : Dictionary

func handle(data : Dictionary) -> Dictionary:
	current_data = data
	
	match handler_order:
		HANDLER_TYPE.CONCURRENT:
			for child in get_children():
				if child.has_method("handle"):
					child.handle(data)
		HANDLER_TYPE.SEQUENTIAL, _:
			for child in get_children():
				if child.has_method("handle"):
					if child.has_method("is_completed") and not child.is_completed():
						child.handle(data)
						break
	print(current_data)
	return current_data
	
func is_completed() -> bool:
	for child in get_children():
		if child.has_method("is_completed") and not child.is_completed():
			return false
	return true
