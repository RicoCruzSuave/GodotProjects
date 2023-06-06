@tool
extends AIReasoner
class_name AIReasonerScoreBased

@export var fuzzy_factor : = Vector2.ZERO
@export var lower_threshold : = 0.0
@export var test : = false 
#	set(_bool) : sense(); think();

func _process(delta):
	if test:
		sense()
		think()


#Updates what is known and writes to blackboard
func sense() -> void:
	if get_child_count() <= 0:
		return
	for child in get_children():
		if child is AIOption:
			var option : AIOption = child
			option.update_considerations()
			option.update_score()
#Picks an options for execution
func think() -> void:
	if get_child_count() <= 0:
		return
	for child in get_children():
		if child is AIOption:
			var new_option : AIOption = child
			if selected_option == null:
				selected_option = child
			var selected_option_score : = selected_option.score + randf_range(fuzzy_factor.x, fuzzy_factor.y)
			var new_option_score : = new_option.score + randf_range(fuzzy_factor.x, fuzzy_factor.y)
			if new_option_score < lower_threshold:
				continue
			if new_option_score > selected_option_score:
				if new_option.push_on_stack_when_selected:
					selected_option.suspend()
				else:
					selected_option.deselect()
				if new_option.suspended:
					new_option.resume()
				else:
					new_option.select()
				selected_option = new_option
	if selected_option.is_done():
		selected_option.deselect()
		if selected_option.reset_when_done:
			selected_option.select()
	selected_option.update()
	

