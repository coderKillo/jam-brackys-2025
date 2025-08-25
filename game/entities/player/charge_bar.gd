extends ProgressBar

@export var player: Player


func _ready():
	assert(player, "Player not set")


func _process(_delta):
	visible = player.charge > 0.0
	max_value = player.charge_time
	value = player.charge
