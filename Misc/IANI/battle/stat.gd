extends Node2D
class_name IANIStat

@export var ui : Control
@export_range(0, 100) var value : = 100.0 :
	set = set_value
@export var max_value : = 100.0

@onready var ui_label : Label = ui.get_node("Label")
@onready var ui_progress_bar : ProgressBar = ui.get_node("ProgressBar")

func _ready() -> void:
	ui_label.text = name + " " + str(round(value))
	ui_progress_bar.value = value

func set_value(new_value) -> void:
	if not is_node_ready():
		await ready
	value = min(new_value, max_value)
	ui_label.text = name + " " + str(round(value))
	ui_progress_bar.value = value
