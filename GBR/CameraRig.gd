extends Node3D

# Converts mouse movement (pixels) to rotation (radians).
var mouse_sensitivity = 0.002

func _input(event):
	if Input.is_action_pressed("right_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		rotate_x(-event.relative.y * mouse_sensitivity)
		
	if Input.is_action_just_released("mouse_wheel_up"):
		$Camera3D.position = $Camera3D.position.move_toward(Vector3.ZERO, 0.1)
		
	if Input.is_action_just_released("mouse_wheel_down"):
		$Camera3D.position = $Camera3D.position.move_toward(Vector3.ZERO, -0.1)

	
