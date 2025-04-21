extends Node2D
@onready var ani_player: AnimationPlayer = $AnimationPlayer
@onready var spawner: Spawner = $spawner

var init_spawned: bool = false

func _ready() -> void:
	ani_player.play("fade_in_trans")

func _exit_tree() -> void:
	print("Node exited tree:", name)

func _physics_process(delta: float) -> void:
	if get_tree().get_nodes_in_group("enemy").is_empty() && init_spawned:
		spawner.refresh_spawn_points()
		spawner.spawn(3)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in_trans":
		print("done")
		spawner.spawn(3)
		init_spawned = true
