class_name HitBox
extends Area2D

@export var damage = 5

func _init() -> void:
	collision_layer = 3
	collision_mask = 0
	
func enable(collisionLayer = 3):
	collision_layer = collisionLayer
	
func disable():
	collision_layer = 0
	
func changeAttackLayer(layer):
	collision_layer = layer
