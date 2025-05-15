extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
const DASH_SPEED = 900.0
var tween: Tween
var dash_velocity := 0.0
@onready var sprite_2d = $Sprite2D
#GET THE GRAVITY FROM THE PROJECT SETTINGS TO BE SYNCED WITH RIGIDBODY NODES.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#Animation
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "run"
		
	else:
		sprite_2d.animation = "default"
	
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jump"
		
	#HANDLE JUMP
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("dash") and is_on_floor():
		if tween:
			tween.stop()
			tween = create_tween()
			tween.tween_property(self, "dash_velocity", 0, 0.3).set_ease(Tween.EASE_OUT)
		
	#get the input direction and handle the movement/deceleration.
	#as good practice, you should replace UI actions with custom gameplay action
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * (SPEED + dash_velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	move_and_slide()
	var isleft = velocity.x < 0
	sprite_2d.flip_h = isleft
