class_name Player
extends CharacterBody2D

@export var speed = 300.0
@export var shoot_power = 300.0
@export var charge_time = 1.0

@onready var ball_collect: Area2D = $CollectBallArea
@onready var ball_slot: Node2D = $RotationAxis/BallSlot
@onready var rotation_axis: Node2D = $RotationAxis

var ball: Ball
var charge: float = 0.0


func _ready():
	ball_collect.body_entered.connect(_on_ball_entered)


func _process(delta):
	rotation_axis.look_at(get_global_mouse_position())

	_update_ball()

	if Input.is_action_pressed("shoot"):
		_charging(delta)

	if Input.is_action_just_released("shoot"):
		_shoot()


func _physics_process(_delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_ball_entered(body):
	ball = body


func _shoot():
	if not is_instance_valid(ball):
		return
	var direction = global_position.direction_to(get_global_mouse_position())
	ball.velocity = direction * shoot_power * charge
	ball = null
	charge = 0.0


func _charging(delta):
	if not is_instance_valid(ball):
		return
	charge += delta
	if charge >= charge_time:
		_shoot()


func _update_ball():
	if not is_instance_valid(ball):
		return
	ball.global_position = ball_slot.global_position
