extends Camera3D

@export var spring_arm: Node3D
@export var lerp_power: float = 1.0

func _process(delta: float) -> void:
	if spring_arm == null:
		print("SPRING ARM IS NULL!")
		return
	if not current:
		return
	global_position = lerp(global_position, spring_arm.global_position, delta*lerp_power)
