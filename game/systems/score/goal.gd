extends Area2D

@onready var partical: GPUParticles2D = $GPUParticles2D


func _ready():
	body_entered.connect(_on_ball_entered)


func _on_ball_entered(body):
	var ball: Ball = body
	if not is_instance_valid(ball):
		return
	if ball.attached:
		return

	var score = Globals.BASE_GOAL_SCORE + Globals.ADDITIONAL_GOAL_SCORE * ball.combo
	ScoreNumbers.display(score, global_position)
	Events.score_added.emit(score)

	partical.emitting = true
	Events.ball_scored.emit()
