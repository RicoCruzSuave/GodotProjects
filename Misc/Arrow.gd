extends ProjectileCommand2D

var end_target : Vector2

func prepare(variant : Variant = null):
	if variant:
		start_pos = variant[0] 
		target_pos = variant[1] 
		speed = variant[2] 
		radius = variant[3] 
	#Prepare aiming
	$AimingSequence/AimLine.origin = variant[0] 
	$AimingSequence/AimLine.target = variant[1] 
	$AimingSequence/AimTarget.target = variant[1] 
	$AimingSequence/AimTarget.radius = variant[3]
	#Wait for resolution
	print($AimingSequence.get_number_of_nodes())
	for _i in $AimingSequence.get_number_of_nodes():
		var node : Node2D = $AimingSequence.get_current_node(true)
		node.drawing_enabled = true
		await node.aiming_finished
		node.drawing_enabled = false
	#for node in $AimingSequence.get_nodes():
		#node.drawing_enabled = true
		#await node.aiming_finished
		#node.drawing_enabled = false
	#Take values
	start_pos = $AimingSequence/AimLine.start_pos
	target_pos = $AimingSequence/AimLine.end_pos
	end_target = $AimingSequence/AimTarget.target
	speed = 0.0
	if not can_do():
		return
	prepared = true

func setup_projectile(object : Object):
	super.setup_projectile(object)
	var new_arrow : RigidBody2D = object
	new_arrow.direction = start_pos.direction_to(target_pos)
	new_arrow.end_target = end_target
	prepared = false

func complete():
	super.complete()
	reset()

func reset():
	for node in $AimingSequence.get_nodes():
		node.reset()	
	super.reset()
