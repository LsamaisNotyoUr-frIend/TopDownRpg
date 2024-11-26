extends Area2D

class_name Card
var cost: int
var allowed_class: String = "Player" 
var initial_position 
var allow = true
var busy = false

var is_mouse_inside: bool = false
@export var animation_player: AnimationPlayer
@export var player :Player

func _init(cost_value: int,_anim_player: AnimationPlayer = animation_player, allowed_class_type: String = "Any"):
	cost = cost_value
	allowed_class = allowed_class_type
	animation_player = _anim_player
	
func _ready() -> void:
	initial_position = global_position

# Activate card skill
func activate_card():
	if allow:
		if player.cardPoints >= cost:
			player.cardPoints -= cost
			await execute_effect()
			disappear()
		else:
			print("Not enough points or incorrect class.")

# Disappear animation
func disappear():
	pass

func execute_effect():
	pass
	
func position_at_center():
	if !allow:
		return
	var size = get_window().size
	position = size

func reset_position():
	if !allow:
		return
	position = initial_position
