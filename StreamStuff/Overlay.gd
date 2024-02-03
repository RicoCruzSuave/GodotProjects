@tool
extends Control

@export_group("Text")
@export var solo : = false :
	set = set_solo
@export var team_name : = "TestTeam" : 
	set = set_team_name
@export_multiline var member_names : = "Test" : 
	set = set_member_names
@export var game_name : = "TestGame" : 
	set = set_game_name
@export_multiline var game_description : = "Test Description" : 
	set = set_game_description

@export_group("Text Size")
@export var title_size : = 35 : 
	set = set_title_size
@export var subtitle_size : = 25 : 
	set = set_subtitle_size

@onready var team_name_label : = $VBoxContainer/TextBoxes/TeamPanel/VBoxContainer2/TeamName
@onready var team_members_label : = $VBoxContainer/TextBoxes/TeamPanel/VBoxContainer2/TeamMembers
@onready var game_name_label : = $VBoxContainer/TextBoxes/GamePanel/VBoxContainer/GameName
@onready var game_description_label : = $VBoxContainer/TextBoxes/GamePanel/VBoxContainer/Genre

var is_ready : = false

func _ready():
	is_ready = true

func set_solo(is_solo : bool):
	if is_ready:
		team_members_label.visible = not is_solo
		solo = is_solo
	
func set_team_name(_name : String):
	if is_ready:
		team_name = _name
		team_name_label.text = team_name
	
func set_member_names(_name : String):
	if is_ready:
		member_names = _name
		team_members_label.text = member_names
	
func set_game_name(_name : String):
	if is_ready:
		game_name = _name
		game_name_label.text = game_name
	
func set_game_description(_name : String):
	if is_ready:
		game_description = _name
		game_description_label.text = game_description
	
func set_title_size(_size : int):
	if is_ready:
		title_size = _size
		team_name_label.add_theme_font_size_override("font_size", title_size)
		game_name_label.add_theme_font_size_override("font_size", title_size)

func set_subtitle_size(_size : int):
	if is_ready:
		subtitle_size = _size
		team_members_label.add_theme_font_size_override("font_size", subtitle_size)
		game_description_label.add_theme_font_size_override("font_size", subtitle_size)


#func _ready():
	#get_viewport().transparent_bg = true
	##get_window().transparent = true
	#get_window().transparent_bg = true
	##get_window().mouse_passthrough = true
	##get_window().borderless = true
	#DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	##DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_MOUSE_PASSTHROUGH, true)
	##DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true, 0)
	##DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true, 0)
	
