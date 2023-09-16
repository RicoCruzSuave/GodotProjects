@tool
extends Node3D

@export_node_path("Node3D") var points_node_path
@onready var points_node : = get_node(points_node_path)

@export var draw_lines : = false : 
	set(new_bool) : _draw_lines()

@export var iterations : = 3
@export var circle_size : = 1.0
@export var line_size : = 1.0

func _draw_lines():
	_clear_lines()
	_recurse_children(points_node.get_children(), iterations)

func _recurse_children(children : Array, counter : = 1):
	if children == [] or counter <= 0:
		return
	var last_child : Node3D
	for child in children:
		if child is Node3D:
			add_node(child, float(counter) / float(iterations))
			if last_child != null:
				connect_nodes(last_child, child, float(counter) / float(iterations))
			last_child = child
			_recurse_children(child.get_children(), counter - 1)
	
	
func _clear_lines():
	for child in get_children():
		child.free()
				
func add_node(node : Node3D, size_modifier : = 1.0):
	var circle : = MeshInstance3D.new()
	circle.mesh = SphereMesh.new()
	circle.mesh.height = circle_size * size_modifier
	circle.mesh.radius = circle_size * size_modifier / 2.0 
	
	circle.owner = get_tree().edited_scene_root
	add_child(circle)
	
	circle.global_position = node.global_position
	


func connect_nodes(node1 : Node3D, node2 : Node3D, size_modifier : = 1.0):
	var line : = MeshInstance3D.new()
	line.mesh = CylinderMesh.new()
	line.mesh.top_radius = line_size * size_modifier
	line.mesh.bottom_radius = line_size * size_modifier
	
	line.owner = get_tree().edited_scene_root
	add_child(line)
	
	line.mesh.height = node1.global_position.distance_to(node2.global_position)
	line.global_position = (node1.global_position + node2.global_position) / 2.0
	line.look_at(node1.global_position, Vector3.UP)
