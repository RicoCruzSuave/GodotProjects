extends CharacterBody2D
class_name LDUnit

@export var attack : = 1.0
@export var attack_speed : = 1.0
@export var movement_speed : = 1.0
@export var health : = 10.0
@export var movement_target_path : NodePath
@export var team_name : = "Left"

@onready var health_bar : = $Control/VBoxContainer/ProgressBar
@onready var health_component : = $HealthComponent

@onready var team_component : = $TeamComponent

@onready var body_collision : = $BodyCollision
@onready var equipment : = $Equipment
@onready var fight_area : = $FightArea

@onready var attack_timer : = $AttackTimer
@onready var state_label : = $Control/VBoxContainer/PanelContainer/Label

@onready var movement_target : = get_node(movement_target_path)

enum STATES {
	WALKING,
	ATTACKING,
	WAITING,
	DEAD
}
var current_state : = STATES.WAITING
var current_target : LDUnit

var disabled : = true

func _ready():
	health_component.connect("dead", change_state.bind(STATES.DEAD))
	attack_timer.wait_time = 1.0/attack_speed
	team_component.team_name = team_name

func _physics_process(delta):
	var friction : = 0.01
	if disabled:
		return
	
	match current_state:
		STATES.WAITING:
			friction = 0.1
			if attack_timer.is_stopped() and check_for_fight():
				change_state(STATES.ATTACKING)
			elif not check_for_fight():
				change_state(STATES.WALKING)
		STATES.WALKING:
			if check_for_fight():
				change_state(STATES.ATTACKING)
			velocity += global_position.direction_to(movement_target.global_position) * movement_speed
		STATES.ATTACKING:
			if attack_timer.is_stopped():
				current_target.damage(attack)
				attack_animation()
				attack_timer.start()
				await get_tree().create_timer(0.1).timeout
				change_state(STATES.WAITING)
		_, STATES.DEAD:
			set_process(false)
			body_collision.disabled = true
			
	move_and_slide()
	velocity *= 1.0 - friction 
			
func check_for_fight():
	#If there is not a fight and there should be one, start it
	for body in fight_area.get_overlapping_bodies():
		if body is LDUnit and not team_component.is_on_same_team(body):
			#return start_fight(self, body)
			current_target = body
			return true
	#If there is a fight, return it
	#for area in fight_area.get_overlapping_areas():
		#if area is LDFight:
			#return area
	return false		
	
func attack_animation():
	var dir_to_target : Vector2 = equipment.global_position.direction_to(current_target.global_position)
	var strength : = attack * 100
	equipment.apply_impulse(dir_to_target * strength, Vector2.UP * -43)
		

func damage(amount : float):
	health_component.damage(amount)
	health_bar.value = (health_component.current_health / health_component.max_health) * 100
	
func change_state(to_state : int):
	current_state = to_state
	var state_string := "ERROR"
	match to_state:
		STATES.WALKING:
			state_string = "WALKING"
		STATES.ATTACKING:
			state_string = "ATTACKING"
		STATES.WAITING:
			state_string = "WAITING"
		STATES.DEAD:
			state_string = "DEAD"
	state_label.text = state_string
