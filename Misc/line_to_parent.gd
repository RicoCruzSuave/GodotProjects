@tool
extends Line2D


func _ready():
	points.resize(2)
	_compute_points()

func _process(_delta):
	_compute_points()

func _compute_points():
	points[0] = get_parent().global_position
	points[1] = global_position
