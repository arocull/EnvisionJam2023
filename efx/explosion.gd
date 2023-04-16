extends Node3D
class_name Explosion

@export var force: float = 55
@export var maxDistance: float = 3.5
@onready var duration: float = 1.5
@onready var exploded: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$clouds.emitting = true
	$main.emitting = true

func _physics_process(delta):
	if not exploded:
		exploded = true
		var bodies = $Area3D.get_overlapping_bodies()
		for b in bodies:
			if b is RigidBody3D:
				var offset: Vector3 = b.global_position - global_position
				var d: float = offset.length()
				b.apply_impulse(remap(d, 0, maxDistance, 0, 1) * offset.normalized() * force, offset)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	duration -= delta
	if duration <= 0:
		queue_free()
		set_process(false)
