extends Node2D

@onready var body: AnimatedSprite2D = $Body
@onready var shadow: AnimatedSprite2D = $Shadow
@onready var parent : = get_parent()

var vertical_dir : = "forward"
var horizontal_dir : = "right"


func _ready() -> void:
	body.play()
	shadow.play()

func _process(_delta: float) -> void:
	var facing_dir : float = parent.facing_dir
	#Determine facing direction
	var facing_vec : = Vector2.RIGHT.rotated(facing_dir)
	facing_vec = facing_vec.round()
	if facing_vec.x == 1.0: horizontal_dir = "right"
	if facing_vec.x == -1.0: horizontal_dir = "left"
	if facing_vec.y == 1.0: vertical_dir = "forward"
	if facing_vec.y == -1.0: vertical_dir = "back"
	#if facing_dir < 0:
		#vertical_dir = "back"
	#elif facing_dir > 0:
		#vertical_dir = "forward"
	### HACK: Snap float to prevent floating point errors
	#if snappedf(abs(facing_dir), 0.00001) < snappedf(TAU/4, 0.00001):
		#horizontal_dir = "right"
	#elif snappedf(abs(facing_dir), 0.00001) > snappedf(TAU/4, 0.00001):
		#horizontal_dir = "left"
	#Make full string
	var anim_string : = get_anim_string()
	#Maintain progress in animation
	var current_frame = body.get_frame()
	var current_progress = body.get_frame_progress()
	body.play(anim_string)
	body.set_frame_and_progress(current_frame, current_progress)
	#Sync shadow
	shadow.play(anim_string)
	shadow.set_frame_and_progress(current_frame, current_progress)
	
func play(anim, speed := 1.0, reverse := false):
	body.play(anim, speed, reverse)
	
func get_anim_string() -> String:
	return "{0}_{1}_{2}".format([parent.state,vertical_dir,horizontal_dir]).to_lower()
