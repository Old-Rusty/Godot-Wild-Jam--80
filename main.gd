extends Node2D
@onready var ani_player: AnimationPlayer = $AnimationPlayer
@onready var spawner: Spawner = $spawner
@export var player: Player

enum Level {
	ONE,
	TWO,
	THREE,
	FOUR,
	FIVE
}
var current_level: Level

var init_spawned: bool = false

func _ready() -> void:
	ani_player.play("fade_in_trans")
	current_level = Level.ONE

func _exit_tree() -> void:
	print("Node exited tree:", name)

func _physics_process(delta: float) -> void:
	if get_tree().get_nodes_in_group("enemy").is_empty() && init_spawned:
		player.global_position = Vector2.ZERO
		player.linear_velocity = Vector2.ZERO
		player.playback.travel("idle")
		spawner.refresh_spawn_points()
		match current_level:
			Level.ONE:
				player.reset_moves(6)
				spawner.spawn(0,3)
				spawner.spawn(1,1)
				current_level = Level.TWO
			Level.TWO:
				player.reset_moves(9)
				spawner.spawn(0,3)
				spawner.spawn(1,2)
				spawner.spawn(2,1)
				current_level = Level.THREE
			Level.THREE:
				player.reset_moves(12)
				spawner.spawn(0,3)
				spawner.spawn(1,2)
				spawner.spawn(2,2)
				current_level = Level.FOUR
			Level.FOUR:
				player.reset_moves(15)
				spawner.spawn(0,3)
				spawner.spawn(1,3)
				spawner.spawn(2,3)
				current_level = Level.FIVE
			Level.FIVE:
				pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in_trans":
		spawner.spawn(0,3)
		init_spawned = true
