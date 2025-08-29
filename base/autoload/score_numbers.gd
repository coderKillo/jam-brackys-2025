extends Node

@onready var score_number_scene: PackedScene = preload("res://game/systems/score/score_number.tscn")


func display(value: int, pos: Vector2) -> void:
	if not is_instance_valid(SceneManager.main):
		return

	var number := score_number_scene.instantiate() as Node2D
	number.global_position = pos
	number.z_index = 5
	number.get_node("Label").text = str(value)

	SceneManager.main.level_container.call_deferred("add_child", number)

	var tween = get_tree().create_tween()

	tween.tween_property(number, "position:y", number.position.y - 16.0, 1.0).set_ease(
		Tween.EASE_OUT
	)
	tween.tween_property(number, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_OUT)

	await tween.finished

	if is_instance_valid(number):
		number.queue_free()
