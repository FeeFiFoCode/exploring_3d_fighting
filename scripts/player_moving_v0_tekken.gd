#class_name Player_v0
extends CharacterBody3D

var sensitivity = 3.0
var is_facing_left = true
var facing = 1.0


const SPEED = 10.0
const SPEED_GROUND_WAVE_BURST = 20.0
const SPEED_AIR_WAVE_BURST = 30.0

var SPEED_X
const SPEED_FWD = 10
const SPEED_BCK = 7.5
const SPEED_SIDE = 7.5

const TRACTION = 5

const FRAME_WAVE_GROUND = 10
var ctr_frame_wave_ground = FRAME_WAVE_GROUND

const FRAME_WAVE_AIR = 15
const MAX_WD_AIR = 3
var ctr_wd_air = MAX_WD_AIR
var ctr_frame_wave_air = FRAME_WAVE_AIR

var can_wd_air = true
var can_wd_gr = true

var actual_speed = SPEED

const JUMP_VELOCITY = 15.0
const VELOCITY_TERMINAL = -25.0
var actual_velocity_terminal = VELOCITY_TERMINAL

const JUMP_AIR_VELOCITY = 10.0
const MAX_AIR_JUMPS = 5
var CTR_AIR_JUMPS = MAX_AIR_JUMPS

var SCALE_WAVE
const SCALE_WAVE_GR = 1.3
const SCALE_WAVE_AIR = 1.5


## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 0.8

# Dash Logic
var can_dash = false
var is_dashing = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_AIR_VELOCITY

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.adwas
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if Input.is_action_pressed("wave"):
		print("scale wave active")
		if is_on_floor():
			SCALE_WAVE = SCALE_WAVE_GR
		else:
			SCALE_WAVE = SCALE_WAVE_AIR
	else:
		print("scale wave NOT active")
		SCALE_WAVE = 1.0
		
		
	if direction.x * facing < 0:
		SPEED_X = SPEED_BCK
	else:
		SPEED_X = SPEED_FWD

	if direction:
		velocity.x = direction.x * SPEED_X * SCALE_WAVE
		velocity.z = direction.z * SPEED_SIDE * SCALE_WAVE
	else:
		velocity.x = move_toward(velocity.x, 0, TRACTION)
		velocity.z = move_toward(velocity.z, 0, TRACTION)

	move_and_slide()
