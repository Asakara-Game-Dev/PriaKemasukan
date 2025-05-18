extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -900.0
var dashing = false
var dash_time = 0.0
var max_dash_time = 0.2 
const DASH_SPEED = 1000
@onready var sprite_2d = $Sprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Debug print 
	if Input.is_action_just_pressed("dash"):
		print("Dash input detected")

	# HANDLE DASH
	if Input.is_action_just_pressed("dash") and is_moving() and not dashing:
		dash_time = 0
		dashing = true
		var dash_direction = 1 if Input.get_axis("left", "right") > 0 else -1
		velocity.x = DASH_SPEED * dash_direction
		print("Dash started with velocity.x: ", velocity.x)

	if dashing:
		dash_time += delta
		velocity.y += gravity * delta 
		velocity.x = velocity.x 
		if dash_time >= max_dash_time:
			dashing = false
			dash_time = 0
			print("Dash ended")
			velocity.x = 0 

	else:
		# Jika tidak dash, bisa lompat dan gerak normal
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("left", "right")
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		# Tambah gravitasi
		if not is_on_floor():
			velocity.y += gravity * delta

	# Set animasi
	if not is_on_floor():
		sprite_2d.animation = "jumping"
	elif abs(velocity.x) > 1:
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"

	move_and_slide()

	sprite_2d.flip_h = velocity.x < 0


func is_moving() -> bool:
	return abs(velocity.x) > 0.1
