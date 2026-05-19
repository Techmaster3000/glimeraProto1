extends Node

@onready var world_environment: WorldEnvironment = $"../WorldEnvironment"
@onready var sun_container: Node3D = $"../SunContainer"

func _process(delta: float) -> void:
	var day_percent = TimeManager.get_day_percent()

	# Convert time to angle
	var angle = day_percent * TAU

	world_environment.environment.sky_rotation.z = -angle
	sun_container.rotation.z = -angle
