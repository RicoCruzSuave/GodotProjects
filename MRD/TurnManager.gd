extends Node2D
class_name TurnManager

var teams : = {
	"Example": {
		"Members": [],
		"FriendlyWith": ["Example"],
		"Goal": "KillAll",
		"Color": Color.BEIGE,
	},
	"Player": {
		"Members": [],
		"FriendlyWith": ["Example"],
		"Goal": "KillAll",
		"Color": Color.BLUE,
	},
	"Enemy": {
		"Members": [],
		"FriendlyWith": ["Example"],
		"Goal": "KillAll",
		"Color": Color.RED,
	},
}
var team_index : = 0 :	
	set(new_index): return wrapi(new_index, 0, teams.keys().size())

func get_current_team() -> String:
	return teams.keys()[team_index]

func get_team_details(team_name : String) -> Dictionary:
	return teams.get(get_current_team())

func get_team_members(team_name : String) -> Array:
	return get_team_details(team_name).get("Members")
	
func get_team_colors(team_name : String) -> Color:
	return get_team_details(team_name).get("Color")
	
func find_team_member(entity : Object) -> String:
	var team_name : = "FUCK IS THIS GUY"
	for team in teams.keys():
		if teams.get(team).get("Members").has(entity):
			team_name = team
	return team_name
			
func add_to_team(team_name : String, entity : Object) -> void:
	if teams.keys().has(team_name):
		teams[team_name]["Members"].append(entity)
	
