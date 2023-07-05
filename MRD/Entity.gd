extends CharacterBody2D

@export_node_path("Node2D") var turn_manager_path
@onready var turn_manager : TurnManager = get_node(turn_manager_path)

@export var team : = "Player"

@onready var polygon : = $Polygon2D
@onready var collision : = $CollisionPolygon2D
@onready var movement : = $Movement
@onready var pathfinding : = $Pathfinding

var currently_focused : = false

func _ready():
	turn_manager.add_to_team(team, self)
	polygon.color = turn_manager.get_team_colors(team)

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		pathfinding.path_to(get_global_mouse_position())
	if Input.is_action_just_pressed("ui_accept"):
		movement.move_to_next_point()
