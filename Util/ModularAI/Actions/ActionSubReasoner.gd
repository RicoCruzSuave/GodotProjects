@tool
extends AIAction

func update() -> void:
	$Reasoner.think()

