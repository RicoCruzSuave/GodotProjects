@tool
extends Node2D

@export_tool_button("Order Children") var order_var : = order_children

@export var hand_size : = 7
@export var x_range : = Vector2(-400, 400)

func _ready() -> void:
	child_order_changed.connect(order_children)

func order_children():
	var child_count : = get_child_count()
	var hand_range : Vector2 = lerp(Vector2.ZERO, x_range, min(1.0, float(child_count) / float(hand_size)))
	var step : = (hand_range.y - hand_range.x) / (child_count - 1)
	var counter : = 0
	for current_child in get_children():
		current_child.position.x = counter * step + hand_range.x
		counter += 1
