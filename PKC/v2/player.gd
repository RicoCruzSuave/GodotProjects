extends CharacterBody2D

@onready var movement: Node2D = $Movement
@onready var interaction: Area2D = $Interaction

var interaction_target 

func move(dir : Vector2, multiplier : = 1.0) -> void:
	movement.move(dir, multiplier)
	if dir != Vector2.ZERO:
		interaction.rotation = dir.angle()
	
func interact():
	if not interaction_target:
		var areas : =  interaction.get_overlapping_areas()
		if areas:
			var interactable : = areas[0]
			interaction_target = interactable
			interactable.interact(self)

func stop_interacting():
	if interaction_target:
		interaction_target.stop()
		interaction_target = null
