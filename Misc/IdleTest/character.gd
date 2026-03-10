extends CharacterBody2D

#region Onready Vars
@onready var state_machine: Node2D = $StateMachine
@onready var movement: Node2D = $Movement
@onready var visuals: Node2D = $Visuals
@onready var facing: Node2D = $Facing
@onready var attack: Node2D = $Facing/Attack
#endregion
#region Exposed Vars
var state :
	set(new_value): state_machine.state = new_value
	get: return state_machine.state
var facing_dir :
	set(new_value): facing.rotation = new_value
	get: return facing.rotation
#endregion

func _ready() -> void:
	state_machine.state_entered.connect(state_entered)
	set_component_target_recursive(self, "component_target")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		state_machine.state = "ATTACK"
	
	var input_dir : = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down"),
	)
	movement.move(input_dir)
	if input_dir:
		state_machine.state = "WALK"
		facing_dir = input_dir.angle()
	#else:
		#state_machine.state = "IDLE"
	
	
func state_entered(_new_state):
	if state == "ATTACK":
		visuals.play(visuals.get_anim_string(), 1.0 / 3.0)
		state_machine.blocking = true
		attack.attack()
		
func set_component_target_recursive(root_node: Node, var_name: String, limit : = 10) -> void:
	# Check if the current node has the variable
	if var_name in root_node:
		root_node.set(var_name, limit)
		print("Set ", var_name, " on: ", root_node.name)

	# Recursively check all children
	for child in root_node.get_children():
		set_component_target_recursive(child, var_name, limit)


		
#region Expose Methods
func move(dir : Vector2, multiplier : = 1.0) -> void:
	movement.move(dir, multiplier)
#endregion


	
