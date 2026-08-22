extends Node
class_name SFXPlayer

@onready var sfx: AudioStreamPlayer = $AudioStreamPlayer

## Single one-shot play, pitch randomized so it never sounds identical twice.
func play(stream: AudioStream) -> void:
	sfx.stream = stream
	sfx.pitch_scale = randf_range(0.9, 1.1)
	sfx.play()

## Plays the same sound 4 times in a row, ramping volume up each time
## so the last one lands the loudest.
func play_ramp(stream: AudioStream, times: int = 4, interval: float = 0.4,
		quietest_db: float = -10.0, loudest_db: float = 0.0) -> void:
	for i in range(times):
		var t: float = float(i) / float(max(times - 1, 1))
		var volume: float = lerp(quietest_db, loudest_db, t)
		_fire_one_shot(stream, volume)
		if i < times - 1:
			await get_tree().create_timer(interval).timeout

func _fire_one_shot(stream: AudioStream, volume_db: float) -> void:
	var player := AudioStreamPlayer.new()
	add_child(player)
	player.stream = stream
	player.pitch_scale = randf_range(0.9, 1.1)
	player.volume_db = volume_db
	player.play()
	player.finished.connect(player.queue_free)
