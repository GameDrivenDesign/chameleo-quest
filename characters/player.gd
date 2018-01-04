extends KinematicBody

const utils = preload("res://utils.gd")

var target_rotation = 0
var velocity = Vector2(0, 0)
var acceleration = Vector2(0, 0)
var camera
var camera_point

const SPEED = 10
const ACCELERATION = 10
const ROTATION_SPEED = 10
const CAMERA_OFFSET = Vector3(-8, 15, -8)

func _ready():
	set_physics_process(true)
	setup_camera()

func _physics_process(dt):
	input_acceleration(dt)
	apply_velocity(dt)
	apply_rotation(dt)

func setup_camera():
	camera = InterpolatedCamera.new()
	camera.set_name("camera")
	camera_point = Spatial.new()
	camera_point.set_name("camera_point")
	camera_point.add_child(camera)
	
	yield(get_tree(), "idle_frame")
	get_parent().add_child(camera_point)
	camera.current = true
	camera.enabled = true
	camera.speed = 2
	camera.target = "../"
	camera_point.look_at(Vector3(0, 0, 0), Vector3(0, 1, 0))

func apply_velocity(dt):
	velocity = velocity.linear_interpolate(acceleration * SPEED, dt * ACCELERATION)
	move_and_slide(Vector3(velocity.x, 0, velocity.y), Vector3(0, 1, 0))
	camera_point.translation = translation + CAMERA_OFFSET

func apply_rotation(dt):
	if acceleration != Vector2(0, 0):
		target_rotation = atan2(acceleration.x, acceleration.y)

	rotation.y = utils.lerp_angle(rotation.y, target_rotation, dt * ROTATION_SPEED)

func input_acceleration(dt):
	if Input.is_action_pressed("ui_right"):
		acceleration.x = -1
	elif Input.is_action_pressed("ui_left"):
		acceleration.x = 1
	else:
		acceleration.x = 0

	if Input.is_action_pressed("ui_up"):
		acceleration.y = 1
	elif Input.is_action_pressed("ui_down"):
		acceleration.y = -1
	else:
		acceleration.y = 0