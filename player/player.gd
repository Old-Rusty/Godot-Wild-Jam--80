extends RigidBody2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var ani_tree: AnimationTree = $AnimationTree

var playback: AnimationNodeStateMachinePlayback

var max_force: float = 5000
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

func _ready() -> void:
	ani_tree.active = true
	playback = ani_tree["parameters/playback"]
	current_state = State.IDLE
	

func _physics_process(delta: float) -> void:
	state_check()
	state_physics()
	state_animation()

func scaler_force_charged() -> float:
	var mouse_distance: float = position.distance_to(get_global_mouse_position())
	var force: float = min(max_force, (mouse_distance/500) * max_force)
	return force

func state_check() -> void:
	match current_state:
		State.IDLE:
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

func state_physics() -> void:
	match current_state:
		State.IDLE:
			pass
		State.HOVER:
			pass
		State.AIMING:
			force_strength = scaler_force_charged()
			force_direction = -position.direction_to(get_global_mouse_position()).normalized()
		State.MOVING:
			if !impulse_applied:
				print(force_strength)
				apply_central_impulse(force_direction * force_strength)
				impulse_applied = true

func _on_area_2d_mouse_entered() -> void:
	mouse_hover = true

func _on_area_2d_mouse_exited() -> void:
	mouse_hover = false
