extends Node2D
class_name ActionManager

var tracked_entities : = {}

#Action co routine
#Has: time cost, needs_focus, action script

func add_tracked_entity(object : Object):
	tracked_entities[object] = {
		"name": object.name,
		"stack": [],
	}

func queue_action(object : Object, action : AIAction):
	if tracked_entities.has(object):
		var entity : Dictionary = tracked_entities.get(object)
		if entity["stack"].is_empty():
			action.select()
		entity["stack"].append(action)

func update_entities():
	for entity in tracked_entities.keys():
		var current_stack : Array = tracked_entities[entity]["stack"]
		if current_stack.size() <= 0:
			wait_for_new_action()
		else:
			var action = current_stack[0]
			action.update()
			if action.is_done():
				current_stack[0].deselect()
				current_stack.pop_front()
				if not current_stack.is_empty():
					current_stack[0].select()
					
func skip_next_action(object : Object):
	if tracked_entities.has(object):
		var entity : Dictionary = tracked_entities.get(object)
		if not entity["stack"].is_empty():
			entity["stack"].pop_front()
			
func wait_for_new_action():
	pass 







