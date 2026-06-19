extends CharacterBody2D

@onready var ai: Node2D = $AI
@onready var travel_target: Marker2D = $AI/Traveling/TravelTarget
@onready var movement: Node2D = $Movement

func _physics_process(delta: float) -> void:
	movement.move_towards(travel_target.global_position)
