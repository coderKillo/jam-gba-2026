extends Node2D

@onready var player: Character = $Player


func _ready():
	$InputManager.move.connect(_on_player_move)
	$MainMenuButton.pressed.connect(_on_main_menu_pressed)


func _on_player_move(direction: Vector2):
	if direction.y < 0:
		player.jump()
	player.move(direction)


func _on_main_menu_pressed():
	SceneManager.load_main_menu()
