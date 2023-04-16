extends Node3D
class_name Player

func _process(delta):
	$cam_parent.global_transform.origin = $RigidBody3D.global_transform.origin

func teleport(newLocation: Vector3):
	$RigidBody3D.global_transform.origin = newLocation

func _input(event):
	if event.is_action("quit"):
		get_tree().current_scene.score()
		get_tree().quit()
