class_name Grid
extends Node2D


func _ready():
	pass


func _process(_delta):
	pass


static func cell_pos(pos: Vector2) -> Vector2:
	return (
		floor(pos / Globals.CELL_SIZE) * Globals.CELL_SIZE + (Vector2.ONE * Globals.CELL_SIZE * 0.5)
	)
