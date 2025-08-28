extends Node2D

@export var grid: Grid
@export var selector_overlay: Selector

@onready var trap_db = {Globals.Traps.SAW_BLADE: preload("res://game/entities/traps/saw_blade.tscn")}

var queued_trap: Node2D


func _process(_delta):
	if queued_trap:
		queued_trap.global_position = Grid.cell_pos(get_global_mouse_position())

	if Input.is_action_just_pressed("shoot") and queued_trap:
		place_trap()


func queue_trap(trap: Globals.Traps):
	if not trap in trap_db:
		return
	queued_trap = trap_db[trap].instantiate()
	grid.add_child(queued_trap)
	queued_trap.global_position = Grid.cell_pos(get_global_mouse_position())


func place_trap():
	queued_trap = null


func select_trap():
	selector_overlay.select("place a saw blade", "place a saw blade")
	await selector_overlay.selected
	if selector_overlay.left_selected:
		queue_trap(Globals.Traps.SAW_BLADE)
	else:
		queue_trap(Globals.Traps.SAW_BLADE)
