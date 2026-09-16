class_name Character
extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta):
	if _is_grounded_mode():
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			velocity.y = lerp(velocity.y, 0.1, delta)

	move_and_slide()


func move(direction: Vector2):
	if _is_grounded_mode():
		velocity.x = direction.x * speed
	else:
		velocity = direction * speed

	if direction.x > 0:
		animation.flip_h = false
	if direction.x < 0:
		animation.flip_h = true


func jump():
	if is_on_floor() and _is_grounded_mode():
		velocity.y = jump_velocity


func _is_grounded_mode():
	return motion_mode == MotionMode.MOTION_MODE_GROUNDED


func shot():
	pass
