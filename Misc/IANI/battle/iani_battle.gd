extends Node2D

@onready var hero_spot: Marker2D = $HeroSpot
@onready var hero: CharacterBody2D = $Hero
@onready var enemy_factory: Node2D = $EnemyFactory

var wave_active : = false

func _ready() -> void:
	set_process(false)
	prepare()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		hero.damage(19)

func _process(_delta: float) -> void:
	check_for_end()

func prepare():
	hero.walk_to(hero_spot.global_position)
	for _i in range(10):
		get_tree().create_timer(randf_range(0.1,30.0))\
			.timeout.connect(enemy_factory.spawn)
	set_process(true)


func check_for_end():
	var heroes : = get_tree().get_nodes_in_group("hero")
	var enemies : = get_tree().get_nodes_in_group("enemy")
	if heroes.size() == 0:
		## Lose
		set_process(false)
		pass
	if enemies.size() == 0:
		## Win
		set_process(false)
		print_debug("Win")
		pass
