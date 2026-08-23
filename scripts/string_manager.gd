extends Node2D
class_name StringManager

## Owns the set of limbs and decides which ones still take player input.
## This is the single source of truth for "how much control does the
## player have right now" — levels/finale read this to know when to
## strip the last string.

@export var limbs: Array[Limb] = []

signal all_strings_cut

func cut(limb: Limb) -> void:
	if not limbs.has(limb):
		return
	limb.cut_string()
	if get_attached_count() == 0:
		emit_signal("all_strings_cut")

func get_attached_count() -> int:
	var count := 0
	for limb in limbs:
		if limb.string_attached:
			count += 1
	return count

func get_attached_limbs() -> Array[Limb]:
	return limbs.filter(func(l): return l.string_attached)

## Convenience for the finale: cut everything at once, in sequence,
## with a short delay between each for dramatic weight rather than
## an instant snap. Wire this to a Tween/Timer when building the
## finale level.
func cut_all_in_sequence() -> void:
	for limb in limbs:
		if limb.string_attached:
			cut(limb)
			await get_tree().create_timer(0.6).timeout
