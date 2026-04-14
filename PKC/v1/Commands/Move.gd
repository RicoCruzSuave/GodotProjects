extends TimedCommand

@export var target : = Vector3.ZERO
@export var direction : = Vector3.ZERO

@export_node_path("Pokemon") var parent_path
@onready var parent : = get_node(parent_path)

@export var path : = Curve3D.new()

func prepare():
	super.prepare()
	calculate_cost()

func calculate_cost():
	path.clear_points()
	path.add_point(parent.position)
	path.add_point(parent.position + target)
#	cost_time = path.get_baked_length() * 10
#	internal_timer = cost_time 
	
func run(delta : float) -> void:
	super.run(delta)
	parent.position = path.sample(0, 1.0 - (internal_timer / cost_time))
	
func complete() -> bool:
	return internal_timer < 0.0 
