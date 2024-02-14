extends Node2D

#@export var number_of_raycasts : = 1
@export var world_reference : NodePath
@export var angle_increment : = TAU/32.0
@export var impulse_strength : = 2.0
@export var desired_wall_dist : = 24.0
@export var memory_limit : = 16

@onready var world : = get_node(world_reference)
@onready var raycast : = $RayCast2D

var memory : = []
var world_is_texture : = false
var angles : = []
var angle_counter : = 0
func _ready():
	for i in range(32):
		angles.append(TAU/32.0 * i)
	angles.shuffle()

func _process(delta):
	check_point()
	var impulse : = Vector2.ZERO
	for lidar_point in memory:
		impulse += (
			global_position.direction_to(lidar_point.pos).normalized() * \
			lidar_point.value * \
			impulse_strength) \
			/ memory.size()
	
	raycast.target_position = Vector2(0, 128).rotated(angles[angle_counter])
	angle_counter = wrapi(angle_counter + 1, 0, angles.size())
	
	if Input.is_action_pressed("ui_accept"):
		impulse += global_position.direction_to(get_global_mouse_position()) * 5.0
	
	##Debug
	print(impulse)
	get_parent().apply_central_impulse(impulse)
	
	
	
func check_point():
	var new_point : = LidarPoint.new()
	var point_pos : Vector2 = raycast.get_collision_point() + (raycast.target_position.normalized() * 8.0)
	if point_pos == Vector2.ZERO:
		point_pos = global_position + raycast.target_position
	var point_value : = point_valuation(point_pos)
	new_point.pos = point_pos
	new_point.value = point_value
	memory.append(new_point)
	if memory.size() > memory_limit:
		memory.pop_front()

## Scales value with distance
func point_valuation(point : Vector2) -> float:
	var dist : = global_position.distance_to(point)
	var point_value : = get_point_value(point)
	return point_value * (raycast.target_position.length() * pow(1.0 / dist, 2.0))

## Getting the raw value of the found object
func get_point_value(point : Vector2) -> float:
	if world_is_texture:
		var world_tex : Texture2D = world.texture
		var world_data : = world_tex.get_image()
		var world_pixel : = world_data.get_pixelv(point / world.scale)
		if world_pixel.r > 0.5:
			#Wall
			return -1.0
		if world_pixel.g > 0.5:
			return 1.0
		return 0.0
	else:
		var point_coords : Vector2i = world.local_to_map(world.to_local(point))
		match world.get_cell_source_id(0, point_coords):
			0:
				return -1.0
			2:
				return 3.0
			_:
				return 0.0
		
	
class LidarPoint:
	var pos : Vector2
	var value : = 0
