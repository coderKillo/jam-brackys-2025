extends Line2D

@export var body: CharacterBody2D
@export var point_spacing: float = 1.0
@export var max_points: int = 10

var distance_sum := 0.0


func _ready():
	assert(body, "body not set")
	add_point(body.global_position)


func _process(_delta):
	distance_sum += points[-1].distance_to(body.global_position)

	if distance_sum >= point_spacing:
		add_point(body.global_position)
		distance_sum = 0.0

	if get_point_count() > max_points:
		remove_point(0)
