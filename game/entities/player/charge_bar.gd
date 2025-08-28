extends ProgressBar

@export var player: Player


func _ready():
	assert(player, "Player not set")


func _process(_delta):
	visible = player.charge_timer > 0.0
	max_value = player.max_charge_time
	value = player.charge_timer
