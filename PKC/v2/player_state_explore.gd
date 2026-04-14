extends Node2D

@onready var player = get_parent().player

var input_map : = {
	"dir": get_input_dir,
	"run": Input.is_action_pressed.bind("ui_accept"),
	"interact": Input.is_action_just_pressed.bind("interact"),
}

#var states : = {
	#"IDLE": "idle",
	#"WALK": "walk",
	#"RUN": "run",
	#"INTERACT": "interact",
#}
enum STATES {
	IDLE,
	WALK,
	RUN,
	INTERACT,
}

var state

#var mult : = 1.0

func _ready() -> void:
	if get_child_count():
		state = get_child(0)
		
func update():
	##DEBUG
	if Input.is_action_just_pressed("ui_accept"):
		print(state.name)
	
	var input_dir : Vector2 = input_map["dir"].call()
	var interact_pressed : bool = input_map["interact"].call()
	
	if interact_pressed:
		if player.interaction_target == null:
			player.interact()
		else:
			player.stop_interacting()
	#if input_dir:
		#player.move(input_dir, mult)
	if player.interaction_target != null:
		state = get_child(STATES.INTERACT)
		
	elif input_map["run"].call():
		state = get_child(STATES.RUN)
		#state = states["RUN"]
		#mult = 1.5
	elif input_dir:
		state = get_child(STATES.WALK)
		#state = states["WALK"]
		#mult = 1.0
	else:
		state = get_child(STATES.IDLE)
		#state = states["IDLE"]
	state.update(input_dir)
		

func get_input_dir() -> Vector2:
	return Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down"),
		)
