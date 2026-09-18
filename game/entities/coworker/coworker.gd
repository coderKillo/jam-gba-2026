class_name Coworker
extends Character

@export var id := 0

@onready var dialog_label: Label = $Dialog
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var dialog_tween: Tween

var intrest_cell := Vector2i.ZERO
var working := true


func inspect(ore: Ore) -> Ore:
	if not working:
		return ore

	match ore.top_value(intrest_cell):
		Ore.CELL.EMPTY:
			dialog("Damn, it's empty")
		Ore.CELL.GOLD:
			ore.mine(intrest_cell)
			suspicion += Global.SUSPICION_STOLE_GOLD
		Ore.CELL.DIRT:
			ore.mine(intrest_cell)

	if ore.is_broken():
		dialog("Oh, I broke it")
		return null
	return ore


func shot():
	GameState.coworkers -= 1
	queue_free()


func dialog(text: String):
	if dialog_tween:
		dialog_tween.kill()
	dialog_tween = get_tree().create_tween()
	dialog_label.visible_ratio = 0.0
	dialog_label.text = text
	dialog_label.show()
	dialog_tween.tween_property(dialog_label, "visible_ratio", 1.0, 1.0)
	dialog_tween.tween_interval(2.0)
	await dialog_tween.finished
	dialog_label.hide()


func knockout(time: float):
	working = false
	sprite.rotation_degrees = -90.0
	await get_tree().create_timer(time).timeout
	working = true
	sprite.rotation_degrees = 0
