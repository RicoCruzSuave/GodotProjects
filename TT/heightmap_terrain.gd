@tool
extends MeshInstance3D

@export var noise : NoiseTexture2D
@export var size : = Vector2(512,512)
@onready var collision : = $StaticBody3D/CollisionShape3D

func _ready():
	var collision_shape : = HeightMapShape3D.new()
	var noise_data : PackedFloat32Array = noise.noise.get_image(size.x, size.y).get_data().to_float32_array()
	collision_shape.map_width = noise.get_width()
	collision_shape.map_depth = noise.get_height()
	collision_shape.map_data = noise_data
	collision.shape = collision_shape
	
