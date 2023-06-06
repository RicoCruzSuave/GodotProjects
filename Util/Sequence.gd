extends Node
class_name Sequence

enum BREAKPOINT {
	FIRST,
	FIRST_AVAILABLE,
	ALL,
	ALL_AVAILABLE
}
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
	DELETE_WHEN_DONE
}

@export var break_point : BREAKPOINT = BREAKPOINT.FIRST
@export var order : ORDER = ORDER.SEQUENTIAL
@export var resolution : RESOLUTION = RESOLUTION.NOTHING

##DONT USE
func run(variant : Variant):
	for command in get_current_nodes(variant):
		var data = command.run(variant)
		resolve(command)
		if data != null:
			return data
	return variant

func get_current_nodes(variant : Variant) -> Array:
	var children : = get_children()
	var nodes_list : = []
	for child in children:
		if child is Command:
			nodes_list.append(child)
		if child is Sequence:
			nodes_list.append_array(child.get_current_nodes(variant))
	if order == ORDER.RANDOM:
		nodes_list.shuffle()
	match break_point:
		BREAKPOINT.ALL:
			return nodes_list
		BREAKPOINT.ALL_AVAILABLE:
			var available_nodes : = []
			for node in nodes_list:
				if node.can_do(variant):
					available_nodes.append(node)
			return available_nodes
		BREAKPOINT.FIRST_AVAILABLE:
			for node in nodes_list:
				if node.can_do(variant):
					return [node]
			return []
		BREAKPOINT.FIRST, _:
			return [nodes_list[0]]
			
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
		RESOLUTION.DELETE_WHEN_DONE:
			if node.complete():
				node.free()
		RESOLUTION.NOTHING, _:
			pass
		
func has_nodes() -> bool:
	return get_child_count() > 0
	
func get_current_node(variant : Variant) -> Node:
	return get_current_nodes(variant)[0]

