extends Card
class_name AttackCard

@export var damage:int
@export var hitbox:HitBox

func _init(cost_value: int ) -> void:
	super(cost_value)
	
func _ready() -> void:
	hitbox.damage = damage
	
func attack():
	pass
