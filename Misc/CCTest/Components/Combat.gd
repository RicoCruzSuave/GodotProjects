extends Node2D

@onready var left_hand_item : = $LeftHand.get_child(0)
@onready var right_hand_item : = $RightHand.get_child(0)


@export var hand_radius : = 5.0
@export var active : = false : 
	set(is_active):
		active = is_active
		change_combat_stance()
		
		
func change_combat_stance():
	var tween : = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_parallel(true)
	$LeftHand/Fist.freeze = true
	$RightHand/Fist.freeze = true
	if active:
		tween.tween_property($LeftHand, "position", Vector2(0, -hand_radius), 0.2)
		tween.tween_property($RightHand, "position", Vector2(0, hand_radius), 0.2)
#		tween.tween_property($LeftHand, "modulate", Color.WHITE, 0.2)
#		tween.tween_property($RightHand, "modulate", Color.WHITE, 0.2)
		tween.tween_property($LeftHand/Fist/Polygon2D, "scale", Vector2.ONE, 0.3)
		tween.tween_property($RightHand/Fist/Polygon2D, "scale", Vector2.ONE, 0.3)
		tween.chain()
		tween.tween_callback($LeftHand/Fist/CollisionPolygon2D.set_disabled.bind(false))
		tween.tween_callback($RightHand/Fist/CollisionPolygon2D.set_disabled.bind(false))
	else:
		tween.tween_property($LeftHand, "position", Vector2.ZERO, 0.2)
		tween.tween_property($RightHand, "position", Vector2.ZERO, 0.2)
#		tween.tween_property($LeftHand, "modulate", Color8(0,0,0,0), 0.2)
#		tween.tween_property($RightHand, "modulate", Color8(0,0,0,0), 0.2)
		tween.tween_property($LeftHand/Fist/Polygon2D, "scale", Vector2.ZERO, 0.3)
		tween.tween_property($RightHand/Fist/Polygon2D, "scale", Vector2.ZERO, 0.3)
		tween.tween_callback($LeftHand/Fist/CollisionPolygon2D.set_disabled.bind(true))
		tween.tween_callback($RightHand/Fist/CollisionPolygon2D.set_disabled.bind(true))
	
	tween.chain()
	tween.tween_callback(reset_hand.bind($LeftHand))
	tween.tween_callback(reset_hand.bind($RightHand))
	tween.chain()
	tween.tween_callback($LeftHand/Fist.set_freeze_enabled.bind(false))
	tween.tween_callback($RightHand/Fist.set_freeze_enabled.bind(false))
	
	
func reset_hand(hand : PinJoint2D):
	await get_tree().physics_frame
	var path : = hand.node_b
	hand.node_b = ""
	hand.get_child(0).position = Vector2.ZERO
	hand.node_b = path
	


