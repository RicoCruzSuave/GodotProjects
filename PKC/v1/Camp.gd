extends Node3D

@export var current : = false
@export_node_path("Node3D") var camera_path 

@onready var camera : = get_node(camera_path) 

func _input(event):
	if not current:
		return
	if Input.is_action_just_pressed("left_click"):
		var command = $PokemonA.commands[0]
		var new_command_node : = Node3D.new()
		new_command_node.set_script(command)
		new_command_node.parent_path = $PokemonA.get_path()
		new_command_node.target = $PokemonA.to_local(camera.get_mouse_position())
		new_command_node.target.y = 0
		$PokemonA/CommandList.add_child(new_command_node)
