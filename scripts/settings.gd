extends Control

@onready var volume_slider: HSlider = $VolumeSlider
@onready var ambient_slider: HSlider = $AmbientSlider
@onready var creak_slider: HSlider = $CreakSlider
@onready var ambient_preview: AudioStreamPlayer = $AmbientPreview
@onready var creak_preview: AudioStreamPlayer = $CreakPreview

func _ready() -> void:
	_setup_slider(volume_slider, "Master", null)
	_setup_slider(ambient_slider, "Ambient", ambient_preview)
	_setup_slider(creak_slider, "Creak", creak_preview)

func _setup_slider(slider: HSlider, bus_name: String, preview: AudioStreamPlayer) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	slider.value = db_to_linear(AudioServer.get_bus_volume_db(idx))
	slider.value_changed.connect(func(v): AudioServer.set_bus_volume_db(idx, linear_to_db(v)))
	if preview:
		slider.drag_started.connect(func(): preview.play())

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("uid://cykqn3id7oux7")
