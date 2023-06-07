extends CharacterBody2D

@export_node_path("Node2D") var turn_manager_path
@onready var turn_manager : TurnManager = get_node(turn_manager_path)

@export var team : = "Player"

@onready var polygon : = $Polygon2D
@onready var collision : = $CollisionPolygon2D

var currently_focused : = false

func _ready():
	turn_manager.add_to_team(team, self)
	polygon.color = turn_manager.get_team_colors(team)
