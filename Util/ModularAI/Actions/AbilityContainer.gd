extends AIAction

@export var startup_time : = 1
@export var repetitions : = 1
@export var endlag_time : = 3
#@export var cooldown_time : = 1

@export_node_path("Node2D") var effect_path
@export_node_path("Node2D") var effect_parent_path #This determines where the effect spawns in the node hierarchy
@onready var effect : Node2D = get_node(effect_path)
@onready var effect_parent : Node2D = get_node(effect_parent_path)

var timer : = 0

#Called to start/stop execution
func select() -> void:
	timer = 0
func deselect() -> void:
	timer = 0
		
#Called to start/stop execution
func suspend() -> void:
	pass
func resume() -> void:
	pass 

#Called every frame when active
func update() -> void:
	if timer < startup_time:
		pass
	elif timer < startup_time + repetitions:
		var new_effect = effect.instance()
		effect_parent.add_child(new_effect)
	elif timer < startup_time + repetitions + endlag_time:
		pass
	timer += 1
#	elif timer < startup_time + repetitions + endlag_time + cooldown_time:
#		pass

#Some actions will always be considered done, 
# such as looping animations
func is_done() -> bool:
	return true if timer > startup_time + repetitions + endlag_time else false
