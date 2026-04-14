extends Node3D

@export var current : = false
@export var combatants : = []

func register_combatant(pokemon : Pokemon):
	combatants.append(pokemon)

func _process(delta):
	var action_stopped : = false
	for child in get_children():
		if child is Pokemon:
			if not child.has_command():
				action_stopped = true
	enable_action(not action_stopped)
	
func enable_action(is_enabled : bool):
	for child in get_children():
		if child is Pokemon:
			child.action_enabled = is_enabled
			
func _input(event):
	if not current:
		return
	if Input.is_action_just_pressed("left_click"):
		var command = $PokemonA.commands[0]
		var new_command_node : = Node3D.new()
		new_command_node.set_script(command)
		new_command_node.parent_path = $PokemonA.get_path()
		new_command_node.target = Vector3(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0.0,
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		$PokemonA/CommandList.add_child(new_command_node)
	if Input.is_action_just_pressed("right_click"):
		var command = $PokemonB.commands[0]
		var new_command_node : = Node3D.new()
		new_command_node.set_script(command)
		new_command_node.parent_path = $PokemonB.get_path()
		new_command_node.target = Vector3(
			Input.get_action_strength("right") - Input.get_action_strength("left"),
			0.0,
			Input.get_action_strength("down") - Input.get_action_strength("up")
		)
		$PokemonB/CommandList.add_child(new_command_node)
		
		
		
		
		
		
		
		
		
