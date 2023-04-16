extends Node3D
class_name Player

var shake: float = 0
var shake_decay: float = 1000

func _ready():
	EFX.connect("explosion_at", _add_camera_shake)

func _process(delta):
	$cam_parent.global_transform.origin = $RigidBody3D.global_transform.origin
	$cam_parent/cam_offset/Camera3D.position = random_vector() * (min(shake, 200) / 1000)
	shake -= delta * shake_decay
	if shake < 0:
		shake = 0

func teleport(newLocation: Vector3):
	$RigidBody3D.global_transform.origin = newLocation

func _input(event):
	if event.is_action("quit"):
		print("Score when quit: " + str(get_tree().current_scene.score()))
		get_tree().quit()

func _add_camera_shake(position: Vector3):
	var dist: float = position.distance_to($RigidBody3D.global_position)
	shake += 500 / dist

func random_vector() -> Vector3:
	return (Vector3(randf(), randf(), randf()) - Vector3(0.5, 0.5, 0.5)).normalized()
