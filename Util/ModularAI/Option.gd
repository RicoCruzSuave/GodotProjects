@tool
extends Node2D
class_name AIOption

#If true then the reasoner should suspend the previously executing option
# when this option is selected, rather than deselecting it.
@export var push_on_stack_when_selected : = false
@export var reset_when_done : = false

@export var score : = 0.0 
@export var base_weight : = 0.0
@export var multiplier : = 1.0

@export var predicate : String 

var selected : = false
var suspended : = false

func select() -> void:
	selected = true
	for child in get_children():
		if child is AIAction: 
			var action : AIAction = child
			action.select()
		if child is AIConsideration:
			var consideration : AIConsideration = child
			consideration.select()
			
func deselect() -> void:
	selected = false
	for child in get_children():
		if child is AIAction: 
			var action : AIAction = child
			action.deselect()
		if child is AIConsideration:
			var consideration : AIConsideration = child
			consideration.deslect()
	
func suspend() -> void:
	suspended = true
	for child in get_children():
		if child is AIAction: 
			var action : AIAction = child
			action.suspend()
			
func resume() -> void:
	suspended = false
	for child in get_children():
		if child is AIAction: 
			var action : AIAction = child
			action.resume()
	
func update() -> void:
	for child in get_children():
		if child is AIAction:
			var action : AIAction = child
			action.update()
	
func is_done() -> bool:
	for child in get_children():
		if child is AIAction:
			var action : AIAction = child
			if not action.is_done():
				return false
	return true

func update_considerations():
	for child in get_children():
		if child is AIConsideration:
			var consideration : AIConsideration = child
			consideration.calculate()
	
func update_score():
	score = base_weight
	for child in get_children():
		if child is AIConsideration:
			var consideration : AIConsideration = child
			score += consideration.get_results() 
	score *= multiplier
