class_name Rat
extends CharacterBody2D


var speed = 50.0
var current_health = 10
var player: Player
var timer = 0.3
var is_player_close: bool
var initial_position
var initial_rotation
var is_dead = false
var direction
var distance_to_player
var dir = "down"

@export var path_to_player := NodePath()

@onready var enemy_health_bar: HealthBar = $EnemyHealthBar
@onready var hit_box: HitBox = $rat/HitBox
@onready var hurt_box: HurtBox = $rat/HurtBox
@onready var rat: AnimatedSprite2D = $rat
@onready var agent: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	hurt_box.enable()
	hit_box.disable()
	enemy_health_bar.initHealth(current_health)
	player = get_node(path_to_player)
	initial_position = global_position
	initial_rotation = rotation
	
func _process(delta: float) -> void:
	if current_health <= 0:
		is_dead = true
		rat.play("death"+dir)
		await get_tree().create_timer(1.2).timeout
		queue_free()
		
	if !timer <= 0:
		timer -= delta
	elif timer <= 0  and is_player_close:
		agent.target_position = player.global_position
		timer = 0.6
		
	distance_to_player = global_position.distance_to(player.global_position)
	direction = (player.global_position - global_position).normalized()
		
	if is_player_close:
		moveToPlayer(delta)
	else:
		resetPosition(delta)
	move_and_slide()
	
func resetPosition(_delta):
	if global_position != initial_position:
		var current_position = global_position
		var next_position = initial_position
		var desired_velocity = current_position.direction_to(next_position) * speed
		var steering = (desired_velocity - velocity) * _delta * 4
		velocity += steering
		set_animation()
	elif global_position.distance_to(initial_position) < 0.5:
		dir = "down"
		rat.play("special"+ dir)
	
func takeDamage(_damage):
	current_health -= _damage
	enemy_health_bar.current_health = current_health
	rat.play("special"+ dir)

func moveToPlayer(delta):
	if agent.is_navigation_finished():
		return 
	var current_position = global_position
	var next_position = agent.get_next_path_position()
	
	var desired_velocity = current_position.direction_to(next_position) * speed
	var steering = (desired_velocity - velocity) * delta * 4
	velocity += steering
	set_animation()
	
func set_animation() -> void:
	var angle = Vector2(distance_to_player, distance_to_player).angle()
	if abs(direction.x) > abs(direction.y):
		if direction.x < 0: 
			dir = "side"
			rat.play("runside")
			rat.flip_h = false
		elif direction.x > 0:  
			dir = "side"
			rat.play("runside")
			rat.flip_h = true
		else: 
			rat.play("special"+ dir)
	else:
		if direction.y < 0: 
			dir = "up"
			rat.play("runup")
			rat.flip_h = false
		elif direction.y > 0:  
			dir = "down"
			rat.flip_h = false
			rat.play("rundown")
		else: 
			rat.play("special"+ dir)
			
	if abs(direction.x) > 0.5 and abs(direction.y) > 0.5:
		rat.rotation_degrees = angle
	else:
		rat.rotation_degrees = 0
	
func findPlayer(_bool = true):
	is_player_close = _bool
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_dead:
		findPlayer()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if !is_dead:
		findPlayer(false)
