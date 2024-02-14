extends Command

@export var direction : Vector2i

func run(variant : Variant): 
	super.run(variant)
	if can_do(variant):
		return variant + direction
	return variant
	
func undo(variant : Variant): 
	var vector : Vector2i = variant as Vector2i
	return vector - direction

func can_do(variant : Variant) -> bool:
	return super.can_do(variant + direction)
