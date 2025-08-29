extends Camera2D

@onready var crack_overlay: Control = $CanvasLayer/ColorRect
@onready var crack_texture: Control = $CanvasLayer/TextureRect


func _ready():
	Events.ball_died.connect(_on_ball_died)


func _on_ball_died(pos: Vector2):
	crack_overlay.show()
	crack_texture.show()
	crack_texture.position = pos
