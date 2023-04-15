@tool
extends Node3D
class_name GBrickPlacer

const RESOURCE_BRICK = preload("res://tiles/props/brick.tscn")
const RESOURCE_BRICK_HALF = preload("res://tiles/props/halfbrick.tscn")

@export var tile_size: float = 5
@export var brick_length: float = 1
@export var layer_offset: float = 0.25
@export_range(0.5,5.0,0.5) var layer_width: float = 2
@export_range(0.5,5.0,0.5) var layer_height: float = 2
@export var num_layers: int = 8
@export var replace: bool = false:
	get:
		return false
	set(newVal):
		generate()
@export var offsets_x: Array[float] = [0, 0, 0, 0]
@export var offsets_y: Array[float] = [0, 0, 0, 0]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	set_physics_process(false)

func generate():
	for child in get_children():
		child.owner = null
		child.queue_free()
	
	var startX: float = (tile_size - layer_width) / 2
	var startY: float = (tile_size - layer_height) / 2
	var doStagger = false
	for i in range(0,num_layers):
		var stagger: float = 0
		var stagger2: float = brick_length / 2
		if doStagger:
			stagger = brick_length / 2
			stagger2 = 0
		
		var xCount: int = floor(layer_width / brick_length)
		var yCount: int = floor(layer_height / brick_length)
		
		for x in range(0, xCount):
			place_brick(float(x) * brick_length + startX + stagger, startY - layer_offset, i, false, 0, x + 1 == xCount)
			place_brick(float(x) * brick_length + startX + stagger, startY + layer_height - layer_offset, i, false, 2, x + 1 == xCount)
		for y in range(0, yCount):
			place_brick(startX - layer_offset, float(y) * brick_length + startY + stagger2, i, true, 1, y + 1 == xCount)
			place_brick(startX + layer_width - layer_offset, float(y) * brick_length + startY + stagger2, i, true, 3, y + 1 == xCount)
		
		doStagger = not doStagger

func place_brick(xPos: float, yPos: float, layer: int, rotated: bool, idx: int, end: bool):
	var b
	if end:
		b = RESOURCE_BRICK.instantiate()#RESOURCE_BRICK_HALF.instantiate()
	else:
		b = RESOURCE_BRICK.instantiate()
	
	var t: Transform3D = Transform3D()
	if not rotated:
		t = t.rotated(Vector3.UP, PI / 2)
	if idx <= offsets_x.size():
		xPos += offsets_x[idx]
	if idx <= offsets_y.size():
		yPos += offsets_y[idx]
	
	t.origin = Vector3(xPos, layer * (brick_length / 2) + (brick_length / 4), yPos)
	
	b.transform = t
	
	add_child(b)
	b.owner = get_parent()
