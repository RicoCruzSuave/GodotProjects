extends RigidBody2D

@export var size : = 10.0
@export var decay_rate : = 5.0

func _process(delta):
	
	if not $VisibleOnScreenEnabler2D.is_on_screen():
		free()
		
	size -= delta * decay_rate
	if size <= 0.0:
		free()
	#mass = size * 10.0
	$CollisionShape2D.shape.radius = size
	$Sprite2D.scale = Vector2(size/10.0, size/10.0)
