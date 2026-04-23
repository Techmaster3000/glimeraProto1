extends State	

@export var idle_state : State
@export var jump_state : State
@export var fall_state : State
@onready var input_dir : Vector3

func enter():
	state_machine.animMachine.travel("Walk")
	
func physics_update(delta):
	var input_dir = player.get_input()

	# --- Camera-relative movement ---
	var camera_basis = player._camera_pivot.global_transform.basis
	
	var forward = -camera_basis.z
	var right = camera_basis.x
	
	# Flatten so we don't move vertically when camera looks up/down
	forward.y = 0
	right.y = 0
	
	forward = forward.normalized()
	right = right.normalized()
	var direction = player.get_camera_direction(input_dir)
	#var direction = (forward * input_dir.z + right * input_dir.x).normalized()

	# --- Transitions ---
	if not player.is_on_floor():
		state_machine.change_state(fall_state)
		return

	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(jump_state)
		return

	if input_dir == Vector3.ZERO:
		state_machine.change_state(idle_state)
		return

	# --- Movement ---
	player.velocity.x = direction.x * player.SPEED
	player.velocity.z = direction.z * player.SPEED

	# --- Rotate player toward movement direction ---
	player.rotate_toward(direction, delta)
