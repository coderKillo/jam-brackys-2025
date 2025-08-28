class_name Main
extends Control

@export var level_container: Node
@export var gui: Control

var round_count := 0
var war_count := 0


func _ready():
	SceneManager.main = self


func total_rounds() -> int:
	return war_count * (Globals.ROUNDS_TILL_WAR + 1) + round_count
