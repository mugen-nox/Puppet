extends AudioStreamPlayer
@export var creak_sounds: Array[AudioStream] = [
	preload("res://creak.wav"),
	preload("res://creak1.wav"),
	preload("res://creak2.wav"),
]
@export var min_interval: float = 8.0
@export var max_interval: float = 20.0

func _ready() -> void:
	_schedule_next()

func _schedule_next() -> void:
	var wait_time := randf_range(min_interval, max_interval)
	await get_tree().create_timer(wait_time).timeout
	if not creak_sounds.is_empty():
		stream = creak_sounds.pick_random()
		play()
	_schedule_next()
