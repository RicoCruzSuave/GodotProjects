extends Area2D

@export var ladder_limits : = Vector2(0, 255.0)
@export var ladder_speed : = Vector2(0.2, 2.0)

@onready var ladder_stops: StaticBody2D = $LadderStops

var target : Object


var input_map : = {
	"dir": get_input_dir,
	"run": Input.is_action_pressed.bind("ui_accept"),
}
func can_interact():
	return true

func interact(new_target):
	target = new_target
	target.global_position.x = global_position.x
	ladder_stops.process_mode = Node.PROCESS_MODE_DISABLED
	if target is CharacterBody2D:
		(target as CharacterBody2D).motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		target.velocity *= 0.0
	
func stop():
	ladder_stops.process_mode = Node.PROCESS_MODE_ALWAYS
	if target is CharacterBody2D:
		(target as CharacterBody2D).motion_mode = CharacterBody2D.MOTION_MODE_GROUNDED
	target = null
		
func pass_control():
	var input_dir : Vector2 = input_map["dir"].call()
	if input_dir:
		var move_dir : = input_dir * ladder_speed
		if input_map["run"].call():
			move_dir *= 2.0
		target.global_position += move_dir 
		target.global_position.x = clamp(
			target.global_position.x, 
			global_position.x - ladder_limits.x, 
			global_position.x + ladder_limits.x
		)
		target.global_position.y = clamp(
			target.global_position.y, 
			global_position.y - ladder_limits.y, 
			global_position.y + ladder_limits.y
		)

func get_input_dir() -> Vector2:
	return Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down"),
		)
