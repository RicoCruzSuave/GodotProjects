extends Node2D

var origin  
var target
var angle
var power 

var aiming_options : = {}

func _input(event):
	if aiming_options.has("target"):
		if Input.is_action_just_pressed("left_click"):
			aiming_options.target.position = get_global_mouse_position()
			
	if aiming_options.has("angle"):
		if Input.is_action_just_pressed("right_click"):
			aiming_options.angle = origin.position.direction_to(get_global_mouse_position())
			set_process(false)
			
	if aiming_options.has("power"):
		if Input.is_action_pressed("mouse_wheel_up"):
			power += 0.1
		if Input.is_action_pressed("mouse_wheel_down"):
			power -= 0.1

	if Input.is_action_just_pressed("ui_accept"):
		#Finish and reset
		aiming_options = {}
		set_process(true)
		
func _process(delta):
	if aiming_options.has("angle"):
		angle = origin.position.direction_to(get_global_mouse_position())
	
func _draw():
	if aiming_options.has("origin"):
		draw_circle(aiming_options.origin.position, 16.0, Color.WHITE)
		if aiming_options.has("target"):
			draw_circle(aiming_options.target.postion, 16.0, Color.RED)
			if aiming_options.has("angle"):
				draw_line(
					aiming_options.origin.position, 
					aiming_options.origin.position \
				 	+ Vector2.RIGHT.rotated(aiming_options.angle)
					, Color.BLUE, 
					aiming_options.get("power", 2.0)
				)
			else:
				draw_line(
					aiming_options.origin.position, 
					target, 
					Color.BLUE,
					aiming_options.get("power", 2.0)
				)
				
