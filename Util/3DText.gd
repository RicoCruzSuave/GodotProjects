@tool
extends MeshInstance3D
class_name Text3D

@onready var parent : = get_parent()

@export var set_text : = false :
	set = display_text

func _init():
	if Engine.is_editor_hint():
		display_text()

func _ready():
	display_text()

func display_text(_val = false):
	mesh = TextMesh.new()
#	if Engine.is_editor_hint():
	if get_parent() != null:
		mesh.text = get_parent().name
#	else:
#		mesh.text = parent.name
#	name = mesh.text
