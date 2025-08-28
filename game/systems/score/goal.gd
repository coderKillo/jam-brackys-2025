extends Area2D

@onready var partical: GPUParticles2D = $GPUParticles2D


func _ready():
	body_entered.connect(_on_ball_entered)


func _on_ball_entered(_body):
	partical.emitting = true
	Events.ball_scored.emit()
