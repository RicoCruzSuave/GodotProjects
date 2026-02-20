@tool
extends CharacterBody2D

@onready var left_hand: Node2D = $LeftHand
@onready var right_hand: Node2D = $RightHand
@onready var inventory: Node2D = $Inventory
@onready var sword: RigidBody2D = $Inventory/Sword
@onready var backpack: Node2D = $Backpack

#func pin_item_to(item : Object, location : Node2D):
	#var pin
