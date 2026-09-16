extends Node2D

@onready var start_button: Button = $StartButton
@onready var animation: AnimationPlayer = $Animation


func _ready():
	start_button.pressed.connect(_on_start_pressed)
	start_button.hide()

	animation.play("intro")
	animation.animation_finished.connect(_on_intro_animation_finished)


func _on_start_pressed():
	SceneManager.load_game_scene()


func _on_intro_animation_finished(_animation):
	start_button.show()
