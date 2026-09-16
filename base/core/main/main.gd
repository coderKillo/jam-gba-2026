class_name Main
extends Control

@export var level_container: Node
@export var gui: Control

@onready var player: Character = $World/Player
@onready var input_manager: InputManager = $Controller/InputManager
@onready var shop_blocker: StaticBody2D = $World/ShopBlocker


func _ready():
	input_manager.move.connect(_on_player_move)

	%ExitTrigger.body_entered.connect(_on_exit_entered)
	%ShopTrigger.body_entered.connect(_on_shop_entered)

	_open_shop(true)


func _on_player_move(direction: Vector2):
	player.move(direction)


func _on_exit_entered(_body):
	SceneManager.load_corridor_scene()


func _on_shop_entered(_body):
	print(_body)
	SceneManager.load_shop_scene()


func _open_shop(open: bool):
	shop_blocker.visible = not open
	shop_blocker.shape_owner_set_disabled(0, open)
