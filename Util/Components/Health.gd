extends Node2D

@export var max_health : = 10.0
@export var min_health : = 1.0
@export var current_health : = max_health

@export_node_path("Node") var parent_path
@onready var parent : Object = get_node(parent_path)

signal hit
signal dead

func damage(amount : float):
	current_health -= amount
	check_death()
	emit_signal("hit")
	
func check_death():
	if current_health <= min_health:
		die()
		
func die():
	parent.modulate = Color.DIM_GRAY
	emit_signal("dead")
