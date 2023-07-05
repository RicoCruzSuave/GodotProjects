extends Node2D

var tracked_entities : = [
	{
		"name": "Player",
		"stack": [],
	},
	{
		"name": "Enemy",
		"stack": []
	}
]

#Action co routine
#Has: time cost, needs_focus, action script


func update_entities():
	for entity in tracked_entities:
		var current_stack : Array = entity.stack
		if current_stack.size() <= 0:
			wait_for_new_action()
		else:
			var action = current_stack[0]
			action.act()
			if action.is_done():
				current_stack.pop_front()
			
func wait_for_new_action():
	pass 







