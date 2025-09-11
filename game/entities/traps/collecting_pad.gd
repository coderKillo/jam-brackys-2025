extends Area2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var particle: GPUParticles2D = $GPUParticles2D


func _ready():
	body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	var ball: Ball = body
	if not is_instance_valid(ball):
		return
	if ball.attached:
		return

	var score = Globals.BASE_CELL_SCORE + Globals.ADDITIONAL_CELL_SCORE * ball.combo
	ScoreNumbers.display(score, global_position)
	Events.score_added.emit(score)
	Events.camera_shake.emit(0.2)
	Events.camera_freez_frame.emit()

	ball.combo += 1

	collision.set_deferred("disabled", true)
	particle.emitting = true
	sprite.hide()


func reset():
	collision.disabled = false
	sprite.show()
