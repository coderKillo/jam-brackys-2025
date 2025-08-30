extends Node2D

@onready var audio_player = {
	"hit_wall": $HitWall,
	"goal": $Goal,
	"lose": $Lose,
	"points": $Points,
	"select_trap": $SelectTrap,
	"shoot": $Shoot,
}


func _ready():
	Events.play_sound.connect(_on_sound_play)


func _on_sound_play(sound: String):
	if sound in audio_player:
		audio_player.pitch_scale = randf_range(0.9, 1.1)
		audio_player[sound].play()
