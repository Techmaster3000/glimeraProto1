extends Node

# 0.0 -> 24.0
var time_of_day: float = 0.0

# Speed multiplier
var time_scale: float = 0.5

func _process(delta: float) -> void:
	time_of_day += delta * time_scale
	
	# Loop back after 24 hours
	if time_of_day >= 24.0:
		time_of_day -= 24.0


func get_day_percent() -> float:
	return time_of_day / 24.0
