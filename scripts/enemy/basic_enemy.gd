extends RigidBody2D
@onready var ani: AnimationTree = $AnimationTree
@export var instancer: Node2D
var playback: AnimationNodeStateMachinePlayback

func _ready() -> void:
	ani.active = true
	playback = ani["parameters/playback"]



func _physics_process(delta: float) -> void:
	if instancer.pointless:
		playback.travel("end")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "end":
		call_deferred("queue_free")
