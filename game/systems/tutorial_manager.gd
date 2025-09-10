class_name TutorialManager
extends Node2D

@export var texture: Sprite2D
@export var texture_resource: Array[Texture] = []


func _ready():
	texture.hide()


func show_tutorial(index):
	if index >= texture_resource.size():
		return
	texture.texture = texture_resource[index]
	texture.modulate.a = 0.5
	texture.show()


func hide_tutorial(fade: float):
	var tween = get_tree().create_tween()
	tween.tween_property(texture, "modulate:a", 0.0, fade)
	tween.tween_callback(texture.hide)
