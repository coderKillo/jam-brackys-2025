class_name Player
extends CharacterBody2D

@export var speed = 300.0
@export var shoot_power = 300.0
@export var max_charge_time = 1.0

@onready var ball_collect: Area2D = $CollectBallArea
@onready var ball_slot: Node2D = $RotationAxis/BallSlot
@onready var rotation_axis: Node2D = $RotationAxis
@onready var detector: Area2D = $TrapDetector
@onready var trap_detector_shape: CollisionShape2D = $TrapDetector/CollisionShape2D

var ball: Ball
var charge_timer: float = 0.0

var direction: Vector2 = Vector2.ZERO
var _is_charging: bool = false


func _ready():
	ball_collect.body_entered.connect(_on_ball_entered)
	detector.area_entered.connect(_on_trap_entered)


func _process(delta):
	rotation_axis.look_at(get_global_mouse_position())

	_update_ball()
	_update_charge(delta)


func _physics_process(_delta):
	if direction:
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()


func _on_ball_entered(body):
	ball = body
	ball.attached = true
	ball.combo = 0
	ball_collect.get_node("CollisionShape2D").set_deferred("disabled", true)


func shoot():
	if not is_instance_valid(ball):
		return
	var view_direction = global_position.direction_to(get_global_mouse_position())
	ball.velocity = view_direction * shoot_power * charge_timer

	ball.attached = false
	ball = null
	charge_timer = 0.0
	_is_charging = false

	await get_tree().create_timer(0.1).timeout
	ball_collect.get_node("CollisionShape2D").set_deferred("disabled", false)


func charge():
	if not is_instance_valid(ball):
		return
	_is_charging = true


func disable(value: bool):
	visible = not value
	trap_detector_shape.set_deferred("disabled", value)


func _update_charge(delta):
	if not _is_charging:
		return
	charge_timer += delta
	if charge_timer >= max_charge_time:
		shoot()


func _update_ball():
	if not is_instance_valid(ball):
		return
	ball.global_position = ball_slot.global_position


func _on_trap_entered(_area):
	Events.ball_died.emit(global_position)
	Events.level_lose.emit()
