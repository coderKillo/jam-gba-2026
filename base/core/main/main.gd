class_name Main
extends Control

@export var level_container: Node
@export var gui: Control

@onready var player: Character = $World/Player
@onready var gun: Gun = $World/Gun
@onready var input_manager: InputManager = $Controller/InputManager
@onready var shop_blocker: StaticBody2D = $World/ShopBlocker

var _gun_move_timer: Timer
var _check_index := 0


func _ready():
	input_manager.move.connect(_on_player_move)

	%ExitTrigger.body_entered.connect(_on_exit_entered)
	%ShopTrigger.body_entered.connect(_on_shop_entered)

	_open_shop(true)
	_gun_move_timer = Timer.new()
	add_child(_gun_move_timer)
	_gun_move_timer.start(2.0)
	_gun_move_timer.timeout.connect(_on_gun_move_timer_timeout)


func _on_player_move(direction: Vector2):
	player.move(direction)


func _on_exit_entered(_body):
	SceneManager.load_corridor_scene()


func _on_shop_entered(_body):
	print(_body)
	SceneManager.load_shop_scene()


func _on_gun_move_timer_timeout():
	_check_index %= 6
	_check_index += 1
	if _check_index == 3:
		gun.follow_character(player)
	gun.move_to_index(_check_index)


func _open_shop(open: bool):
	shop_blocker.visible = not open
	shop_blocker.shape_owner_set_disabled(0, open)
