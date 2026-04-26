extends State

@export var idle_state : State

func physics_update(_delta):
	var input_dir = player.get_input()
	var camera_basis = player._camera_pivot.global_transform.basis
	
	var forward = -camera_basis.z
	var right = camera_basis.x
	
	# Flatten so we don't move vertically when camera looks up/down
	forward.y = 0
	right.y = 0
	
	forward = forward.normalized()
	right = right.normalized()
	var direction = player.get_camera_direction(input_dir)
	
	player.velocity.x = direction.x * player.SPEED
	player.velocity.z = direction.z * player.SPEED

	if player.is_on_floor():
		state_machine.change_state(idle_state)
