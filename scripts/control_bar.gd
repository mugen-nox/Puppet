extends AnimatableBody2D
class_name ControlBar

@export var move_speed: float = 300.0

## How far the bar can travel from its starting position, not an absolute
## world-space rect. This way, repositioning or rotating the bar in the
## editor never puts it outside its own allowed range.
@export var move_range: Vector2 = Vector2(400, 150)

var _origin: Vector2

func _ready() -> void:
	_origin = global_position

func _physics_process(delta: float) -> void:
	var input_vector := Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	var new_pos := global_position + input_vector * move_speed * delta
	new_pos.x = clamp(new_pos.x, _origin.x - move_range.x, _origin.x + move_range.x)
	new_pos.y = clamp(new_pos.y, _origin.y - move_range.y, _origin.y + move_range.y)
	global_position = new_pos
