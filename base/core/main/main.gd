class_name Main
extends Control

@export var level_container: Node
@export var gui: Control
@export var goal: Area2D

@onready var tutorial_manager: TutorialManager = $Managers/TutorialManager
@onready var story_manager: StoryManager = $Managers/StoryManager
@onready var player_controller: PlayerController = $Managers/PlayerController
@onready var trap_manager: TrapManager = $Managers/TrapManager
@onready var powerup_manager: PowerupManager = $Managers/PowerupManager
@onready var punishment_manager: PunishmentManager = $Managers/PunishmentManager

@onready var canves_modulate: CanvasModulate = $CanvasModulate

var score := 0
var round_count := 0
var war_count := 0

var _current_game_state := Globals.GameState.SHOW_STORY


func _ready():
	Engine.time_scale = 1.0
	SceneManager.main = self

	tutorial_manager.set_process(false)
	story_manager.set_process(false)
	player_controller.set_process(false)
	trap_manager.set_process(false)
	powerup_manager.set_process(false)
	punishment_manager.set_process(false)

	Events.score_added.connect(_on_score_added)
	Events.ball_scored.connect(_on_ball_scored)
	story_manager.story_finished.connect(_on_story_finished)
	trap_manager.trap_placed.connect(_on_trap_placed)

	_set_game_state(Globals.GameState.SHOW_STORY)


func total_rounds() -> int:
	if war_count == 0:
		return round_count
	return (war_count * (Globals.ROUNDS_TILL_WAR + 1) - 1) + round_count


func _set_game_state(value: Globals.GameState):
	_current_game_state = value
	Events.game_state_changed.emit(_current_game_state)

	match value:
		Globals.GameState.SHOW_STORY:
			if _first_round():
				story_manager.show_story(Globals.Story.BEGINNING)
			else:
				story_manager.show_story(Globals.Story.NEW_ROUND)

		Globals.GameState.GOLDEN_RUN:
			if _first_round():
				tutorial_manager.show_tutorial(0)
			if _second_round():
				tutorial_manager.show_tutorial(2)
			trap_manager.reset_pads()
			player_controller.active_player(true)

		Globals.GameState.WAR_RUN:
			canves_modulate.show()
			trap_manager.reset_pads()
			if war_count > Globals.WARS_TILL_FINAL_WAR:
				punishment_manager.start_final_punishment()
			else:
				punishment_manager.start_random_punishment()
			await story_manager.show_story(Globals.Story.WAR)
			player_controller.active_player(true)

		Globals.GameState.SELECT_TRAP:
			if _first_round():
				tutorial_manager.show_tutorial(1)
			trap_manager.set_process(true)
			trap_manager.select_trap(total_rounds())

		Globals.GameState.SELECT_POWER_UP:
			await story_manager.show_story(Globals.Story.PEACE)
			trap_manager.set_process(true)
			trap_manager.select_trap(total_rounds())

		_:
			pass


func _on_story_finished():
	if _current_game_state != Globals.GameState.SHOW_STORY:
		return
	_set_game_state(Globals.GameState.GOLDEN_RUN)


func _on_ball_scored():
	Events.play_sound.emit("goal")
	tutorial_manager.hide_tutorial(1.0)
	canves_modulate.hide()
	player_controller.active_player(false)

	await get_tree().create_timer(Globals.DELAY_AFTER_SCORE).timeout

	if _first_round():
		await story_manager.show_story(Globals.Story.FIRST_GOAL)

	if _current_game_state == Globals.GameState.WAR_RUN:
		if war_count > Globals.WARS_TILL_FINAL_WAR:
			Events.level_won.emit()

		punishment_manager.end_current_punishment()
		_set_game_state(Globals.GameState.SELECT_POWER_UP)
	else:
		_set_game_state(Globals.GameState.SELECT_TRAP)


func _on_trap_placed():
	Events.play_sound.emit("select_trap")
	tutorial_manager.hide_tutorial(0.1)
	trap_manager.set_process(false)
	_next_round()


func _on_score_added(value):
	Events.play_sound.emit("points")
	score += value


func _next_round():
	round_count += 1
	if round_count > Globals.ROUNDS_TILL_WAR or (round_count == 3 and war_count == 0):
		round_count = 0
		war_count += 1
		_set_game_state(Globals.GameState.WAR_RUN)
	else:
		_set_game_state(Globals.GameState.SHOW_STORY)


func _first_round() -> bool:
	return round_count <= 0 and war_count <= 0


func _second_round() -> bool:
	return round_count == 1 and war_count <= 0
