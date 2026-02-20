extends Node2D

@export var card_resource : Card
@export var hand_height : = 128
@export var tween_trans : Tween.TransitionType
@export var animation_speed : = 0.1

@onready var mouse_detection: Button = $Sprite2D/MouseDetection
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Sprite2D/Label
@onready var targeting_mode: Node2D = $TargetingMode

var hovering : = false

func _ready() -> void:
	mouse_detection.mouse_entered.connect(hover)
	mouse_detection.mouse_exited.connect(put_away)
	#mouse_detection.pressed.connect(targeting_mode.enable)
	if card_resource:
		label.text = card_resource.resource_path.split("/")[-1].split(".")[0]

func _process(_delta: float) -> void:
	if not card_resource:
		push_error("Needs card resource")

func hover() -> void:
	if not hovering:
		hovering = true
		var tween : = create_tween().set_ease(Tween.EASE_OUT).set_trans(tween_trans)
		tween.tween_property(sprite, "position", Vector2(0, 0), animation_speed)

func put_away() -> void:
	if hovering:
		hovering = false
		var tween : = create_tween().set_ease(Tween.EASE_OUT).set_trans(tween_trans)
		tween.tween_property(sprite, "position", Vector2(0, hand_height), animation_speed)

func play_card():
	var target : Area2D = targeting_mode.get_target()
	if target:
		card_resource.play(targeting_mode.get_target())
	targeting_mode.disable()
