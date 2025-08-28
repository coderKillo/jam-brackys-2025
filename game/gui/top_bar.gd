extends Control

const GAB_SIZE = 16
const END_POSITION = Vector2(132.0, 8.0)

@export var main: Main

@onready var marker: Control = $Marker

var _start_position


func _ready():
	Events.game_state_changed.connect(_on_game_state_changed)

	_start_position = marker.position


func _on_game_state_changed(_state):
	if marker.position.x >= END_POSITION.x:
		return

	var x_pos = _start_position.x + main.total_rounds() * GAB_SIZE

	var tween = get_tree().create_tween()
	tween.tween_property(marker, "position:x", x_pos, 2.0).set_ease(Tween.EASE_IN_OUT)
