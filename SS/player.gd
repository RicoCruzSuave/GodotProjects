extends CharacterBody2D
class_name SSPlayer

@export_node_path("Node2D") var spellbook 

var spell_index : = 0
var angle : = 0.0
var current_spell = null
var drawing : = false

func _process(delta):
	move_and_slide()
	queue_redraw()

func _draw():
	if drawing:
		draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(angle) * 64, Color.RED)

func cast_spell():
	pass
