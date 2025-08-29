extends Control

@export var main: Main

@onready var label: Label = $Label

var _label_score: int = 0


func _process(_delta):
	visible = main.score > 0
	if main.score > _label_score:
		_label_score += 5
	label.text = str(_label_score)
