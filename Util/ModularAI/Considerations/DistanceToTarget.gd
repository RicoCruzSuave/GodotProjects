@tool
extends AIConsideration

@export var distance_threshold : = 16
@onready var target : AITarget2D = $CursorTarget

#Evalulate and determine score, store in weights when complete
func calculate() -> void:
#	var new_score := position.distance_to(target.get_position())
	var new_score := global_position.distance_to(target.get_pos())
	#Add in function to run weight functions
	new_score = min(new_score, distance_threshold)
	new_score /= distance_threshold
	new_score = 1.0 - new_score
	score = new_score
