@tool
extends Node
class_name Sequence

#enum BREAKPOINT {
	#FIRST,
	#ALL,
#}
enum ORDER {
	SEQUENTIAL,
	RANDOM
}
enum RESOLUTION {
	NOTHING,
	RANDOMIZE_ORDER,
	MOVE_TO_FRONT,
	MOVE_TO_BACK,
	DELETE,
}

@export var test_tool : = false : 
	set(_bool) : debug()

#@export var break_point : BREAKPOINT = BREAKPOINT.FIRST
@export var order : ORDER = ORDER.SEQUENTIAL
@export var resolution : RESOLUTION = RESOLUTION.NOTHING

func debug():
	print(get_current_node())

func get_nodes() -> Array:
	var children : = get_children()
	var nodes_list : = []
	for child in children:
		if child is Sequence:
			nodes_list.append_array(child.get_nodes())
		nodes_list.append(child)
	if order == ORDER.RANDOM:
		nodes_list.shuffle()
	return nodes_list
		
	#match break_point:
		#BREAKPOINT.ALL:
			#return nodes_list
		#BREAKPOINT.FIRST, _:
			#return [nodes_list[0]]
			
func resolve(node : Node):
	match resolution:
		RESOLUTION.MOVE_TO_FRONT:
			move_child(node, 0)
		RESOLUTION.MOVE_TO_BACK:
			move_child(node, -1)
		RESOLUTION.RANDOMIZE_ORDER:
			move_child(node, randi() % get_child_count())
		RESOLUTION.DELETE:				
			node.free()
		RESOLUTION.NOTHING, _:
			pass
		
func has_nodes() -> bool:
	return get_child_count() > 0
	
func get_current_node(resolve_when_done : = false) -> Node:
	var current_node : Node2D = get_nodes()[0]
	if resolve_when_done:
		resolve(current_node)
	return current_node
	
func get_number_of_nodes() -> int:
	return get_child_count()


