extends CharacterBody2D

@onready var health_bar : = $Control/VBoxContainer/ProgressBar
@onready var health_component : = $HealthComponent

func damage(amount : float):
	health_component.damage(amount)
	health_bar.value = health_component.current_health / health_component.max_health
