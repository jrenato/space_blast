extends RigidBody2D

enum {INIT, ALIVE, INVULNERABLE, DEAD}

@export var engine_power: int = 500
@export var spin_power: int = 8000

var state: int = INIT
var thrust: Vector2 = Vector2.ZERO
var rotation_dir: int = 0
var screensize: Vector2 = Vector2.ZERO

@onready var collision_shape: CollisionShape2D = %CollisionShape2D


func _ready() -> void:
	screensize = get_viewport_rect().size
	change_state(ALIVE)


func _process(delta: float) -> void:
	get_input()


func _physics_process(delta: float) -> void:
	constant_force = thrust
	constant_torque = rotation_dir * spin_power


func _integrate_forces(physics_state: PhysicsDirectBodyState2D) -> void:
	var xform = physics_state.transform
	xform.origin.x = wrapf(xform.origin.x, 0, screensize.x)
	xform.origin.y = wrapf(xform.origin.y, 0, screensize.y)
	physics_state.transform = xform


func get_input() -> void:
	thrust = Vector2.ZERO

	if state in [DEAD, INIT]:
		return

	if Input.is_action_pressed("thrust"):
		thrust = transform.x * engine_power

	rotation_dir = Input.get_axis("rotate_left", "rotate_right")


func change_state(new_state: int) -> void:
	match new_state:
		INIT:
			collision_shape.set_deferred("disabled", true)
		ALIVE:
			collision_shape.set_deferred("disabled", false)
		INVULNERABLE:
			collision_shape.set_deferred("disabled", true)
		DEAD:
			collision_shape.set_deferred("disabled", true)

	state = new_state
