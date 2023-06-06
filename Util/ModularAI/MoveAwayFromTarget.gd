@tool
extends AIAction

@export_node_path("CharacterBody2D") var parent_path
@onready var parent : CharacterBody2D = get_node(parent_path) 

@onready var target : AITarget2D = $CursorTarget

#Called every frame when active
func update() -> void:
	parent.velocity -= 2.0 * parent.global_position.direction_to(target.get_pos())
	parent.move_and_slide()
