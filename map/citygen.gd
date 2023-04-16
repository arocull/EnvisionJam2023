extends Node3D

@export var tileScenes: Array[PackedScene] = []
@export var tileWeights: Array[float] = []

@export var city_width: int = 3
@export var city_height: int = 3
@export var tiles: Array[int] = []

@onready var bricks: Array[RigidBody3D] = []
@onready var startTransforms: Array[Transform3D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$player.teleport((Vector3(city_width, 1, city_height) * 2.5) - Vector3(2.5, 0, 2.5))
	
	# allocate array
	tiles.resize(city_width * city_height)
	
	# fill with basic
	for x in range(0, city_width):
		for y in range(0, city_height):
			var idx: int = (x * city_width) + y
			tiles[idx] = 1
	
	# pre-place 10 trees
	var preplace_trees: Array = range(0,tiles.size())
	preplace_trees.shuffle()
	preplace_trees.resize(10)
	for idx in preplace_trees:
		tiles[idx] = 2
	
	# enforce center tile to be a blank tile
	var center_tile = (floori(city_width / 2) * city_width) + floori(city_height / 2)
	tiles[center_tile] = 0
	
	# place tiles
	for x in range(0, city_width):
		for y in range(0, city_height):
			var idx: int = (x * city_width) + y
			var tileType = tiles[idx]
			var block = tileScenes[tileType].instantiate()
			block.transform.origin = Vector3(x * 5, 0, y * 5)
			add_child(block)
	
	# place walls
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

func get_transform_distance(start: Transform3D, goal: Transform3D) -> float:
	var angularDist: float = start.basis.get_rotation_quaternion().angle_to(goal.basis.get_rotation_quaternion())
	var physicalDist: float = start.origin.distance_to(goal.origin)
	return (angularDist / PI) + physicalDist

func score() -> int:
	var sum: float = 0
	var total: float = 0
	for i in range(0,bricks.size()):
		var b: RigidBody3D = bricks[i]
		var t: Transform3D = startTransforms[i]
		sum += sqrt(max(get_transform_distance(t, b.global_transform) - 0.2, 0)) * b.mass
		total += b.mass
	
	var s: int = floor((sum / total) * 2000)
	return s
