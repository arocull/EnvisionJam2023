extends RigidBody3D

@export var force_movement: float = 250
@export var jump_force: float = 50

@onready var fire: bool = false

func _ready():
	pass

func _physics_process(delta):
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
	
	if fire:
		fire_rocket()

func fire_rocket():
	fire = false
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
		
		var guncast = PhysicsRayQueryParameters3D.create(
			global_transform.origin,
			pos,
		)
		guncast.hit_back_faces = false
		guncast.hit_from_inside = false
		
		var guncastResult = get_world_3d().direct_space_state.intersect_ray(depthCast)
		if guncastResult.has("position"):
			EFX.call_deferred("emit_signal", "gun", global_position, guncastResult.get("position"))
