extends Node2D

@export_node_path("RigidBody2D") var parent_path
@onready var parent : RigidBody2D = get_node(parent_path)

@export_node_path("RigidBody2D") var projectile_path
@onready var projectile : RigidBody2D = get_node(projectile_path)

@export var spawn_offset_dist : = 4.0

