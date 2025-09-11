extends Node

signal level_won

signal level_lose

signal score_added(value: int)

signal game_state_changed(state: Globals.GameState)

signal ball_scored

signal ball_died(position: Vector2)

signal play_sound(sound: String)

signal camera_shake(intensity: float)

signal camera_freez_frame
