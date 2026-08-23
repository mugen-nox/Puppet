extends Node2D
class_name LevelBase

## Shared behavior for every level: knows how many strings should be
## cut by the time this level ends, and exposes a signal for the
## level-transition flow in main.tscn.

@export var strings_to_cut_this_level: int = 0
@export var next_level_path: String = ""

signal level_complete

func _on_level_complete() -> void:
	emit_signal("level_complete")
	# TODO: fade out, play any end-of-level beat, then load next_level_path
