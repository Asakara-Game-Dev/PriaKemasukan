extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -900.0
const DASH_SPEED = 1000
const MAX_DASH_TIME = 0.2

var dashing = false
var dash_time = 0.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_2d = $Sprite2D

func _physics_process(delta):
	# Menangani input dash
	if Input.is_action_just_pressed("dash") and is_moving() and not dashing:
		dashing = true
		dash_time = 0.0
		
		var dash_direction = 1 if Input.get_axis("left", "right") > 0 else -1
		velocity.x = dash_direction * DASH_SPEED
		print("Dash dimulai dengan velocity.x:", velocity.x)

	if dashing:
		dash_time += delta
		velocity.y += gravity * delta
		velocity.x = velocity.x
		
		_set_animation("dashing")
		if dash_time >= MAX_DASH_TIME:
			dashing = false
			dash_time = 0.0
			print("Dash selesai")
			velocity.x = 0

	else:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction = Input.get_axis("left", "right")
		if direction != 0:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if not is_on_floor():
			velocity.y += gravity * delta

		# Set animasi berdasarkan keadaan
		if not is_on_floor():
			_set_animation("jumping")
		elif abs(velocity.x) > 1:
			_set_animation("running")
		else:
			_set_animation("idle")

	move_and_slide()


	sprite_2d.flip_h = velocity.x < 0


func is_moving() -> bool:
	return abs(velocity.x) > 0.1


var current_animation = ""

func _set_animation(anim_name: String) -> void:
	if current_animation == anim_name:
		return
	current_animation = anim_name
	sprite_2d.play(anim_name)
