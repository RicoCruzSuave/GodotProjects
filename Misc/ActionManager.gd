extends Node2D

##Provides logic for executing actions

@export_node_path("Node2D") var team_manager_path
@export_node_path("Node2D") var actions_list_path
@export_node_path("ProgressBar") var timer_ui_path

@onready var team_manager : = get_node(team_manager_path)
@onready var actions_list : = get_node(actions_list_path)
@onready var timer_ui : ProgressBar = get_node(timer_ui_path)

##TODO: Needs reference to team manager, actions list, and a button hookup

var timer : = Timer.new()
var planning_phase : = false
var actions : = []
var action_index : = 0

var current_action : = "ERROR"

func _ready():
	timer.autostart = true
	add_child(timer)
	
	#timer.connect("timeout", team_manager.next_team)
	#Engine.time_scale = 0.3
	#set_real_time(5)
	timer.connect("timeout", switch_phase)
	switch_phase()
	
	for child in actions_list.get_children():
		actions.append(child)
	
func _process(delta):
	timer_ui.value = timer.time_left / timer.wait_time
	
#func _input(event):
	#if planning_phase:
		#if Input.is_action_just_pressed("ui_accept"):
			#timer.stop()
			#timer.emit_signal("timeout")
			#timer.start()
			
func call_command(command_name : String):
	var speed : = 1000
	var radius : = 36
	var command : Command2D = get_child_by_name(command_name, actions_list)
	command.prepare([
		team_manager.get_active_member().get_global_position, 
		get_global_mouse_position, 
		1000, 
		36
	])
	if current_action != "ERROR" and current_action != command_name:
		get_child_by_name(current_action, actions_list).reset()
	current_action = command_name
	if not team_manager.is_connected("team_switch", command.reset):
		team_manager.connect("team_switch", command.reset, CONNECT_ONE_SHOT)
	
func switch_phase():
	planning_phase = !planning_phase
	if planning_phase:
		Engine.time_scale = 0.0001
		set_real_time(15)
	else:
		Engine.time_scale = 1.0
		set_real_time(0.5)
		team_manager.next_team()
	
func set_real_time(time : float):
	timer.wait_time = time * Engine.time_scale
	timer.start()
	
func get_child_by_name(child_name : String, parent_node : Node = self) -> Node:
	for child in parent_node.get_children():
		if child.name == child_name:
			return child
	return null
