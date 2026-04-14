extends Node2D

@export var player : CharacterBody2D

var input_map : = {
	"switch": Input.is_key_pressed(KEY_TAB),
}

var state

func _ready() -> void:
	if get_child_count():
		state = get_child(0)
	#if player:
		#for child in get_children():
			#child.player = player

func _process(_delta: float) -> void:
	if get_child_count() < 1 :
		print_debug("No states")
		set_process(false)
	else:
		state.update()
