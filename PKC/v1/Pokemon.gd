extends CharacterBody3D
class_name Pokemon

@export var commands : = []
@onready var command_list : = $CommandList
@export var action_enabled : = false

func has_command() -> bool:
	return command_list.get_child_count() > 0

func _process(delta):
	if action_enabled and has_command():
		command_list.run(delta)
			
