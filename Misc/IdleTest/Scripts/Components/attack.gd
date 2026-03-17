extends Node2D

var component_target

const HITBOX = preload("uid://hkty8jqu3o1f")

var attack_time : = 1.0
#var attack_timing = startup + active + cooldown 

func attack():
	var hitbox : = HITBOX.instantiate()
	hitbox.top_level = true
	hitbox.global_position = global_position
	add_child(hitbox)
	component_target.state_blocking = true
	await get_tree().create_timer(attack_time).timeout
	component_target.state_blocking = false
	
