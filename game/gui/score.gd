extends Control

@export var main: Main

@onready var label: Label = $Label

var _label_score: int = 0


func _ready():
	Events.level_lose.connect(_on_level_lose)


func _process(_delta):
	visible = main.score > 0
	if main.score > _label_score:
		_label_score += 5
	label.text = str(_label_score)


func _on_level_lose():
	hide()
