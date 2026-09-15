class_name TweenAnimation
extends Node

const WIND_UP_TIME = 0.1
const RELEASE_TIME = 0.4


static func create_spring_tween(node: Node, intensity: float) -> Tween:
	var tween = node.get_tree().create_tween()
	(
		tween
		. tween_property(node, "scale", Vector2.ONE * intensity, WIND_UP_TIME)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_EXPO)
	)
	(
		tween
		. tween_property(node, "scale", Vector2.ONE, RELEASE_TIME)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
	return tween


static func create_shake_tween(node: Node, intensity: float) -> Tween:
	var tween = node.get_tree().create_tween()
	(
		tween
		. tween_property(node, "rotation", intensity, WIND_UP_TIME)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_EXPO)
	)
	(
		tween
		. tween_property(node, "rotation", 0.0, RELEASE_TIME)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
	return tween


static func create_fade_in_out_tween(node: CanvasItem, fade_in: float, fade_out: float) -> Tween:
	var tween = node.get_tree().create_tween()
	(
		tween
		. tween_property(
			node,
			"modulate:a",
			1.0,
			fade_in,
		)
		. from(0.0)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_EXPO)
	)
	tween.tween_property(node, "modulate:a", 0.0, fade_out).set_trans(Tween.TRANS_ELASTIC).set_ease(
		Tween.EASE_OUT
	)
	return tween


static func create_wiggle_tween(node: Control, offset: float) -> Tween:
	var current_position = node.position
	var tween = node.get_tree().create_tween()
	(
		tween
		. tween_property(node, "position:y", current_position.y + offset, WIND_UP_TIME)
		. set_ease(Tween.EASE_OUT)
		. set_trans(Tween.TRANS_EXPO)
	)
	(
		tween
		. tween_property(node, "position:y", current_position.y, RELEASE_TIME)
		. set_trans(Tween.TRANS_ELASTIC)
		. set_ease(Tween.EASE_OUT)
	)
	return tween
