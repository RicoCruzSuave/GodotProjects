extends Node2D

@export var turning_speed : = TAU/4.0 / 60.0
@export var equipped_item : RigidBody2D

func _physics_process(_delta: float) -> void:
	if equipped_item:

		var angle_diff : = global_rotation - equipped_item.global_rotation
		angle_diff = min(abs(angle_diff), turning_speed) * sign(angle_diff)
		print(angle_diff)

		equipped_item.apply_torque(angle_diff)
