extends Node2D

@export var side_scroller : = true
@export var gravity : = 98.0
@export var speed : = 100.0
@export var friction : = 0.1

func _process(_delta):
	var body : CharacterBody2D = get_parent()

	if side_scroller:
		#Gravity
		if not body.is_on_floor():
			body.velocity.y += gravity
	#Friction
	body.velocity += get_user_input() * speed
	body.move_and_slide()
	body.velocity *= 1.0 - friction

func get_user_input() -> Vector2:
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down"),
	)
