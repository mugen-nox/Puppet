extends RigidBody2D
class_name Limb

## One limb of the puppet (arm, leg, head...).
## While `string_attached` is true, movement comes from the DampedSpringJoint2D
## connecting this limb to the ControlBar — this script doesn't need to push
## the limb around, just keep it settled and slightly alive. Once the string
## is cut, this script disables that joint and takes over with autonomous
## "freed" motion instead.

@export var limb_name: String = "limb"
@export var string_attached: bool = true

## Drag this limb's matching DampedSpringJoint2D (under the "strings" node)
## into this slot in the Inspector. Cutting the string disables this joint.
@export var string_joint_path: NodePath

## Light idle damping so controlled limbs settle instead of jittering
## endlessly from the spring joint's forces.
@export var controlled_angular_damp: float = 2.0

## How strongly a freed limb wanders once cut loose.
@export var autonomous_wander_strength: float = 40.0
@export var autonomous_torque_strength: float = 15.0

signal string_cut(limb: Limb)

var _wander_seed: float = 0.0

func _ready() -> void:
	# Give each limb a different wander phase so freed limbs don't all
	# move in lockstep with each other.
	_wander_seed = randf() * TAU

func _physics_process(delta: float) -> void:
	if string_attached:
		_process_controlled(delta)
	else:
		_process_autonomous(delta)

func _process_controlled(_delta: float) -> void:
	# The spring joint handles the actual pulling. This just damps
	# excess spin so the limb settles instead of endlessly wobbling.
	angular_damp = controlled_angular_damp

func _process_autonomous(delta: float) -> void:
	# Should feel ALIVE, not broken — the point of the theme is that
	# losing control isn't only loss, it's also a kind of freedom.
	var t := Time.get_ticks_msec() / 1000.0 + _wander_seed
	var wander_force := Vector2(sin(t * 1.3), cos(t * 0.9)) * autonomous_wander_strength
	apply_central_force(wander_force)

	var wander_torque := sin(t * 0.7) * autonomous_torque_strength
	apply_torque(wander_torque)

func cut_string() -> void:
	if not string_attached:
		return
	string_attached = false
	emit_signal("string_cut", self)

	var joint := get_node_or_null(string_joint_path) as Joint2D
	if joint:
		joint.disabled = true
	else:
		push_warning("Limb '%s' has no string_joint_path assigned — cut had no physical effect." % limb_name)
