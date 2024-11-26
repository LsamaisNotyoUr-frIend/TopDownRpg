class_name HurtBox
extends Area2D

var invincibilityTime = 1
var isInvincible = false
var isRunning = false


func _init() -> void:
	collision_layer = 0
	collision_mask = 3
func _ready() -> void:
	isRunning = true
	connect("area_entered", Callable(self, "attack_detected"))

	
func attack_detected(area: Area2D):
	if !area is HitBox:
		return
	handleAttacks(area as HitBox)

func handleAttacks(hitbox: HitBox):
	if owner.has_method("takeDamage"):
		owner.takeDamage(hitbox.damage)
		toggleInvincibility()

func toggleInvincibility():
	if isRunning:
		disable()
		await get_tree().create_timer(invincibilityTime).timeout
		enable()

func disable():
	collision_mask = 0

func enable(mask_layer = 3):
	collision_mask = mask_layer
