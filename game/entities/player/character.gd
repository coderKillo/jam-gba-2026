class_name Character
extends CharacterBody2D

signal area_changed(new_area: String)
signal collide_with_character(character: Character)

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var outline := false

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var suspicion_bar: ProgressBar = $SuspicionBar

var suspicion := 0.0:
	set(value):
		suspicion = clampf(value, 0.0, 100.0)
		suspicion_bar.visible = suspicion > 0.0
		suspicion_bar.value = suspicion

var area: String = "":
	set(value):
		area = value
		area_changed.emit(area)


func _ready():
	if outline:
		animation.material.set_shader_parameter("thickness", 1.0)


func _physics_process(delta):
	if _is_grounded_mode():
		if not is_on_floor():
			velocity += get_gravity() * delta
		else:
			velocity.y = lerp(velocity.y, 0.1, delta)

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var character = collision.get_collider() as Character
		if character:
			collide_with_character.emit(character)


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
