extends Condition

@export_enum("Sand","Water") var cell_type 

func check(variant : Variant) -> bool:
	var type : int = variant as int
	return cell_type == type
