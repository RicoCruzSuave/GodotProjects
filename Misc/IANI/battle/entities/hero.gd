extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon: Node2D = $Weapon

#region Signals
signal attack
signal hit
signal die
#endregion

#region StatVars
@onready var stat_health: Node2D = $Stats/Health
@onready var stat_stamina: Node2D = $Stats/Stamina
@onready var stat_speed: Node2D = $Stats/Speed

var health :
	set(new_value): stat_health.value = new_value
	get: return stat_health.value
var stamina :
	set(new_value): stat_stamina.value = new_value
	get: return stat_stamina.value
var speed :
	set(new_value): stat_speed.value = new_value
	get: return stat_speed.value
#endregion

func walk_to(pos : Vector2, time : = 1.0):
	#sprite.play("walk")
	var tween : = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", pos, time)
	#tween.tween_callback(func(): sprite.play("idle"))

func _physics_process(_delta: float) -> void:
	#if weapon.ready_to_use:
		#sprite.play("attack")
	if weapon.can_use:
		if stamina > weapon.effort_cost:
			stamina -= weapon.effort_cost
			weapon.use()
			attack.emit()
	#else:
		#var effort : = 1.0
		#if stamina > effort:
			#stamina -= effort
			#weapon.cooldown(effort)
	stamina += float(speed) * _delta

func damage(amount) -> void:
	hit.emit()
	health -= amount
	if health <= 0:
		modulate = Color.DARK_SLATE_GRAY
		die.emit()
		#sprite.play("death")
