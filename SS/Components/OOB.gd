extends Condition

@export var bounds : Rect2

func check(variant : Variant) -> bool:
	var pos : Vector2 = variant as Vector2
	return bounds.has_point(pos)
