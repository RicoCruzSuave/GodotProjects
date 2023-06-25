extends CACell
class_name CACellFalling

@export var color : = Color.DEEP_PINK

@export_flags("DOWN", "DIAGONAL_DOWN", "SIDES", "UP") var move_directions
@export_node_path("Node2D") var reasoner_path 

@export var dispersion_rate : = 1.0
@export var inertial_resisitance : = 0.5
@export var conductivity : = 1.0

var sleeping : = false
var temp : = 100.0

@export var desired_direction : = Vector2i.ZERO

