@tool
extends AIAction

@export var print_delay : = 1.0
@export var message : = "PRINT"
@onready var timer : = $Timer

func _ready():
	timer.wait_time = print_delay

#Called to start/stop execution
func select() -> void:
	if timer.is_stopped():
		timer.start()
func deselect() -> void:
#	timer.stop()
	pass
#Called every frame when active
func update() -> void:
#	if timer.is_stopped():
	print(message)
#Some actions will always be considered done, 
# such as looping animations
func is_done() -> bool:
	return true
