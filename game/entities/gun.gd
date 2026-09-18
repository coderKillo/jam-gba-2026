class_name Gun
extends Node2D

enum Mode { IDLE, DRIVE_TO_INDEX, FOLLOW_CHARACTER, FIRE, DEFECT }

@export var offset := 16
@export var drive_time := 0.3

@onready var _sprite: AnimatedSprite2D = $Sprite
@onready var _projectile: Line2D = $Sprite/Projectile
@onready var _waring: AnimatedSprite2D = $Sprite/Warning
@onready var _flash_overlay: ColorRect = $FlashOverlay

var _current_mode := Mode.IDLE
var _follow: Character


func move_to_index(index: int) -> void:
	if _current_mode != Mode.IDLE:
		return

	_current_mode = Mode.DRIVE_TO_INDEX

	var distance = (offset * index) - _sprite.position.y
	var tween := get_tree().create_tween()
	(
		tween
		. tween_property(_sprite, "position:y", _sprite.position.y + distance * 0.7, drive_time)
		. set_trans(Tween.TRANS_QUAD)
		. set_ease(Tween.EASE_IN)
	)
	(
		tween
		. tween_property(_sprite, "position:y", _sprite.position.y + distance, drive_time)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
	await tween.finished

	_current_mode = Mode.IDLE


func _process(_delta):
	if Items.is_active(Items.Type.WRENCH):
		_sprite.global_position.y = lerp(_sprite.global_position.y, offset / 2.0, 0.1)
		_sprite.rotation_degrees = 90.0
		return

	_sprite.rotation_degrees = 0.0

	if _current_mode != Mode.FOLLOW_CHARACTER or not is_instance_valid(_follow):
		return

	_sprite.global_position.y = lerp(_sprite.global_position.y, _follow.global_position.y, 0.1)
	if abs(_sprite.global_position.y - _follow.global_position.y) < 0.5:
		_shot()


func follow_character(character: Character) -> void:
	_current_mode = Mode.FOLLOW_CHARACTER
	_waring.show()
	await get_tree().create_timer(0.5).timeout
	_follow = character


func _shot():
	if _current_mode != Mode.FOLLOW_CHARACTER:
		return

	_current_mode = Mode.FIRE

	_sprite.play("fire")

	var tween := get_tree().create_tween()
	tween.tween_callback(func(): _sprite.play("fire"))
	tween.tween_interval(0.1)
	tween.tween_callback(func(): _projectile.show())
	tween.tween_callback(func(): TweenAnimation.create_fade_in_out_tween(_flash_overlay, 0.1, 0.2))
	tween.tween_interval(0.3)
	tween.tween_callback(func(): _follow.shot())
	tween.tween_callback(func(): _projectile.hide())
	tween.tween_await(_sprite.animation_finished)
	tween.tween_callback(func(): _sprite.play("idle"))
	await tween.finished

	_current_mode = Mode.IDLE
	_follow = null
	_waring.hide()
