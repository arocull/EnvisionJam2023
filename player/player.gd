extends Node3D
class_name Player

var shake: float = 0
var shake_decay: float = 100

func _process(delta):
	$cam_parent.global_transform.origin = $RigidBody3D.global_transform.origin
	
	shake -= delta

func teleport(newLocation: Vector3):
	$RigidBody3D.global_transform.origin = newLocation

func _input(event):
	if event.is_action("quit"):
		print("Score when quit: " + str(get_tree().current_scene.score()))
		get_tree().quit()
