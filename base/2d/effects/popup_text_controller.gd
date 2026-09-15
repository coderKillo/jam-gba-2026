extends Node

@export var offset := 30.0
@export var time_move := 0.2
@export var time_shrink := 0.5
@export var start_scale := 1.5
@export var scale_delay := 0.2

@export var level_container: Node2D

@export var damage_number_scene: PackedScene


func _ready():
	Events.popup_text.connect(display)


func display(text: String, pos: Vector2, color: Color) -> void:
	var number := damage_number_scene.instantiate() as Node2D

	number.z_index = 5
	number.scale *= start_scale
	number.modulate = color
	number.get_node("Label").text = text

	level_container.add_child(number)
	number.global_position = pos

	var tween = get_tree().create_tween()

	var target_position = number.position.y - offset
	tween.tween_property(number, "position:y", target_position, time_move).set_ease(Tween.EASE_OUT)
	(
		tween
		. tween_property(number, "scale", Vector2.ZERO, time_shrink)
		. set_ease(Tween.EASE_OUT)
		. set_delay(scale_delay)
	)

	await tween.finished
	if is_instance_valid(number):
		number.queue_free()
