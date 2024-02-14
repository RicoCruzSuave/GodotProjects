extends Node2D

@export var direction : Vector2i
@export var magnitude : int = 1

func run(pos : Vector2i) -> Vector2i:
	return pos + (direction * magnitude)
