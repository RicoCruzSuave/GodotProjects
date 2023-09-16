@tool
extends Node3D

@export var entries : Array[TBEntry]
@export var title_text_font_size : = 16
@export var text_font_size : = 16
@export var text_material : Material 
@export var cylinder_material : Material 
@export var aligned_to_top : = false
@export var reset_text : = false :
	set(new_text) : _set_text()


@export var light_on : = false :
	set(_bool) :
		light_on = _light_on(_bool)

@onready var title_bar : = $TitleBar
@onready var entries_node : = $Entries
var entry_bar_scene : = preload("res://TB/entry_bar.tscn")
var title_bar_scene : = preload("res://TB/title_bar.tscn")

func _ready():
	_set_text()
	title_bar.get_node("Title").mesh = 	title_bar.get_node("Title").mesh.duplicate()
	_set_text()
	
func _set_text():
	#Reset text nodes
	for child in entries_node.get_children():
		child.free()
	#Add title bar
	title_bar.title = name
	if not aligned_to_top :
		title_bar.position.y = entries.size() / 2.0
	#Rebuild Text Meshes
	var i : = 0
	for entry in entries:
		var new_entry_bar : = entry_bar_scene.instantiate() 
		new_entry_bar.name = entry.title
		#Assign values to each bit
		new_entry_bar.get_node("Picture/Mesh").mesh = QuadMesh.new()
		new_entry_bar.get_node("Picture/Mesh").mesh.material = StandardMaterial3D.new()
		new_entry_bar.get_node("Picture/Mesh").mesh.material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		new_entry_bar.get_node("Picture/Mesh").mesh.material.albedo_color = Color.TRANSPARENT
		if entry.picture != null:
			new_entry_bar.get_node("Picture/Mesh").mesh.material.albedo_color = Color.BLACK
			new_entry_bar.get_node("Picture/Mesh").mesh.material.albedo_texture = entry.picture
			
			new_entry_bar.get_node("Picture/Mesh").mesh.material.emission_enabled = true
			new_entry_bar.get_node("Picture/Mesh").mesh.material.emission_energy_multiplier = 0.0
			new_entry_bar.get_node("Picture/Mesh").mesh.material.emission_texture = entry.picture
			
			var aspect_ratio : = float(entry.picture.get_width())/float(entry.picture.get_height())
			new_entry_bar.get_node("Picture/Mesh").mesh.size.x *= aspect_ratio
		new_entry_bar.get_node("Nameplate/Text").mesh = TextMesh.new()
		new_entry_bar.get_node("Nameplate/Text").mesh.font_size = title_text_font_size
		if entry.title != null:	
			new_entry_bar.get_node("Nameplate/Text").mesh.text = entry.title

		new_entry_bar.get_node("Description/Text").mesh = TextMesh.new()
		new_entry_bar.get_node("Description/Text").mesh.font_size = text_font_size
		if entry.description != null:	
			new_entry_bar.get_node("Description/Text").mesh.text = entry.description

		new_entry_bar.get_node("Introduced/Text").mesh = TextMesh.new()
		new_entry_bar.get_node("Introduced/Text").mesh.font_size = text_font_size
		if entry.introduced_in != null:	
			new_entry_bar.get_node("Introduced/Text").mesh.text = entry.introduced_in
		#Make meshes unique
		var cylinder_mesh_copy : Mesh = new_entry_bar.get_node("Picture/cylinder_half").mesh.duplicate()
		new_entry_bar.get_node("Picture/cylinder_half").mesh = cylinder_mesh_copy
		new_entry_bar.get_node("Nameplate/cylinder_half").mesh = cylinder_mesh_copy
		new_entry_bar.get_node("Description/cylinder_half").mesh = cylinder_mesh_copy
		new_entry_bar.get_node("Introduced/cylinder_half").mesh = cylinder_mesh_copy
		
		#Add cylinder material
		if cylinder_material != null:
			var cylinder_material_copy : = cylinder_material.duplicate(true)
			new_entry_bar.get_node("Picture/cylinder_half").mesh.surface_set_material(0, cylinder_material_copy)
			new_entry_bar.get_node("Nameplate/cylinder_half").mesh.surface_set_material(0, cylinder_material_copy)
			new_entry_bar.get_node("Description/cylinder_half").mesh.surface_set_material(0, cylinder_material_copy)
			new_entry_bar.get_node("Introduced/cylinder_half").mesh.surface_set_material(0, cylinder_material_copy)
		#Add text material
		if text_material != null:
			new_entry_bar.get_node("Nameplate/Text").mesh.material = text_material
			new_entry_bar.get_node("Description/Text").mesh.material = text_material
			new_entry_bar.get_node("Introduced/Text").mesh.material = text_material
		#Move to appropriate location and add to scene
		var pos : = (entries.size() / 2.0) - i	
		if aligned_to_top:
			new_entry_bar.position.y = -i
		else:			
			new_entry_bar.position.y = pos
		entries_node.add_child(new_entry_bar)
		new_entry_bar.owner = get_tree().edited_scene_root
		i += 1

func _light_on(_bool : bool):
	if get_tree() == null:
		return _bool
	for child in entries_node.get_children():
		child.turned_on = _bool
	return not _bool
