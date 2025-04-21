class_name Trail
extends Line2D
var drawing: bool = false
@export var max_points: int

func _physics_process(delta: float) -> void:
	draw_trail()


func draw_trail() -> void:
	add_point(get_parent().global_position)
	if points.size() > max_points:
		remove_point(0)
