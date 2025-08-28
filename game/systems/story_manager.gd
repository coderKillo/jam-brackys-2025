extends Node2D

const STORY_TEXT = {
	Globals.Story.BEGINNING:
	[
		"In the first days, a mortal found a ball of gold in a strange room.",
		"For reasons now lost to history, they cast it through two stone pillars."
	],
	Globals.Story.FIRST_GOAL:
	[
		"A joy beyond measure filled their spirit. They tried it again but never felt the same thrill.",
		"To restore the challenge, they set an obstacle, and thus the Golden Run was born."
	],
	Globals.Story.NEW_ROUND:
	["Through the ages, each generation faced the run and added a new obstacle."],
	Globals.Story.WAR:
	[
		"In times of war, the obstacles grew harsh, meant to prepare the youth for the brutal realities of the front."
	],
	Globals.Story.PEACE:
	[
		"Peace returned, the knowledge and technologies invented during the war enhanced both humanity and the Golden Run"
	],
}

@export var story_overlay: Control


func _ready():
	story_overlay.hide()


func show_story(story: Globals.Story):
	story_overlay.modulate.a = 1.0
	story_overlay.get_node("StoryText").text = STORY_TEXT[story]
	story_overlay.show()


func hide_story(fade: float):
	var tween = get_tree().create_tween()
	tween.tween_property(story_overlay, "modulate:a", 0.0, fade)
