@tool
extends Node3D

@export var turned_on : = false : 
	set(_bool) : 
		turned_on = _set_on(_bool)
	
func _set_on(_bool : bool):
	if not is_inside_tree():
		return false
	var cylinder_material : Material = $Picture/cylinder_half.mesh.surface_get_material(0)
	var picture_material : Material = $Picture/Mesh.mesh.surface_get_material(0)
	var tween : = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_parallel(true)
	if turned_on:
		tween.tween_property(cylinder_material, "emission_energy_multiplier", 0.0, 1.0)
		tween.tween_property(picture_material, "emission_energy_multiplier", 0.0, 1.0)
		#tween.tween_property(picture_material, "albedo_color", Color.TRANSPARENT, 1.0)
	else:
		tween.tween_property(cylinder_material, "emission_energy_multiplier", 1.0, 1.0)		
		tween.tween_property(picture_material, "emission_energy_multiplier", 0.5, 1.0)		
		#tween.tween_property(picture_material, "albedo_color", Color.WHITE, 1.0)
		
	#$Picture/cylinder_half.mesh.surface_set_material(0, material)
	#$Nameplate/cylinder_half.mesh.surface_set_material(0, material)
	#$Description/cylinder_half.mesh.surface_set_material(0, material)
	#$Introduced/cylinder_half.mesh.surface_set_material(0, material)
	return _bool
