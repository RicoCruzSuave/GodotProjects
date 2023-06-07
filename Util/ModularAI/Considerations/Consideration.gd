@tool
extends Node2D
class_name AIConsideration

@export var score : = 0.0 
@export var base_weight : = 0.0
@export var multiplier : = 1.0


#Evalulate and determine score, store in score when complete
func calculate() -> void:
	pass

func get_results():
	return score + base_weight * multiplier

#Some functions need to know when the associated option is
# selected/deselected (for example, timing info)
func select() -> void:
	pass
func deslect() -> void:
	pass
	
