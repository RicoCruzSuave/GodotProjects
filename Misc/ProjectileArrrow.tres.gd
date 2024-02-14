extends RigidBody2D

@export var turning_radius : = TAU/4.0
@export var speed : = 100.0

var end_target : Vector2
var direction : Vector2

func _process(delta):
	if direction != null:
		var current_angle : = direction.angle()
		var desired_direction : = global_position.direction_to(end_target)
		var desired_angle : = desired_direction.angle()
		var angle : = lerp_angle(current_angle, desired_angle, 1.0)
		angle = clamp(
			angle, current_angle - turning_radius * delta * Engine.time_scale, current_angle + turning_radius * delta)
		direction = Vector2.RIGHT.rotated(angle)
		#direction = direction.lerp(desired_direction, turning_radius)

		$RayCast2D.target_position = direction * 25
		apply_central_impulse(direction * speed * delta * 60)
