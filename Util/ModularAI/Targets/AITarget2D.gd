@tool
extends Node2D
class_name AITarget2D

var entity 
var pos : = Vector2.ZERO

func has_entity() -> bool:
	return entity != null

func get_entity():
	return entity

func get_pos() -> Vector2:
	if has_entity():
		return entity.position
	return pos
