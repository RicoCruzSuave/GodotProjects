extends Node2D

@export_node_path("RigidBody2D") var creature_body 
@onready var creature : RigidBody2D = get_node(creature_body)

@export_node_path("RigidBody2D") var item_body 
@onready var item : RigidBody2D = get_node(item_body)

func run(variant : Variant):
	var pos : = variant as Vector2
#	item.apply_central_impulse(global_position.direction_to(get_global_mouse_position() * creature.strength))
	item.apply_central_impulse(global_position.direction_to(pos).normalized() * 100.0)
	
