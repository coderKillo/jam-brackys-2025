class_name Grid
extends Node2D


func _ready():
	pass
	Events.ball_scored.connect(_on_ball_scored)


func _process(_delta):
	pass

func _on_ball_scored():
	$AnimationPlayer.play("wave")

static func cell_pos(pos: Vector2) -> Vector2:
	return (
		floor(pos / Globals.CELL_SIZE) * Globals.CELL_SIZE + (Vector2.ONE * Globals.CELL_SIZE * 0.5)
	)
