class_name InputManager
extends Node2D

signal move(direction: Vector2)


func _unhandled_input(event: InputEvent):
	if (
		event.is_action("move_up")
		or event.is_action("move_down")
		or event.is_action("move_left")
		or event.is_action("move_right")
	):
		if not event.is_echo():
			var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			move.emit(direction)
