extends Node3D

# ------------- CHARACTER MOVEMENT -------------

@onready var PLAYER : CharacterBody3D = get_parent()

## --- VARIABLES ---
var speed = 5.0
var jump_velocity = 4.5
var horizontal_acceleration = 30
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $camera

func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		PLAYER.rotate_y(-event.relative.x * .005)
		camera.rotate_x(-event.relative.y * .005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		print(camera)

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED: 
			Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Add the gravity.
	if not PLAYER.is_on_floor():
		PLAYER.velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and PLAYER.is_on_floor():
		PLAYER.velocity.y += jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector3.ZERO
	var movetoward = Vector3.ZERO
	input_dir.x = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").x
	input_dir.y = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").y
	input_dir=input_dir.normalized()
	var direction = (PLAYER.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction *= speed
	PLAYER.velocity.x = move_toward(PLAYER.velocity.x,direction.x, horizontal_acceleration * delta)
	PLAYER.velocity.z = move_toward(PLAYER.velocity.z,direction.z, horizontal_acceleration * delta)

	var angle=5
	var t = delta * 6
	PLAYER.rotation_degrees=PLAYER.rotation_degrees.lerp(Vector3(input_dir.normalized().y*angle,PLAYER.rotation_degrees.y,-input_dir.normalized().x*angle),t)
	
	PLAYER.move_and_slide()
	PLAYER.force_update_transform()
