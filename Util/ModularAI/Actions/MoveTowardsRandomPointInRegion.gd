@tool
extends AIAction

@export var distance_threshold : = 5

@export_node_path("CharacterBody2D") var parent_path
@onready var parent : CharacterBody2D = get_node(parent_path) 

var target_point : = Vector2.ZERO
@onready var region : AIRegion2D = $ForwardRegion

#Called to start/stop execution
func select() -> void:
	target_point = region.random_point()
func deselect() -> void:
#	target_point = region.random_point()
	pass
#Called every frame when active
func update() -> void:
	parent.velocity += parent.global_position.direction_to(target_point)
	parent.move_and_slide()
	parent.velocity *= 0.95
	$Marker2D.position = target_point
	$Marker2D.top_level = true
	
#Some actions will always be considered done, 
# such as looping animations
func is_done() -> bool:
	return global_position.distance_to(target_point) < distance_threshold
