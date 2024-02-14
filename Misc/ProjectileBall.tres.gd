extends RigidBody2D

@export_category("Projectile Variables")
@export var speed_scalar : = 10.0
@export var radius_scalar : = 1.0
@export var decay_rate : = 0.0

@onready var shape : CircleShape2D = $CollisionShape2D.shape
@onready var sprite : = $Sprite2D

func _process(delta):
	
	if not $VisibleOnScreenEnabler2D.is_on_screen():
		free()
	
	var size : = shape.radius
	size -= delta * decay_rate
	if size <= 0.0:
		free()
	#mass = size * 10.0
	shape.radius = size
	sprite.scale = Vector2(size/10.0, size/10.0)
