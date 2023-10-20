@tool
extends Node3D

@export_multiline var title : = "Test" : 
	set(string): 
		title = _set_text(string)

@export var turned_on : = false : 
	set(_bool) : 
		turned_on = _set_on(_bool)


func _set_on(_bool : bool):
	if get_tree() == null:
		return _bool
	var cylinder_material : Material = $cylinder_half.mesh.surface_get_material(0)
	var text_material : Material = $Title.mesh.surface_get_material(0)
	var tween : = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	if turned_on:
		tween.tween_property(cylinder_material, "emission_energy_multiplier", 0.0, 0.5)
		tween.tween_property(text_material, "emission_energy_multiplier", 0.0, 0.5)
	else:
		tween.tween_property(cylinder_material, "emission_energy_multiplier", 0.5, 0.5)		
		tween.tween_property(text_material, "emission_energy_multiplier", 0.5, 0.5)		
		
	#$Picture/cylinder_half.mesh.surface_set_material(0, material)
	#$Nameplate/cylinder_half.mesh.surface_set_material(0, material)
	#$Description/cylinder_half.mesh.surface_set_material(0, material)
	#$Introduced/cylinder_half.mesh.surface_set_material(0, material)
	return _bool

func _set_text(title : String):
	if get_tree() == null:
		return title
	if Engine.is_editor_hint():
		$Title.mesh.text = title
	return title
