extends RigidBody2D

@export_group("Spell Stats")
@export var initial_energy : = 2.0
@export var effect_threshold : = 3.0
## NOTE: split into travel and effect?
@export var angle : = Vector2.UP
@export var speed : = 1.0
##TODO: move this to its own thing, maybe effect triggers

@export_group("Spell Components")
enum OBJECT_TYPE {
	BALL,
	BEAM,
	ARROW,
	RUNNER,
	AOE
}
@export var object_type : OBJECT_TYPE = 0
enum ENERGY_USAGE {
	ALL_AT_ONCE,
	LINEAR,
	EASE_IN,
	EASE_OUT,
	ON_TRIGGER
}
@export var energy_usage : ENERGY_USAGE = 0

#Nodepathes
@onready var effects: = $Effects
@onready var raycast: = $RayCast2D
@onready var timer: Timer = $Timer
@onready var collision: = $CollisionShape2D
@onready var label : = $Visuals/Label
@onready var path : Line2D = $Visuals/Path
@onready var path_test : RigidBody2D = $Visuals/Path/Test
@onready var effect_area: Area2D = $EffectArea

#Onready vars
@onready var current_energy : = initial_energy

const SPEED_CONST : = 10000
var time_alive : = 0.0
var origin_entity : Object

func _ready():
	#Initial Spell Configuration
	match object_type:
		OBJECT_TYPE.BALL:
			var impulse : = calculate_movement()
			apply_central_impulse(impulse)
			gravity_scale = 1.0
		OBJECT_TYPE.BEAM:
			collision.disabled = true
			raycast.enabled = true
		OBJECT_TYPE.ARROW:
			gravity_scale = 0.0
		OBJECT_TYPE.RUNNER:
			pass
		OBJECT_TYPE.AOE:
			pass
		_:
			print_debug("This doesn't exist, even more than magic already doesn't exist")
	
	#Inital movement
	pass

func _physics_process(delta : float):
	time_alive += delta
	
	#Calculate energy usage
	var expended_energy : = calculate_energy_usage()
	current_energy -= expended_energy
	#print(expended_energy)
	#print(current_energy)
	
	#Spell movement
	#var impulse : = calculate_movement() * delta * expended_energy
	#apply_central_impulse(impulse)
	
	#Effect triggers
	if get_contact_count() > 3 \
	or current_energy <= effect_threshold:
		for effect in effects.get_children():
			effect.activate(current_energy, get_affected_entities())
		free()
		return

	#Drawing
	label.text = str(roundf(current_energy))
	
	var max_points : = 100
	path.clear_points()
	var pos : = global_position
	var vel : = linear_velocity 
	
	for i in max_points:
		path.add_point(pos)
		vel += Vector2.DOWN * gravity_scale * 980 * delta
		
		var collision : = path_test.move_and_collide(vel * delta, false, 0.008, true)
		if collision:
			if physics_material_override != null:
				vel = vel.bounce(collision.get_normal()) * physics_material_override.bounce
			else:
				vel = vel.bounce(collision.get_normal()) * 0.6		
		pos += vel * delta 
		path_test.position = pos
	path.queue_redraw()
	
func calculate_movement() -> Vector2:
	match object_type:
		OBJECT_TYPE.BALL:
			#Let gravity handle it
			return angle * speed * SPEED_CONST
		OBJECT_TYPE.BEAM:
			#Dont Move
			return Vector2.ZERO
		#OBJECT_TYPE.ARROW:
			#Follow Path
			#gravity_scale = 0.0
		#OBJECT_TYPE.RUNNER:
			#pass
		#OBJECT_TYPE.AOE:
			#pass
		_:
			print_debug("Dont know how move")
			return Vector2.ZERO

func calculate_energy_usage() -> float:
	var lifetime : float = 1.0 - (timer.time_left / timer.wait_time)
	var scalar : = speed / 60.0
	match energy_usage:
		ENERGY_USAGE.ALL_AT_ONCE:
			return current_energy
		ENERGY_USAGE.LINEAR:
			return initial_energy * scalar
		ENERGY_USAGE.EASE_IN:
			if lifetime == 0:
				return 0.0
			return initial_energy * -log(lifetime) * scalar
		ENERGY_USAGE.EASE_OUT:
			return initial_energy * exp(lifetime) * scalar
		ENERGY_USAGE.ON_TRIGGER, _:
			print_debug("???")
			return 0.0

func get_affected_entities():
	match object_type:
		OBJECT_TYPE.BALL:
			return effect_area.get_overlapping_bodies()
		OBJECT_TYPE.BEAM:
			return [raycast.get_collider()] if raycast.is_colliding() else []
		#OBJECT_TYPE.ARROW:
			#Follow Path
			#gravity_scale = 0.0
		#OBJECT_TYPE.RUNNER:
			#pass
		#OBJECT_TYPE.AOE:
			#pass
		_:
			print_debug("Dont know how move")
			return Vector2.ZERO
