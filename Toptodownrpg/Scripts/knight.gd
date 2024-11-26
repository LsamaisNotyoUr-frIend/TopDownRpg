class_name Player
extends CharacterBody2D

var cardPoints = 10
var speed = 3500.0
var health = 15
var isMoving:bool = false
var direction:String = ""
var cooldown = 0
var isAttacking = false
var dir = "Up"

@export var health_bar: HealthBar

@onready var knight: AnimatedSprite2D = $Knight
@onready var animation_player: AnimationPlayer = $Knight/AnimationPlayer
@onready var hit_box: HitBox = $Knight/HitBox
@onready var hurt_box: HurtBox = $HurtBox


func _ready() -> void:
	hurt_box.enable()
	hit_box.disable()
	health_bar.initHealth(health)
	
func _physics_process(delta: float) -> void:
	if !cooldown <= 0:
		cooldown -= delta
		
	if is_no_action_pressed() and cooldown <= 0:
		knight.play("idle"+ dir)
		
	if !Input.is_action_just_released("attack") and cooldown <= 0:
		animation_player.stop()
		

	if Input.is_action_pressed("left") and !isAttacking:
		velocity = Vector2.LEFT * speed * delta
		isMoving = true
		direction = "left"
		dir = "Sideways"
	elif Input.is_action_pressed("right") and !isAttacking:
		velocity = Vector2.RIGHT * speed * delta
		isMoving = true
		direction = "right"
		dir = "Sideways"
	elif Input.is_action_pressed("up") and !isAttacking:
		velocity = Vector2.UP * speed * delta
		isMoving = true
		direction = "up"
		dir = "Up"
	elif Input.is_action_pressed("down") and !isAttacking:
		velocity = Vector2.DOWN * speed * delta
		isMoving = true
		direction = "down"
		dir = "Down"
	else:
		isMoving = false
		
	if isMoving and !isAttacking:
		if direction == "left":
			knight.play("walkSideways")
			knight.flip_h = false
		if direction == "right":
			knight.flip_h = true
			knight.play("walkSideways")
		if direction == "up":
			knight.flip_h = false
			knight.play("walkUpwards")
		if direction == "down":
			knight.flip_h = false
			knight.play("walkDown")
	else:
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("attack"):
		hit_box.enable()
		isMoving = false
		isAttacking = true
		await attack()
		isAttacking = false
		hit_box.disable()
		
	move_and_slide()
	
func attack():
	if direction == "left":
		cooldown = 0.49
		knight.flip_h = false
		knight.play("attackSideways")
		animation_player.play("attackside")
		await get_tree().create_timer(0.5).timeout
	if direction == "right":
		cooldown = 0.49
		knight.flip_h = true
		knight.play("attackSideways")
		animation_player.play("attackright")
		await get_tree().create_timer(0.5).timeout
	if direction == "up":
		cooldown = 0.49
		knight.flip_h = false
		knight.play("attackUp")
		animation_player.play("attackup")
		await get_tree().create_timer(0.5).timeout
	if direction == "down":
		cooldown = 0.49
		knight.flip_h = false
		knight.play("attackDown")
		animation_player.play("attackdown")
		await get_tree().create_timer(0.5).timeout
	
func is_no_action_pressed() -> bool:
	var actions = InputMap.get_actions()
	for action in actions:
		if Input.is_action_pressed(action):
			return false
	return true
