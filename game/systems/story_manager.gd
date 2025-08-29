class_name StoryManager
extends Node2D

signal story_finished

const STORY_TEXT = {
	Globals.Story.BEGINNING:
	[
		"In the first days,\n a mortal found a ball of gold in a strange room.",
		"For reasons now lost to history,\n they cast it through two stone pillars."
	],
	Globals.Story.FIRST_GOAL:
	[
		"A joy beyond measure filled their spirit.\nThey tried it again but never felt the same thrill.",
		"To restore the challenge, \nthey set an obstacle, \nand thus the Golden Run was born."
	],
	Globals.Story.NEW_ROUND:
	["Through the ages, \neach generation faced the run and added a new obstacle."],
	Globals.Story.WAR:
	[
		"In times of war, \nthe obstacles grew harsh, \nmeant to prepare the youth for the brutal realities of the front."
	],
	Globals.Story.PEACE:
	[
		"Peace returned, \nthe knowledge and technologies invented during the war \nenhanced both humanity and the Golden Run"
	],
}

@export var story_overlay: Control

var story_text: RichTextLabel
var tween: Tween


func _ready():
	story_overlay.hide()

	story_text = story_overlay.get_node("StoryText")
	story_text.modulate.a = 0.0


func _process(_delta):
	if Input.is_action_just_pressed("skip") and tween:
		tween.finished.emit()


func show_story(story: Globals.Story):
	story_overlay.show()
	set_process(true)

	for text in STORY_TEXT[story]:
		story_text.text = text
		tween = get_tree().create_tween()
		tween.tween_property(story_text, "modulate:a", 1.0, Globals.STORY_FADE_TIME).from(0.0)
		tween.tween_property(story_text, "modulate:a", 0.0, Globals.STORY_FADE_TIME).set_delay(
			Globals.STORY_SHOW_TIME
		)
		await tween.finished

	set_process(false)
	story_overlay.hide()
	story_finished.emit()
