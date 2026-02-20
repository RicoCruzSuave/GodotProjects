extends CharacterBody2D

@export var max_speed : = 10.0
@export var speed : = 1.0
@export var size : = 1.0
@export var health : = 100.0
@export var friction : = 0.1
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var active : = false

func _physics_process(_delta: float) -> void:
	if active:
		if not sprite.is_playing():
			sprite.play("walk")
		velocity.x -= speed
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.x *= 1.0 - friction
	move_and_slide()

func damage(amount) -> void:
	health -= amount
	sprite.play("hurt")
	active = false
	await sprite.animation_finished
	active = true
	if health <= 0:
		active = false
		modulate = Color.DARK_SLATE_GRAY
		sprite.play("death")
		collision.disabled = true
		await sprite.animation_finished
		await get_tree().create_timer(5.0).timeout
		queue_free()

func knockback(amount) -> void:
	velocity.x += max_speed * amount
