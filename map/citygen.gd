extends Node3D

@export var tileScenes: Array[PackedScene] = []
@export var tileWeights: Array[float] = []

@export var city_width: int = 3
@export var city_height: int = 3

@onready var bricks: Array[RigidBody3D] = []
@onready var startTransforms: Array[Transform3D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$player.teleport(Vector3(float(city_width) / 2, 1, float(city_height) / 2) * 5)
	
	for x in range(0, city_width):
		for y in range(0, city_height):
			var block
			if x == floor(city_width / 2) and y == floor(city_height / 2):
				block = preload("res://tiles/block_ground.tscn").instantiate()
			else:
				block = tileScenes.pick_random().instantiate()
			block.transform.origin = Vector3(x * 5, 0, y * 5)
			add_child(block)
	
	for x in range(-1, city_width + 1):
		for y in range(-1, city_height + 1):
			if x == -1 or x == city_width or y == -1 or y == city_height:
				var w = preload("res://tiles/prebuilds/wall.tscn").instantiate()
				w.transform.origin = Vector3(x * 5, 0, y * 5)
				add_child(w)
	
	call_deferred("prep_score")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func prep_score():
	for child in get_tree().get_nodes_in_group("destructible"):
		if child is RigidBody3D:
			bricks.append(child)
			startTransforms.append(child.global_transform)

func score() -> float:
	var sum: float = 0
	var total: float = 0
	for i in range(0,bricks.size()):
		var b: RigidBody3D = bricks[i]
		var t: Transform3D = startTransforms[i]
		sum += b.global_transform.origin.distance_to(t.origin) * b.mass
		total += b.mass
	
	print_debug("Score: ", sum / total)
	return sum / total
