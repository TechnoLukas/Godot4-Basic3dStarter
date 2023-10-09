extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const FRICTION = 25
const HORIZONTAL_ACCELERATION = 30
const MAX_SPEED=5
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D



func _ready():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
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
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		velocity.y += JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Vector3.ZERO
	var movetoward = Vector3.ZERO
	input_dir.x = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").x
	input_dir.y = Input.get_vector("move_left", "move_right", "move_forward", "move_backward").y
	input_dir=input_dir.normalized()
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction *= SPEED
	velocity.x = move_toward(velocity.x,direction.x, HORIZONTAL_ACCELERATION * delta)
	velocity.z = move_toward(velocity.z,direction.z, HORIZONTAL_ACCELERATION * delta)

	var angle=5
	#rotation_degrees=Vector3(input_dir.normalized().y*angle,rotation_degrees.y,-input_dir.normalized().x*angle)
	var t = delta * 6
	if Input.mouse_mode==Input.MOUSE_MODE_CAPTURED: 
		rotation_degrees=rotation_degrees.lerp(Vector3(input_dir.normalized().y*angle,rotation_degrees.y,-input_dir.normalized().x*angle),t)
	
	move_and_slide()
	force_update_transform()
