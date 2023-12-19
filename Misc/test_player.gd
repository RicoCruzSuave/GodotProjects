extends RigidBody2D
class_name Player

@onready var spells_node : = $Projectiles

var current_spell 

func get_spells() -> Array:
	return spells_node.get_children()

func select_spell():
	pass
