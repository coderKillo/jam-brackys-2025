class_name PunishmentManager
extends Node2D

const punishment_list = [
	Globals.Punishments.SMALL_ROOM_TOP,
	Globals.Punishments.SMALL_ROOM_BOTTOM,
	Globals.Punishments.TWO_SIDED_SPIKES,
	Globals.Punishments.SPIKE_WALLS,
	Globals.Punishments.SPIKE_SQUISH,
	Globals.Punishments.BIG_SAW_BLADES,
	Globals.Punishments.LASER_ARRAY,
	Globals.Punishments.CANNON_ARRAY,
	Globals.Punishments.CANNON_FIRE_FOUR_DIRECTION
]

@export var small_room_top: Node2D
@export var small_room_bottom: Node2D

var _current_punishment: Globals.Punishments = Globals.Punishments.NONE


func _ready():
	start_punishment(Globals.Punishments.BIG_SAW_BLADES)


func start_random_punishment():
	start_punishment(punishment_list.pick_random())


func start_punishment(punishment: Globals.Punishments):
	_current_punishment = punishment

	match _current_punishment:
		Globals.Punishments.SMALL_ROOM_TOP:
			small_room_top.show()
			small_room_top.get_node("StaticBody2D/CollisionShape2D").disabled = false

		Globals.Punishments.SMALL_ROOM_BOTTOM:
			small_room_bottom.show()
			small_room_bottom.get_node("StaticBody2D/CollisionShape2D").disabled = false

		Globals.Punishments.TWO_SIDED_SPIKES:
			for node in get_tree().get_nodes_in_group("spikes_punishment"):
				if node is Sprite2D:
					node.show()
				if node is CollisionShape2D:
					node.disabled = false

		Globals.Punishments.SPIKE_WALLS:
			pass

		Globals.Punishments.SPIKE_SQUISH:
			pass

		Globals.Punishments.BIG_SAW_BLADES:
			for node in get_tree().get_nodes_in_group("saw_punishment"):
				node.scale = Vector2.ONE * 2.0

		Globals.Punishments.LASER_ARRAY:
			pass

		Globals.Punishments.CANNON_ARRAY:
			pass

		Globals.Punishments.CANNON_FIRE_FOUR_DIRECTION:
			pass


func end_current_punishment():
	match _current_punishment:
		Globals.Punishments.SMALL_ROOM_TOP:
			small_room_top.hide()
			small_room_top.get_node("StaticBody2D/CollisionShape2D").disabled = true

		Globals.Punishments.SMALL_ROOM_BOTTOM:
			small_room_bottom.hide()
			small_room_bottom.get_node("StaticBody2D/CollisionShape2D").disabled = true

		Globals.Punishments.TWO_SIDED_SPIKES:
			for node in get_tree().get_nodes_in_group("spikes_punishment"):
				if node is Sprite2D:
					node.hide()
				if node is CollisionShape2D:
					node.disabled = true

		Globals.Punishments.SPIKE_WALLS:
			pass
		Globals.Punishments.SPIKE_SQUISH:
			pass
		Globals.Punishments.BIG_SAW_BLADES:
			for node in get_tree().get_nodes_in_group("saw_punishment"):
				node.scale = Vector2.ONE

		Globals.Punishments.LASER_ARRAY:
			pass
		Globals.Punishments.CANNON_ARRAY:
			pass
		Globals.Punishments.CANNON_FIRE_FOUR_DIRECTION:
			pass
