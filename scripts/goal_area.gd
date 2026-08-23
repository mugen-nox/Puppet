extends Area2D
class_name GoalArea

## Which body counts as "reaching the goal" — usually the torso.
@export var trigger_body_name: String = "torso"

## Local-space range the goal can randomly spawn within each time the
## scene (re)loads. Set to a 170px inset from all sides of the 1152x648
## stage, so the goal never spawns flush against the edge/curtains.
@export var random_bounds: Rect2 = Rect2(170, 170, 812, 308)

func _ready() -> void:
  position = Vector2(
    randf_range(random_bounds.position.x, random_bounds.position.x + random_bounds.size.x),
    randf_range(random_bounds.position.y, random_bounds.position.y + random_bounds.size.y)
  )
  body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
  if body.name != trigger_body_name:
    return
  GameState.score += 1
  print("Score: ", GameState.score)
  # Deferred: reloading mid physics-step (which is when body_entered
  # fires) can cause issues — let the current step finish first.
  get_tree().call_deferred("reload_current_scene")