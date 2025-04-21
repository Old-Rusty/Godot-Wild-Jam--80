class_name Spawner
extends Node2D
@export var main: Node2D


var init_spawn_points: Array
var empty_spawn_points: Array
var spawn_no: int

var enemy_array: Array[PackedScene] = [
	preload("res://enemy/triangle.tscn"),
	preload("res://enemy/square.tscn"),
	preload("res://enemy/pentagon.tscn")
]

func _ready() -> void:
	init_spawn_points = get_children()
	empty_spawn_points = init_spawn_points.duplicate()

func refresh_spawn_points() -> void:
	empty_spawn_points = init_spawn_points.duplicate()

func spawn(type: int, count: int) -> void:
	if empty_spawn_points.is_empty():
		return
	for i in count:
		var spawn:Node2D = enemy_array[type].instantiate()
		add_child(spawn)
		var rand_spawn: int = randi_range(0, empty_spawn_points.size()-1)
		spawn.position = empty_spawn_points[rand_spawn].position
		spawn.rotation = randf_range(0, 2 * PI)
		empty_spawn_points.remove_at(rand_spawn)
