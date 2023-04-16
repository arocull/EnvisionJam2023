extends Node

const EXPLOSION = preload("res://efx/explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func placeExplosion(at: Vector3):
	var exp = EXPLOSION.instantiate()
	exp.transform.origin = at
	get_tree().current_scene.add_child(exp)
