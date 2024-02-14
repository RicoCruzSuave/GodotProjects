@tool
extends Node2D

@onready var sprite : = $Sprite2D

@export var dispersion_rate := 1.0
@export var friction := 0.1
@export var bounce := 0.0 
@export var lifetime := 0 
@export var temperature := 10.0 
@export var cell_name : = "Sand"
@export var cell_size : = Vector2i(16,16)
@export_color_no_alpha var color : = Color.CORAL : 
	set(new_color):
		color = new_color
		if Engine.is_editor_hint():
			$Sprite2D.modulate = color

@export var max_speed : = 10.0
var velocity : = Vector2.ZERO
		
func _process(delta):
	if !Engine.is_editor_hint():
		var force : = (get_global_mouse_position() + velocity)  - global_position
		force = force.limit_length(max_speed)
		velocity += force
		velocity *= 1.0 - friction
		position += velocity
		
