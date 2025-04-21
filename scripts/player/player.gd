class_name Player
extends RigidBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var ani_tree: AnimationTree = $AnimationTree
@onready var trail: Trail = $Sprite2D/Trail
@onready var traj_line: Line2D = $Line2D
@onready var kill_timer: Timer = $Timer
#@onready var collision_particle: GPUParticles2D = $Sprite2D/GPUParticles2D
@onready var collision_sound: AudioStreamPlayer2D = $AudioStreamPlayer

@export var stage: Node2D

#trajectory
@export var traj_max_points: int = 40
var time_step : float = 0.1

var playback: AnimationNodeStateMachinePlayback

var max_force: float = 1500
var force_strength: float
var force_direction: Vector2

var mouse_hover: bool = false
var impulse_applied: bool = false

enum State {
	IDLE,
	HOVER,
	AIMING,
	MOVING
}

var current_state: State

var moves_list: Array[TextureRect]
var moves: int = 4

func _ready() -> void:
	ani_tree.active = true
	playback = ani_tree["parameters/playback"]
	current_state = State.IDLE
	var moves_ui: HBoxContainer = $UILayer/HBoxContainer
	for child in moves_ui.get_children():
		moves_list.append(child)
	
	update_ui()

func _physics_process(delta: float) -> void:
	state_check()
	state_physics(delta)
	state_animation()

func scaler_force_charged() -> float:
	var mouse_distance: float = position.distance_to(get_global_mouse_position())
	var force: float = min(max_force, (mouse_distance/500) * max_force)
	return force

func state_check() -> void:
	match current_state:
		State.IDLE:
			if moves <= 0:
				kill_timer.start(0.5)
			impulse_applied = false
			if mouse_hover:
				current_state = State.HOVER
		State.HOVER:
			impulse_applied = false
			if !mouse_hover:
				current_state = State.IDLE
			elif mouse_hover && Input.is_action_just_pressed("left click"):
				current_state = State.AIMING
		State.AIMING:
			impulse_applied = false
			if Input.is_action_just_released("left click") && !mouse_hover:
				current_state = State.MOVING
				remove_moves()
			elif Input.is_action_just_released("left click") && mouse_hover:
				current_state = State.HOVER
		State.MOVING:
			if linear_velocity.length() < 100.0:
				current_state = State.IDLE

func state_animation() -> void:
	match current_state:
		State.IDLE:
			playback.travel("idle")
		State.HOVER:
			playback.travel("hover")
		State.AIMING:
			playback.travel("aiming")
			ani_tree.set("parameters/aiming/blend_position", force_strength / max_force)
		State.MOVING:
			sprite.global_rotation = linear_velocity.angle()
			playback.travel("moving")
			ani_tree.set("parameters/moving/blend_position", linear_velocity.length() / max_force)

func state_physics(delta: float) -> void:
	match current_state:
		State.IDLE:
			traj_line.visible = false
		State.HOVER:
			traj_line.visible = false
		State.AIMING:
			traj_line.visible = true
			force_strength = scaler_force_charged()
			force_direction = -position.direction_to(get_global_mouse_position()).normalized()
			plot_trajectory(force_direction * force_strength * mass)
		State.MOVING:
			traj_line.visible = false
			if !impulse_applied:
				print(force_strength)
				apply_central_impulse(force_direction * force_strength * mass)
				impulse_applied = true

func plot_trajectory( force: Vector2):
	traj_line.clear_points()
	var points = []
	for i in traj_max_points:
		var t = i * time_step
		var pos = position + force * t / mass
		points.append(to_local(pos))

	traj_line.points = points

func reset_moves(count: int) -> void:
	moves = count
	update_ui()

func remove_moves() -> void:
	if moves > 0:
		moves -= 1
		update_ui() 
	print(moves)

func update_ui() -> void:
	for i in range(moves_list.size()):
		moves_list[i].visible = i < moves 

func _on_area_2d_mouse_entered() -> void:
	mouse_hover = true

func _on_area_2d_mouse_exited() -> void:
	mouse_hover = false


func _on_timer_timeout() -> void:
	if moves <= 0:
		get_tree().change_scene_to_file("res://menu/death.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	collision_sound.play()
