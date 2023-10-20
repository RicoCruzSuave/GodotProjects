extends Node

@export var team_name : String : 
	set(new_name) : 
		team_name = _set_team_name(new_name)
@export_node_path("Node") var parent_path : = NodePath("..")

@onready var parent : Node = get_node(parent_path)
	
func _set_team_name(new_name : String):
	if new_name != null or new_name != "":
		parent.add_to_group(new_name)
	return new_name
		
func is_on_same_team(other : Node) -> bool:
	return other.get_groups().has(team_name)
