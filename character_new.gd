extends CharacterBody3D

# ------------- CHARACTER VIEWPORT -------------

## --- VIEWPORT VARIABLES ---
@onready var fp_camera = $Camera3D
var camera

func ready_character_viewport():
	fp_camera.current = true
	camera=fp_camera
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

# ------------- CHARACTER MOVEMENT -------------

## --- MOVEMENT VARIABLES ---
var speed = 5.0
var jump_velocity = 4.5
var horizontal_acceleration = 30
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED: 
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector3.ZERO
	var movetoward = Vector3.ZERO
	input_dir.x = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_forward", "move_backward")).x 
	input_dir.y = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_forward", "move_backward")).y
	 
	#input_dir.x = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").x   # <-- this has weird glithes on web. Looks like it is getting stuck on value, and player keeps moving while person is touching nothing.
	#input_dir.y = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").y   # <-- this has weird glithes on web. Looks like it is getting stuck on value, and player keeps moving while person is touching nothing.
	
	input_dir=input_dir.normalized()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction *= speed
	velocity.x = move_toward(velocity.x,direction.x, horizontal_acceleration * delta)
	velocity.z = move_toward(velocity.z,direction.z, horizontal_acceleration * delta)

	var angle=5
	var t = delta * 6
	rotation_degrees=rotation_degrees.lerp(Vector3(input_dir.normalized().y*angle,rotation_degrees.y,-input_dir.normalized().x*angle),t)
	
	move_and_slide()
	force_update_transform()
	

# ------------- GROUPED FUNCTIONS -------------
func _ready():
	ready_character_viewport()
