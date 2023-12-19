extends FlowContainer
#
#@export_node_path("Node2D") var commands_nodepath
@export_node_path("Node2D") var team_manager_nodepath
#
#@onready var commands_node : = get_node(commands_nodepath)
@onready var team_manager : = get_node(team_manager_nodepath)

func _ready():
	team_manager.member_switch.connect(refresh_ui)
	refresh_ui(team_manager.get_active_member())
	
func refresh_ui(player : Object):
	for child in get_children():
		child.free()
	for spell in player.get_spells():
		add_button(spell, player)
	print("was here")
	
func add_button(node : Object, player : Object):
	var new_button : = Button.new()
	new_button.add_theme_font_size_override("font", 30)
	new_button.text = node.name
	new_button.name = node.name
	add_child(new_button)
	
	#new_button.connect("pressed", action_manager.call_command.bind(node.name))
	new_button.connect("pressed", player.select_spell.bind(node.name))
