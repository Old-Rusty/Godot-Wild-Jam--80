extends Node2D
var weak_point_res: PackedScene = preload("res://component/WeakPoint.tscn")
var weak_point_markers: Array
var pointless: bool = false

func _ready() -> void:
	weak_point_markers = get_children()
	for point in weak_point_markers:
		var weak_point = weak_point_res.instantiate()
		add_child(weak_point)
		weak_point.position = point.position
	
func _physics_process(_delta: float) -> void:
	if get_child_count() <= weak_point_markers.size():
		pointless = true
	else:
		pointless = false
