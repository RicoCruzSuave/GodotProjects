extends Node2D

@export var side_scroller : = true
@export var gravity : = 98.0
@export var friction : = 0.01

func _process(delta):
	var body : CharacterBody2D = get_parent()

	#Gravity
	if not body.is_on_floor():
		body.velocity.y += gravity
	#Friction
	body.velocity *= 1.0 - friction
