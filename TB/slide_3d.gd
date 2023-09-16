@tool
extends Node3D

@export var focused : = false
@export_multiline var text : = "Explanation Text Goes here" 
@export var text_spacing : = 0.25
@export var text_font_size : = 16
@export var text_mesh_depth : = 1
@export var reset_text : = false :
	set(new_text) : _set_text()

@onready var display_node : = $Display
@onready var text_node : = $Text

#func _ready():
	#_set_text()
	
func _set_text():
	#Reset text nodes
	for child in text_node.get_children():
		child.free()
	#Rebuild Text Meshes
	var lines : = text.split("\n")
	var pos : = (lines.size()-1) * text_spacing
	for i in lines.size():
		var new_text_mesh : = MeshInstance3D.new()
		new_text_mesh.mesh = TextMesh.new()
		new_text_mesh.mesh.text = lines[i]
		new_text_mesh.mesh.depth = text_mesh_depth * 0.001
		new_text_mesh.mesh.font_size = text_font_size
		new_text_mesh.position.y = (pos/2.0) - (i * text_spacing)
		text_node.add_child(new_text_mesh)
		new_text_mesh.owner = get_tree().edited_scene_root
