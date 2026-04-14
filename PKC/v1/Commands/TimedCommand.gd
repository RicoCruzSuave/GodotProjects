extends Command
class_name TimedCommand

@export var cost_time : = 1.0
@onready var internal_timer : = cost_time


func run(variant : Variant):
	var delta : float = variant as float
	super.run(delta)
	internal_timer -= delta

func complete() -> bool:
	return internal_timer < 0.0 
