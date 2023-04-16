extends RigidBody3D

const ROCKET = preload("res://player/rocket.tscn")

@export var force_movement: float = 250
@export var jump_force: float = 50
@export var max_attack_cooldown: float = 0.1

@onready var attack_cooldown: float = max_attack_cooldown

func _ready():
	pass

func _physics_process(delta):
	if GameManager.phase != GameManager.PHASE.Game:
		return
	
	var ray = PhysicsRayQueryParameters3D.new()
	ray.collision_mask = 1 << 0
	ray.from = global_transform.origin
	ray.to = global_transform.origin - (0.6 * Vector3.UP)
	ray.hit_back_faces = false
	ray.hit_from_inside = false
	var hitResults = get_world_3d().direct_space_state.intersect_ray(ray)
	
	var grounded: bool = false
	if hitResults.has("normal"):
		grounded = true
		if Input.is_action_just_pressed("move_jump"):
			apply_central_impulse(hitResults.get("normal", Vector3.UP) * jump_force)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")

	apply_central_force(Vector3(input_dir.x, 0, input_dir.y) * force_movement)
	
	attack_cooldown -= delta
	if attack_cooldown <= 0 and Input.is_action_pressed("attack"):
		fire_rocket()

func fire_rocket():
	attack_cooldown = max_attack_cooldown
	var mousePos = get_viewport().get_mouse_position()
	var normal = get_viewport().get_camera_3d().project_ray_normal(mousePos)
	var cam: Camera3D = get_viewport().get_camera_3d()
	
	var depthCast = PhysicsRayQueryParameters3D.create(
		cam.global_transform.origin,
		cam.global_transform.origin + normal * 100,
	)
	
	var depthCastResult = get_world_3d().direct_space_state.intersect_ray(depthCast)
	if depthCastResult.has("position"):
		var pos: Vector3 = depthCastResult.get("position")

		var t: Transform3D = Transform3D()
		t.origin = global_position
		pos.y = t.origin.y
		t = t.looking_at(pos).orthonormalized()
		apply_central_impulse(t.basis.z * 25)
		call_deferred("spawn_rocket", t)

func spawn_rocket(t: Transform3D):
	var r = ROCKET.instantiate()
	
	add_child(r)
	r.global_transform = t
