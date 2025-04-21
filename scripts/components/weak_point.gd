extends Node2D
@onready var ani: AnimationTree = %AnimationTree
@onready var sprite: Sprite2D = $Sprite2D
var playback: AnimationNodeStateMachinePlayback
var parent_enemy: RigidBody2D
@onready var collision_particle: GPUParticles2D = $GPUParticles2D

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
		play_particles_and_free()

func _on_gpu_particles_2d_finished() -> void:
	call_deferred("queue_free")

func play_particles_and_free():
	var particle_clone = collision_particle.duplicate()
	get_tree().current_scene.add_child(particle_clone)
	particle_clone.global_position = collision_particle.global_position
	particle_clone.emitting = true
	await get_tree().create_timer(particle_clone.lifetime).timeout
	particle_clone.queue_free()

	queue_free()
