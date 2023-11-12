extends Node2D

@onready var line : = $Line2D
@onready var raycast : = $RayCast2D
@onready var timer : = $Timer
@onready var area : = $Area2D
@onready var area_collision : = $Area2D/CollisionShape2D

@export var duration : = 3.0

@onready var max_width : float = line.width  

func _ready():
	timer.wait_time = duration
	timer.start()
	area_collision.shape = RectangleShape2D.new()
	
func cast_to_target(target : Vector2):
	raycast.target_position = to_local(target)
	
func _process(delta):
	line.width = max_width * pow(timer.time_left / timer.wait_time, 0.5)
	var raycast_point : Vector2 = raycast.get_collision_point() if raycast.get_collision_point() != Vector2.ZERO else to_global(raycast.target_position)
	line.clear_points()
	line.add_point(Vector2.ZERO)
	line.add_point(to_local(raycast_point)) 
	
	area_collision.shape.size.x = global_position.distance_to(raycast_point)
	area_collision.shape.size.y = line.width
	area.global_position = (global_position + raycast_point) / 2.0
	area.look_at(raycast_point)
	
	if line.width <= 0.0:
		free()
