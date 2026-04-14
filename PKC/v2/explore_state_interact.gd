extends Node2D

@onready var player = get_parent().player


func _ready() -> void:
	await get_parent().ready
	player = get_parent().player


func update(input_dir : Vector2):
	var interaction_object = player.interaction_target
	interaction_object.pass_control()
	
