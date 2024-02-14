extends Node

##Point towards node where children are team members
@export var teams_array : Array[NodePath]

var teams : = []
var current_team_index : = 0
var current_member_index : = 0

signal team_switch
signal member_switch

func _ready():
	_initialize_teams()
	next_member()

func _initialize_teams() -> void:
	for path in teams_array:
		var new_team : = []
		for team_member in get_node(path).get_children():
			new_team.append(team_member)
		teams.append(new_team)
		
func next_team() -> void:
	current_team_index = wrapi(
		current_team_index + 1,
		0,
		teams.size(),
	)
	emit_signal("team_switch")
	emit_signal("member_switch", get_active_member())

func next_member() -> void:
	current_member_index = wrapi(
		current_member_index + 1,
		0,
		teams[current_team_index].size(),
	)
	emit_signal("member_switch", get_active_member())

func get_active_member():
	return teams[current_team_index][current_member_index]
