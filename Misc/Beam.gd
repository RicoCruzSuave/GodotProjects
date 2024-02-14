extends ProjectileCommand2D


func setup_projectile(object : Object):
	var new_beam : Node2D = object
	new_beam.cast_to_target(target_pos)
