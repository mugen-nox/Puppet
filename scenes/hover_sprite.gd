extends Button

@export var hover_scale: float = 1.08
@export var anim_time: float = 0.12
@onready var hover_sprite: TextureRect = $HoverSprite

func _ready() -> void:
	await get_tree().process_frame
	pivot_offset = size / 2
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(hover_scale, hover_scale), anim_time)
	tween.parallel().tween_property(hover_sprite, "modulate:a", 1.0, anim_time)

func _on_mouse_exited() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, anim_time)
	tween.parallel().tween_property(hover_sprite, "modulate:a", 0.0, anim_time)
