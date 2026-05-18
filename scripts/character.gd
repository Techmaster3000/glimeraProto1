extends CharacterBody3D


const SPEED = 1
const JUMP_VELOCITY = 2.5
@onready var camera := $"CameraPivot/CharacterCam" as Camera3D
@onready var _camera_pivot := $CameraPivot as Node3D

var knockback_velocity: Vector3 = Vector3.ZERO
var knockback_time := 0.0

@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)




func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass
		# Pitch (up/down) → pivot only
		#_camera_pivot.rotation.x -= event.screen_relative.y * mouse_sensitivity
		#_camera_pivot.rotation.x = clampf(
			#_camera_pivot.rotation.x,
			#-tilt_limit,
			#tilt_limit
		#)

		# Yaw (left/right) → player ONLY
		#_camera_pivot.rotate_y(-event.screen_relative.x * mouse_sensitivity)

func _ready() -> void:
	pass
	
func _rotate_toward_movement(delta, direction):
	const TURN_SPEED = 9.0
	var move_dir := Vector3(velocity.x, 0, velocity.z)

	if move_dir.length() < 0.05:
		return

	rotation.y = lerp_angle(rotation.y, (atan2(direction.x, direction.z) - PI / 2), delta * TURN_SPEED)


func _physics_process(delta: float) -> void:
	if knockback_time > 0.0:
		velocity = knockback_velocity
		knockback_time -= delta
		move_and_slide()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Dialogic.current_timeline != null:
		return

func get_input() -> Vector3:
	return Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0.0,
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

func get_camera_direction(input_dir: Vector3) -> Vector3:
	var cam_basis = camera.global_transform.basis
	var cam_forward = cam_basis.z
	var cam_right = cam_basis.x

	cam_forward.y = 0
	cam_right.y = 0

	return (cam_right * input_dir.x + cam_forward * input_dir.z).normalized()

func rotate_toward(direction: Vector3, delta: float):
	const TURN_SPEED = 9.0
	var move_dir = Vector3(velocity.x, 0, velocity.z)
	if move_dir.length() < 0.05:
		return
	
	var target_angle = atan2(direction.x, direction.z) - PI / 2

	var model = $"MAsked Gli"
	
	var angle_diff = wrapf(
	target_angle - model.rotation.y,
	-PI,
	PI
	)
	model.rotation.y += clamp(angle_diff, -TURN_SPEED * delta, TURN_SPEED * delta)

func apply_knockback(dir: Vector3, strength: float = 3.0, duration: float = 0.2):
	knockback_velocity = dir * strength
	knockback_time = duration

func face_menu_camera() -> void:
	var menu_cam = get_node_or_null("MenuCamera")
	if menu_cam:
		var dir = menu_cam.global_position - global_position
		dir.y = 0
		dir = dir.normalized()
		var target_angle = atan2(dir.x, dir.z) - PI / 2
		$"MAsked Gli".rotation.y = target_angle
