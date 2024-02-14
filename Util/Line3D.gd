@tool
extends Node3D

@export var line_radius : = 0.1
@export var line_resolution : = 8

func _process(delta):
	var circle : = PackedVector2Array()
	for degree in line_resolution:
		var x : = line_radius * sin(TAU * degree / line_resolution)
		var y : = line_radius * cos(TAU * degree / line_resolution)
		var coords : = Vector2(x,y)
		circle.append(coords)
	$CSGPolygon3D.polygon = circle
