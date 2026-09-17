class_name InputManager
extends Node2D

signal move(direction: Vector2)
signal select
signal interact


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

	if event.is_action_pressed("select"):
		select.emit()

	if event.is_action_pressed("interact"):
		interact.emit()
