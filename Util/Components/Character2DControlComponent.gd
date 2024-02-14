extends Node2D

@export var speed : = 10.0
@export var jump_speed : = 200.0
@export var fastfall_speed : = 20.0
@export var side_scroller : = true
@export var fast_fall : = true

func _process(delta):
	var body : CharacterBody2D = get_parent()
	if side_scroller:
		body.velocity.x += get_user_input().x * speed
		if body.is_on_floor():
			body.velocity.y -= max(0, get_user_input().y) * jump_speed
		else:
			if fast_fall:
				body.velocity.y += -min(0, get_user_input().y) * fastfall_speed			
	else:
		body.velocity += get_user_input() * speed
	
func get_user_input() -> Vector2:
	return Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("down", "up"),
	)
