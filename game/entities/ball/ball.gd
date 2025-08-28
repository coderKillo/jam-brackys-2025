class_name Ball
extends CharacterBody2D

@onready var detector: Area2D = $TrapDetector

var attached := true
var combo = 0


func _ready():
	detector.area_entered.connect(_on_trap_entered)


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())


func _on_trap_entered(_area):
	Events.level_lose.emit()
