extends KinematicBody

const utils = preload("res://utils.gd")

var target_rotation = 0
var velocity = Vector3(0, 0, 0)
var acceleration = Vector3(0, 0, 0)
var camera
var camera_point
var jumping = false

const GRAVITY = Vector3(0, -9.8, 0)
const SPEED = 10
const ACCELERATION = 10
const JUMP_ACCELERATION_FACTOR = 5
const ROTATION_SPEED = 10
const CAMERA_OFFSET = Vector3(-1, 2, -1) * 20

func _ready():
	set_physics_process(true)
	setup_camera()

func _physics_process(dt):
	apply_velocity(dt)
	apply_rotation(dt)
	input_acceleration(dt)

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
	camera.fov = 32
	camera.speed = 2
	camera.target = "../"
	camera_point.look_at(Vector3(0, 0, 0), Vector3(0, 1, 0))

func apply_velocity(dt):
	var vel = velocity
	if is_on_floor():
		vel.x = lerp(vel.x, acceleration.x * SPEED, dt * ACCELERATION)
		vel.z = lerp(vel.z, acceleration.z * SPEED, dt * ACCELERATION)
		vel.y += acceleration.y
	vel += GRAVITY * dt

	velocity = move_and_slide(vel, Vector3(0, 1, 0))

	if jumping and is_on_floor():
		jumping = false
		on_end_jump()

	camera_point.translation = translation + CAMERA_OFFSET

func apply_rotation(dt):
	if velocity.x != 0 or velocity.z != 0:
		target_rotation = atan2(velocity.x, velocity.z)

	rotation.y = utils.lerp_angle(rotation.y, target_rotation, dt * ROTATION_SPEED)

func input_acceleration(dt):
	if Input.is_action_pressed("ui_right"):
		acceleration.x = -1
	elif Input.is_action_pressed("ui_left"):
		acceleration.x = 1
	else:
		acceleration.x = 0

	if Input.is_action_pressed("ui_up"):
		acceleration.z = 1
	elif Input.is_action_pressed("ui_down"):
		acceleration.z = -1
	else:
		acceleration.z = 0

	if Input.is_action_pressed("ui_select") and is_on_floor():
		acceleration.y = JUMP_ACCELERATION_FACTOR
		jumping = true
		on_start_jump()
	else:
		acceleration.y = 0

func on_start_jump():
	pass
func on_end_jump():
	var Poof = preload("res://effects/jump_poof.tscn")
	var poof = Poof.instance()
	poof.translation = translation
	get_parent().add_child(poof)