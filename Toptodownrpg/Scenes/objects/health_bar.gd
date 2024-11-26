class_name HealthBar
extends ProgressBar

var max_health
var current_health = 0 : set = setHealth
@onready var progress_bar: ProgressBar = $ProgressBar


func setHealth(_health):
	var new_health = current_health
	current_health = min(max_value, _health)
	
	if current_health < new_health:
		await get_tree().create_timer(0.8).timeout
		progress_bar.value = current_health
	else:
		progress_bar.value = current_health
	
func _process(delta: float) -> void:
	value = current_health
	await get_tree().create_timer(0.8).timeout
	progress_bar.value = current_health
	
func initHealth(_health):
	max_value = _health
	current_health = _health
	value = current_health
	progress_bar.max_value = max_value
	progress_bar.value = current_health
	
	
