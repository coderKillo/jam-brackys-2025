class_name PlayerController
extends Node2D

@export var player: Player
@export var player_start_position: Vector2
@export var ball: Ball
@export var ball_start_position: Vector2


func _ready():
	reset_position()


func _process(_delta):
	player.direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if Input.is_action_pressed("shoot"):
		player.charge()

	if Input.is_action_just_released("shoot"):
		player.shoot()

	if Input.is_action_just_pressed("dash"):
		player.dash()


func reset_position():
	player.global_position = player_start_position
	ball.global_position = ball_start_position
	ball.combo = 0


func active_player(active: bool):
	if active:
		reset_position()
		ball.disable(false)
		player.disable(false)
		set_process(true)
	else:
		set_process(false)
		ball.disable(true)
		player.disable(true)
		ball.velocity = Vector2.ZERO
		player.velocity = Vector2.ZERO
		player.direction = Vector2.ZERO
		reset_position()
