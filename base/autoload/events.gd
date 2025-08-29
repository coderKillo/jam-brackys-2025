extends Node

signal level_won

signal level_lose

signal score_added(value: int)

signal game_state_changed(state: Globals.GameState)

signal ball_scored

signal ball_died(position: Vector2)
