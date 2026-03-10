extends Node2D

var component_target

const HITBOX = preload("uid://hkty8jqu3o1f")

func attack():
	var hitbox : = HITBOX.instantiate()
	hitbox.top_level = true
	hitbox.global_position = global_position
	add_child(hitbox)
	
