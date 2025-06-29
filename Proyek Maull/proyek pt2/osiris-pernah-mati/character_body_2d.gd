extends CharacterBody2D


const SPEED= 150
const JUMP_VELOCITY= 200

func _physics_process(delta: float) -> void:

#Gravitasi
if not is_on_floor():
velocity += get_gravity() * delta
