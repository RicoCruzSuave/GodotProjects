extends CharacterBody2D

#region Onready Vars
@onready var movement: Node2D = $Movement
#@onready var visuals: Node2D = $Visuals
@onready var facing: Node2D = $Facing
@onready var interaction: Node2D = $Facing/Interaction
@onready var inventory: Node2D = $Facing/Inventory
#endregion
#region Exposed Vars
var facing_dir :
	set(new_value): facing.rotation = new_value
	get: return facing.rotation
var holding :
	set(new_value): inventory.holding = new_value
	get: return inventory.holding
#endregion

func _process(_delta: float) -> void:
	var input_dir : = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down"),
	)
		
	if input_dir:
		movement.move(input_dir)
		facing_dir = input_dir.angle()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		## Pick up
		if holding and not interaction.can_interact():
			var holding_item = inventory.get_holding_item()
			var success : bool = interaction.place(holding_item)
			if success: 
				inventory.remove_item(holding_item)
			
		elif not holding and interaction.can_interact():
			var item = interaction.grab()
			if item != null:
				inventory.add_item(item)
	
