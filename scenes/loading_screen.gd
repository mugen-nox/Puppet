extends Control

func _ready() -> void:
	$VideoStreamPlayer.finished.connect(_go_to_menu)

func _go_to_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/u_ibackground.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed or event is InputEventMouseButton and event.pressed:
		_go_to_menu()
