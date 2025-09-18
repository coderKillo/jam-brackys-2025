class_name Ball
extends CharacterBody2D

@onready var detector: Area2D = $TrapDetector
@onready var trap_detector_shape: CollisionShape2D = $TrapDetector/CollisionShape2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D

var attached := true
var combo = 0


func _ready():
	detector.area_entered.connect(_on_trap_entered)
	particles.emitting = true
	particles.restart()


func _physics_process(delta):
	if attached:
		velocity = Vector2.ZERO
		return
	velocity = lerp(velocity, Vector2.ZERO, 0.02)
	var collision = move_and_collide(velocity * delta)
	if collision:
		particles.emitting = true
		particles.restart()
		Events.camera_shake.emit(0.4)
		Events.play_sound.emit("hit_wall")
		velocity = velocity.bounce(collision.get_normal())


func disable(value: bool):
	visible = not value
	trap_detector_shape.set_deferred("disabled", value)
	collision_shape.set_deferred("disabled", value)


func _on_trap_entered(_area):
	Events.play_sound.emit("lose")
	Events.ball_died.emit(global_position)
	Events.level_lose.emit()
