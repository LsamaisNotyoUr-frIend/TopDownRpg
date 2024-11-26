extends AttackCard

var _cost_value = 1

@onready var summon_sword: SwordSummon = $summonSword
@onready var gpuparticle: GPUParticles2D = $gpuparticle
@onready var animation_tree: AnimationTree = $AnimationTree


func _init() -> void:
	super(1)
	
func _ready() -> void:
	visible = true
	gpuparticle.emitting = false

	
func _process(delta: float) -> void:
	if is_mouse_inside:
		animation_tree["parameters/conditions/isMouseIn"] = true
		animation_tree["parameters/conditions/isMouseLeft"] = false
	elif is_mouse_inside == false:
		animation_tree["parameters/conditions/isMouseIn"] = false
		animation_tree["parameters/conditions/isMouseLeft"] = true
		animation_player.play("fall")
	if is_mouse_inside and allow and !busy:
		if Input.is_action_just_pressed("attack"):
			allow = false
			animation_player.play("dissapear")
			await get_tree().create_timer(0.5).timeout
			summon_sword.visible = true
			summon_sword.summon_sword_attack()
			await get_tree().create_timer(1.8).timeout
			queue_free()

func _on_mouse_entered() -> void:
	if !allow:
		return
	is_mouse_inside = true


func _on_mouse_exited() -> void:
	if !allow:
		return
	is_mouse_inside = false
	
