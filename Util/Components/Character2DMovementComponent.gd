extends Node2D

@export var top_speed : = 256.0
@export var friction : = 0.1
@export var inertia : = 1.0
@export var accel : = 3.0
@export var gravity : = 10.0
@export var jump_modifier : = 10.0
@export var direct_control : = true
#@export var side_scroller : = false

@onready var parent : CharacterBody2D = get_parent()
@onready var side_scroller : = parent.motion_mode == CharacterBody2D.MOTION_MODE_GROUNDED

func _physics_process(_delta: float) -> void:
	if direct_control:
		var input_dir : = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down"),
		)
		
		move(input_dir)
		
	if parent.motion_mode == CharacterBody2D.MOTION_MODE_GROUNDED:
		parent.velocity += Vector2.DOWN * gravity
	parent.velocity *= 1.0 - friction
	parent.velocity = parent.velocity.clamp(-Vector2.ONE * top_speed, Vector2.ONE * top_speed)
	parent.move_and_slide()

func move(dir : Vector2, multiplier : = 1.0) -> void:
	if parent.motion_mode == CharacterBody2D.MOTION_MODE_GROUNDED:
		if parent.is_on_floor():
			dir.y *= jump_modifier
		else:
			dir.y *= 0.0
	parent.velocity += dir * accel * multiplier
