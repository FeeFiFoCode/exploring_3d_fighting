#class_name Player_v0
extends CharacterBody3D

var sensitivity = 3.0

const SPEED = 10.0
const SPEED_GROUND_WAVE_BURST = 20.0
const SPEED_AIR_WAVE_BURST = 30.0

const FRAME_WAVE_GROUND = 10
var ctr_frame_wave_ground = FRAME_WAVE_GROUND

const FRAME_WAVE_AIR = 15
const MAX_WD_AIR = 3
var ctr_wd_air = MAX_WD_AIR
var ctr_frame_wave_air = FRAME_WAVE_AIR

var can_wd_air = true
var can_wd_gr = true

var actual_speed = SPEED

const JUMP_VELOCITY = 12.5
const VELOCITY_TERMINAL = -25.0
var actual_velocity_terminal = VELOCITY_TERMINAL

const AIR_JUMP_VELOCITY = 7.5
const MAX_AIR_JUMPS = 5
var CTR_AIR_JUMPS = MAX_AIR_JUMPS

## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 15.0

# Dash Logic
var can_dash = false
var is_dashing = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		# Terminal Velocity
		velocity.y = maxf(velocity.y - gravity*delta, actual_velocity_terminal )
#		velocity.y -= gravity*delta
	else:
		CTR_AIR_JUMPS = MAX_AIR_JUMPS
		ctr_wd_air = MAX_WD_AIR

	# Handle Jump.
	## Ground Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		print("Action Jump")
		print("This many air jumps remain: ", CTR_AIR_JUMPS)
		velocity.y = JUMP_VELOCITY
	## Air Jump
	if Input.is_action_just_pressed("jump") and not is_on_floor():
		if CTR_AIR_JUMPS > 0:
			velocity.y = AIR_JUMP_VELOCITY
			CTR_AIR_JUMPS -= 1
			
			print("Action Air Jump")
			print("This many air jumps remain: ", CTR_AIR_JUMPS)
		else:
			print("No more air jumps remain until refresh.")



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
#	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	var direction = transform.basis * Vector3(input_dir.x, 0, 0)
#	var direction_snapshot = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()

	if Input.is_action_just_pressed("wave_burst") and is_on_floor() and can_wd_gr:
#		direction_snapshot = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
		can_wd_gr = false
		actual_speed = SPEED_GROUND_WAVE_BURST
#		if (ctr_frame_wave_ground > 0):
#			ctr_frame_wave_ground -= 1
#			actual_speed = SPEED_GROUND_WAVE_BURST
#		else:
#			ctr_frame_wave_ground = SPEED_GROUND_WAVE_BURST
#			actual_speed = SPEED

	if Input.is_action_just_pressed("wave_burst") and not is_on_floor() and can_wd_air and ctr_wd_air > 0:
#		direction_snapshot = (transform.basis * Vector3(input_dir.x, input_dir.y, 0)).normalized()
		can_wd_air = false
		ctr_wd_air -= 1
		print("This many WDs remain: ", ctr_wd_air)
#		print(ctr_frame_wave_air)
		actual_speed = SPEED_AIR_WAVE_BURST
#
#	if Input.is_action_just_released("wave_burst"):
#		# Ideally use a state machine to track frame counts and resets
#		# Better keep track of prior states
#		ctr_frame_wave_ground = FRAME_WAVE_GROUND
#		ctr_frame_wave_air = FRAME_WAVE_AIR
#
#		actual_speed = SPEED
	if not can_wd_air:
		if ctr_frame_wave_air > 0:
			ctr_frame_wave_air -= 1
		else:
			actual_speed = SPEED
			ctr_frame_wave_air = FRAME_WAVE_AIR
			can_wd_air = true

			
	if not can_wd_gr:
		if ctr_frame_wave_ground > 0:
			ctr_frame_wave_ground -= 1
		else:
			actual_speed = SPEED
			ctr_frame_wave_ground = FRAME_WAVE_GROUND
			can_wd_gr = true
		
#	if direction_snapshot:
#		velocity.x = direction_snapshot.x * actual_speed
#		velocity.y = direction_snapshot.y * actual_speed
##		velocity.z = direction_snapshot.z * actual_speed
	if direction:
			velocity.x = direction.x * actual_speed * sensitivity
#			velocity.y = -direction.y * actual_speed
#			velocity.z = direction.z * actual_speed
	else:
		velocity.x = move_toward(velocity.x, 0, actual_speed)
		velocity.z = move_toward(velocity.z, 0, actual_speed)


	move_and_slide()
