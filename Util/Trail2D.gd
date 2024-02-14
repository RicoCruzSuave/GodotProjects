extends Line2D

@export var points_limit : = 20

func _ready():
	top_level = true

func _process(delta):
	global_rotation = 0.0
	add_point(get_parent().global_position)
	if points.size() > points_limit:
		remove_point(0)
	queue_redraw()

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		print(points)
