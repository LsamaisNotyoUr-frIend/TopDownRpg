extends Weapon
class_name SwordSummon

@onready var hit_box: HitBox = $HitBox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	hit_box.enable()
	
func summon_sword_attack():
	animated_sprite_2d.play("summon_attack")
	animation_player.play("sword_attack")
	
