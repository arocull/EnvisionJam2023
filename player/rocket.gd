extends RigidBody3D

var lifetime: float = 5
@export var speed: float = 70

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("thaw")

func thaw():
	freeze = false
	linear_velocity = -global_transform.basis.z * speed

func _physics_process(delta):
	lifetime -= delta
	if lifetime <= 0: # Explode on timeout
		_explode()

func _on_body_entered(_body):
	_explode()

func _explode():
	EFX.call_deferred("placeExplosion", global_position)
	queue_free()
