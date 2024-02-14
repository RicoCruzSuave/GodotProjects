extends Resource
class_name Atom

@export var color : = Color.WHITE

func update(neighbors : Dictionary) -> bool:
	return false

#func act(neighbors : Dictionary) -> Array:
	#Intake neighbors and return swap coordinates in pairs
	#Chess style eg (1,2),(3,4) 
	#	- world node will perform swap cells on these two coordinates
	#	- can also replace second coord with a transformation (1,2), { "type" : TYPE.FIRE }
	#	- maybe use a dict? or make an instruction struct? 
	# 	- transformation made directly on other cell?
	
func get_color() -> Color:
	return color
