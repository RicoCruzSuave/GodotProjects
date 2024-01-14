extends RigidBody2D
class_name Player

@onready var spells_node : = $Projectiles
var current_spell 
const TEST_SPELL = preload("res://Misc/test_spell.tscn")

func _input(event):
	if Input.is_action_just_pressed("left_click"):
		var new_spell : = TEST_SPELL.instantiate()
		new_spell.object_type = new_spell.OBJECT_TYPE.BALL
		new_spell.global_position = get_global_mouse_position()
		add_child(new_spell)
		new_spell.top_level = true
		
	if Input.is_action_just_pressed("right_click"):
		var new_spell : = TEST_SPELL.instantiate()
		new_spell.object_type = new_spell.OBJECT_TYPE.BEAM
		new_spell.global_position = get_global_mouse_position()
		add_child(new_spell)
		new_spell.top_level = true
		
	if Input.is_action_just_pressed("up"):
		print(Engine.time_scale)
		Engine.time_scale = 1.0
	if Input.is_action_just_pressed("down"):
		print(Engine.time_scale)
		Engine.time_scale = 0.1
		
	


func get_spells() -> Array:
	return spells_node.get_children()

func select_spell():
	pass
