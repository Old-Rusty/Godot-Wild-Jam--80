extends Node2D
@onready var ani: AnimationTree = %AnimationTree
var playback: AnimationNodeStateMachinePlayback
var parent_enemy: RigidBody2D

func _ready() -> void:
	global_rotation = randf_range(0, 2*PI)
	ani.active = true
	playback = ani["parameters/playback"]
	parent_enemy = get_parent().get_parent()





func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "end":
		call_deferred("queue_free")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != parent_enemy:
		playback.travel("end")
