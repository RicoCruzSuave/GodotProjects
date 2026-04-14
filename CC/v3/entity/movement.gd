extends Node2D

@export var top_speed : = 100.0
@export var friction : = 0.1
@export var inertia : = 1.0
@export var accel : = 1.0


@onready var parent : CharacterBody2D = get_parent()

func _physics_process(_delta: float) -> void:
	parent.velocity *= 1.0 - friction
	parent.velocity = parent.velocity.clamp(-Vector2.ONE * top_speed, Vector2.ONE * top_speed)
	parent.move_and_slide()

func move(dir : Vector2, multiplier : = 1.0) -> void:
	parent.velocity += dir * accel * multiplier
