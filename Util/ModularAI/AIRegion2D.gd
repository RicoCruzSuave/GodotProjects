@tool
extends Node2D
class_name AIRegion2D

@export var shape : Shape2D
@export var debug_draw : = false

func _draw():
	if debug_draw:
		draw_rect(shape.get_rect(), Color.RED, false)
		
#func _process(delta):
#	_draw()
#	if Engine.is_editor_hint():
#		queue_redraw()

func in_region(pos : Vector2):
	return shape.get_rect().has_point(pos)
	
func random_point() -> Vector2:
	var shape_rect : = shape.get_rect()
	return Vector2(
		randf_range(shape_rect.position.x, shape_rect.end.x),
		randf_range(shape_rect.position.y, shape_rect.end.y),
	) + global_position
