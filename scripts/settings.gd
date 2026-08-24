extends Control

@onready var volume_slider: HSlider = $VolumeSlider

func _ready() -> void:
	var current_db := AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	volume_slider.value = db_to_linear(current_db)
	volume_slider.value_changed.connect(_on_volume_changed)

func _on_volume_changed(value: float) -> void:
	var bus_idx := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("uid://cykqn3id7oux7")
