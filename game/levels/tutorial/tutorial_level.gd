extends Node2D

@onready var animation: AnimationPlayer = $Intro/Animation
@onready var tutorial: Control = $Tutorial
@onready
var tutorial_pages: Array[Control] = [$Tutorial/Tutorial1, $Tutorial/Tutorial2, $Tutorial/Tutorial3]
@onready var start_button: Button = $Tutorial/StartButton
@onready var right_arrow: Control = $Tutorial/RightArrow
@onready var left_arrow: Control = $Tutorial/LeftArrow

var page = 0


func _ready():
	start_button.pressed.connect(_on_start_pressed)
	start_button.hide()

	animation.play("intro")
	animation.animation_finished.connect(_on_intro_animation_finished)


func _input(event: InputEvent):
	if not tutorial.visible:
		return

	if event.is_action_pressed("move_right"):
		if page < 3:
			page += 1
			_update_tutorial_page()
		if page == 3:
			start_button.grab_focus.call_deferred()

	if event.is_action_pressed("move_left"):
		if page > 0:
			page -= 1
			_update_tutorial_page()


func _on_start_pressed():
	SceneManager.load_game_scene()


func _on_intro_animation_finished(_animation):
	$Intro.hide()
	tutorial.show()
	_update_tutorial_page()


func _update_tutorial_page():
	left_arrow.visible = page != 0
	tutorial_pages[0].visible = page == 0
	tutorial_pages[1].visible = page == 1
	tutorial_pages[2].visible = page == 2
	right_arrow.visible = page != 3
	start_button.visible = page == 3
