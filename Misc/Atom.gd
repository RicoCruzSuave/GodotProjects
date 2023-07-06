extends Resource
class_name Atom

@export var density : = 1
@export var temp : = 1
@export var type : = 0

func _init():
	pass

#func act(neighbors : Dictionary) -> Array:
	#Intake neighbors and return swap coordinates in pairs
	#Chess style eg (1,2),(3,4) 
	#	- world node will perform swap cells on these two coordinates
	#	- can also replace second coord with a transformation (1,2), { "type" : TYPE.FIRE }
	#	- maybe use a dict? or make an instruction struct? 
	# 	- transformation made directly on other cell?
	

func get_color():
	pass
