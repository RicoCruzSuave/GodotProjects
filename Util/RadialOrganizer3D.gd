@tool
extends Node3D

@export var radius : = 1.0
@export var up_vec : = Vector3.UP

@export var organize : = false : 
	set(new_bool) : _organize()

func _organize():
	if get_child_count() > 0:	
		var index : = get_child_count()
		var angle_offset : = TAU / index
		for i in range(index):
			var offset_pos : = global_position
			offset_pos += Vector3(radius,0,0).rotated(up_vec, angle_offset * i)
			get_child(i).global_position = offset_pos
