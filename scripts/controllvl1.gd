extends Control

@onready var point_light: PointLight2D = $TextureRect/PointLight2D
@onready var camera: Camera2D = $Camera2D
@onready var switch_sfx: SFXPlayer = $SwitchSfx




@export var dark_duration: float = 1.2        # how long it stays dark first
@export var transition_duration: float = 2.4  # camera zoom duration
@export var target_light_energy: float = 2.5
@export var zoom_amount_px: float = -300.0       # how many px "in" to zoom
@export var base_width: float = 1152.0         # your project's base resolution width

@export var light_steps: int = 4               # number of discrete flicks (match sfx hit count)
@export var light_step_interval: float = 0.4  # pause between flicks (match sfx interval)

func _ready() -> void:
	point_light.energy = 0.0
	camera.zoom = Vector2.ONE
	_play_intro()

func _play_intro() -> void:
	await get_tree().create_timer(dark_duration).timeout

	# camera zoom stays smooth, runs alongside the flicker
	var target_zoom_value := (base_width - zoom_amount_px) / base_width
	var target_zoom := Vector2(target_zoom_value, target_zoom_value)
	var zoom_tween := create_tween()
	zoom_tween.tween_property(camera, "zoom", target_zoom, transition_duration) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# light and sfx fire together, both stepped instead of smooth
	switch_sfx.play_ramp(preload("res://audio/sfx/light_switch_turn_on.wav"),
		light_steps, light_step_interval)
	_flicker_light_on(light_steps, light_step_interval)

## Jumps light energy in discrete steps rather than fading smoothly,
## so it reads as flicks/pulses in sync with the sfx hits.
func _flicker_light_on(steps: int, interval: float) -> void:
	for i in range(steps):
		var step_t: float = float(i + 1) / float(steps)
		point_light.energy = target_light_energy * step_t
		if i < steps - 1:
			await get_tree().create_timer(interval).timeout
