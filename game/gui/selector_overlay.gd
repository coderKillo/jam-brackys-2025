class_name Selector
extends Control

signal selected

@export var alpha_hover = 0.1
@export var alpha_normal = 0.0
@export var scale_hover = Vector2.ONE * 1.3
@export var scale_normal = Vector2.ONE

@onready var left_text: RichTextLabel = %LeftText
@onready var left_texture: TextureRect = %LeftTexture
@onready var left_content: ColorRect = %ContentLeft
@onready var left_container: MarginContainer = %LeftContainer
@onready var right_text: RichTextLabel = %RightText
@onready var right_texture: TextureRect = %RightTexture
@onready var right_content: ColorRect = %ContentRight
@onready var right_container: MarginContainer = %RightContainer

var left_selected := false


func _ready():
	set_process(false)
	hide()


func _process(_delta):
	if Input.is_action_just_released("shoot"):
		hide()
		set_process(false)
		left_selected = _mouse_is_left()
		selected.emit()

	if _mouse_is_left():
		left_content.color.a = alpha_hover
		left_container.scale = scale_hover
		right_content.color.a = alpha_normal
		right_container.scale = scale_normal
	else:  # right
		right_content.color.a = alpha_hover
		right_container.scale = scale_hover
		left_content.color.a = alpha_normal
		left_container.scale = scale_normal


func select(left: String, right: String, texture_left: Texture, texture_right: Texture):
	left_text.text = left
	right_text.text = right
	left_texture.texture = texture_left
	right_texture.texture = texture_right
	show()
	set_process(true)


func _mouse_is_left() -> bool:
	return get_global_mouse_position().x <= 320
