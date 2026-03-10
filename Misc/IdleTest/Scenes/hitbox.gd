extends Area2D

@export var time_to_live : = 1.0

@onready var ttl : = time_to_live 

func _physics_process(delta: float) -> void:
	ttl -= delta
	if ttl <= 0:
		queue_free()
