extends Node

signal gun(from: Vector3, to: Vector3)

const EXPLOSION = preload("res://efx/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	gun.connect(placeExplosion)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func placeExplosion(from: Vector3, to: Vector3):
	var exp = EXPLOSION.instantiate()
	exp.transform.origin = to
	get_tree().current_scene.add_child(exp)
