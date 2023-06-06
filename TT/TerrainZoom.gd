extends Node3D

@export var transition_delay : = 1.0

func _process(delta):
	var current_map : = get_current_map()
	var previous_map : Node3D
	var next_map : Node3D
	
	if current_map.get_index() != 0:
		previous_map = get_child(current_map.get_index() - 1) 
	if current_map.get_index() != get_child_count() - 1:
		next_map = get_child(current_map.get_index() + 1) 
	
	if Input.is_action_just_released("mouse_wheel_up"):
		current_map.scale += Vector3.ONE * 0.1
		
	if Input.is_action_just_released("mouse_wheel_down"):
		current_map.scale -= Vector3.ONE * 0.1
	
	if current_map.scale > Vector3.ONE * 8.0:
		current_map.scale = Vector3.ONE * 8.0
		if next_map != null:
			var tween : = create_tween()
			tween.parallel()
			tween.tween_property(current_map,"visible", false, 0.0)
			tween.tween_property(next_map,"visible", true, 0.0)
		
	if current_map.scale < Vector3.ONE:
		current_map.scale = Vector3.ONE
		if previous_map != null:
			var tween : = create_tween()
			tween.parallel()
			tween.tween_property(current_map,"visible", false, 0.0)
			tween.tween_property(previous_map,"visible", true, 0.0)

func get_current_map() -> Node3D:
	for child in get_children():
		if child.is_visible():
			return child
	return get_child(0)
