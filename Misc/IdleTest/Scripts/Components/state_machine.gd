@tool
extends Node2D

signal state_entered
signal state_exited

@export var STATES : Array[String] = [] :
	set = set_states_nodes
@export var debug : = false

@onready var label: Label = $Label

var blocking : = false

var component_target : = get_parent()

var state = 0 :
	set = set_state,
	get = get_state
	
func _process(_delta: float) -> void:
	if debug:
		label.text = get_state() + " " + str(blocking)

func set_states_nodes(new_array : Array[String]) -> void:
	STATES = new_array#.map(func(a): return a.to_upper()) as Array[String]
	if Engine.is_editor_hint():
		get_tree().call_group("state_node", "free")
		for state_name in STATES:
			var new_state_node : = Node2D.new()
			#print(state_name)
			
			new_state_node.name = state_name
			new_state_node.add_to_group("state_node")
			add_child(new_state_node)
			new_state_node.owner = get_tree().edited_scene_root

func set_state(new_state) -> void:
	if blocking:
		return
	if new_state is int:
		## Change State
		state_exited.emit(state)
		state = new_state
		state_entered.emit(STATES[new_state])
	elif new_state is String:
		## Find state by name
		var new_state_index : = STATES.find(new_state)
		if new_state_index == -1:
			print("Cannot find state ", new_state)
			return
		## Change state
		state_exited.emit(state)
		state = new_state_index
		state_entered.emit(new_state_index)
	else:
		print_debug("Tried to set state to something weird ", new_state)
	
func get_state() -> String:
	return STATES[state]
			
			
			
			
			
			
