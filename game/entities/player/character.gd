class_name Character
extends CharacterBody2D

signal area_changed(new_area: String)

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var outline := false

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var suspicion_bar: ProgressBar = $SuspicionBar

var suspicion := 0.0:
	set(value):
		suspicion = value
		suspicion_bar.visible = suspicion > 0.0
		suspicion_bar.value = suspicion

var area: String = "":
	set(value):
		area = value
		area_changed.emit(area)

var _suspicion_decay_timer := 1.0


func _ready():
	if outline:
		animation.material.set_shader_parameter("thickness", 1.0)


func _process(delta):
	_suspicion_decay_timer -= delta
	if _suspicion_decay_timer <= 0.0:
		suspicion -= Global.SUSPICION_DECAY_PER_SEC
		suspicion = clampf(suspicion, 0.0, 100.0)
		_suspicion_decay_timer = 1.0


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
