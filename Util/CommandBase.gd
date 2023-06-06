extends Node
class_name Command

var prepared : = false

func prepare():
	prepared = true

func run(variant : Variant): 
#	if not can_do(variant):
#		return 
	if not prepared:
		prepare()
	
func undo(variant : Variant): 
	pass

func can_do(variant : Variant) -> bool:
	for child in get_children():
		if child is Condition:
			if child.check(variant) == false:
				return false
	return true

func complete() -> bool:
	return prepared
