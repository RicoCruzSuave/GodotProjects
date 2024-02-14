extends Node2D
class_name ActionManager

var tracked_entities : = {}

#Action co routine
#Has: time cost, needs_focus, action script

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
			update_entities()

func _physics_process(delta):
	update_entities()

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
	#Check to make sure no entity is waiting on instruction
	for entity in tracked_entities.keys():
		var current_stack : Array = tracked_entities[entity]["stack"]
		if current_stack.size() <= 0:
			wait_for_new_action()
			return
	#Update all entities
	for entity in tracked_entities.keys():		
		var current_stack : Array = tracked_entities[entity]["stack"]
		entity.currently_focused = false 
		var action = current_stack[0]
		if not action.is_done():
			action.update()
	#Check to make sure all actions are done before next one starts
	for entity in tracked_entities.keys():
		var current_stack : Array = tracked_entities[entity]["stack"]
		var action = current_stack[0]
		if not action.is_done():
			return
	#Cycle to next action 
	for entity in tracked_entities.keys():
		var current_stack : Array = tracked_entities[entity]["stack"]
		var action = current_stack[0]
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
	for entity in tracked_entities.keys():
		if tracked_entities[entity]["stack"].is_empty():
			entity.currently_focused = true
			break







