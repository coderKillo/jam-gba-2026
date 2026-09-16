extends Node2D


func _ready():
	$NextShiftButton.pressed.connect(_on_next_shift_pressed)


func _on_next_shift_pressed():
	SceneManager.load_game_scene()
