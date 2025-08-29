class_name TrapManager
extends Node2D

signal trap_placed

@export var grid: Grid
@export var selector_overlay: Selector

@onready var trap_db = {
	Globals.Traps.SAW_BLADE:
	{
		scene = preload("res://game/entities/traps/saw_blade.tscn"),
		text = "place a saw blade",
		directions = [{text = "", value = 0.0}]
	},
	Globals.Traps.MOVING_SAW_BLADE:
	{
		scene = preload("res://game/entities/traps/saw_blade_moving.tscn"),
		text = "place a moving saw blade",
		directions =
		[
			{text = "vertical", value = 0.0},
			{text = "horizontal", value = 90.0},
		]
	},
	Globals.Traps.ROTATING_SAW_BLADE:
	{
		scene = preload("res://game/entities/traps/saw_blade_rotating.tscn"),
		text = "place a rotating saw blade",
		directions =
		[
			{text = "", value = 0.0},
		]
	},
	Globals.Traps.SPIKES:
	{
		scene = preload("res://game/entities/traps/spikes.tscn"),
		text = "place a spike",
		directions =
		[
			{text = "facing up", value = 0.0},
			{text = "facing right", value = 90.0},
			{text = "facing down", value = 180.0},
			{text = "facing left", value = 270.0},
		]
	},
	Globals.Traps.HAMMER:
	{
		scene = preload("res://game/entities/traps/hammer.tscn"),
		text = "place a swinging hammer",
		directions =
		[
			{text = "vertical", value = 0.0},
			{text = "horizontal", value = 90.0},
		]
	},
	Globals.Traps.LASER:
	{
		scene = preload("res://game/entities/traps/laser.tscn"),
		text = "place a laser gun",
		directions =
		[
			{text = "facing up", value = 0.0},
			{text = "facing right", value = 90.0},
			{text = "facing down", value = 180.0},
			{text = "facing left", value = 270.0},
		]
	},
	Globals.Traps.CANNON:
	{
		scene = preload("res://game/entities/traps/cannon.tscn"),
		text = "place a cannon",
		directions =
		[
			{text = "facing up", value = 0.0},
			{text = "facing right", value = 90.0},
			{text = "facing down", value = 180.0},
			{text = "facing left", value = 270.0},
		]
	},
}

var trap_list = [
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SAW_BLADE,
	Globals.Traps.SPIKES,
	Globals.Traps.SPIKES,
	Globals.Traps.SPIKES,
	Globals.Traps.SPIKES,
	Globals.Traps.SPIKES,
	Globals.Traps.SPIKES,
	Globals.Traps.SPIKES,
	Globals.Traps.SPIKES,
	Globals.Traps.MOVING_SAW_BLADE,
	Globals.Traps.MOVING_SAW_BLADE,
	Globals.Traps.MOVING_SAW_BLADE,
	Globals.Traps.MOVING_SAW_BLADE,
	Globals.Traps.MOVING_SAW_BLADE,
	Globals.Traps.HAMMER,
	Globals.Traps.HAMMER,
	Globals.Traps.HAMMER,
	Globals.Traps.CANNON,
	Globals.Traps.CANNON,
	Globals.Traps.CANNON,
	Globals.Traps.ROTATING_SAW_BLADE,
	Globals.Traps.LASER,
]

var queued_trap: Node2D
var occupied_cells: Array[Vector2] = []


func _process(_delta):
	if queued_trap:
		queued_trap.global_position = Grid.cell_pos(get_global_mouse_position())
		queued_trap.modulate = Color.WHITE if not _cell_occupied() else Color.RED

	if Input.is_action_just_pressed("shoot") and queued_trap and not _cell_occupied():
		place_trap()


func queue_trap(trap: Globals.Traps, trap_rotation: float):
	if not trap in trap_db:
		return
	queued_trap = trap_db[trap].scene.instantiate()
	grid.add_child(queued_trap)
	queued_trap.global_position = Grid.cell_pos(get_global_mouse_position())
	queued_trap.rotation_degrees = trap_rotation


func place_trap():
	var base_position = Grid.cell_pos(queued_trap.global_position)
	for cell in queued_trap.occupied_cells:
		var rad_angle = deg_to_rad(queued_trap.rotation_degrees)
		occupied_cells.append(base_position + cell.rotated(rad_angle).round())
	queued_trap = null
	trap_placed.emit()


func select_trap(total_round: int):
	var option1 = trap_list.pick_random()
	var option2 = trap_list.pick_random()
	if total_round <= 0:
		option1 = Globals.Traps.SAW_BLADE
		option2 = Globals.Traps.MOVING_SAW_BLADE
	var option1_direction = trap_db[option1].directions.pick_random()
	var option2_direction = trap_db[option2].directions.pick_random()

	selector_overlay.select(
		_get_trap_text(option1, option1_direction.text),
		_get_trap_text(option2, option2_direction.text)
	)
	await selector_overlay.selected

	if selector_overlay.left_selected:
		queue_trap(option1, option1_direction.value)
	else:
		queue_trap(option2, option2_direction.value)


func reset_pads():
	for pad in get_tree().get_nodes_in_group("pads"):
		pad.reset()


func _get_trap_text(trap: Globals.Traps, direction: String):
	var text = trap_db[trap].text
	if direction:
		text += "\n(" + direction + ")"
	return text


func _cell_occupied() -> bool:
	var mouse_position := get_global_mouse_position()
	if (
		mouse_position.x < -256
		or mouse_position.x > 256
		or mouse_position.y > 128
		or mouse_position.y < -128
	):
		return true

	return Grid.cell_pos(mouse_position) in occupied_cells
