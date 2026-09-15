class_name Main
extends Control

@export var level_container: Node
@export var gui: Control

@export_category("Debug")
@export var debug_level: PackedScene


func _ready():
	if not is_instance_valid(SceneManager.main) and debug_level:
		await get_tree().root.ready
		SceneManager.load_level_scene(debug_level)
	SceneManager.main = self


func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		Events.level_lose.emit()

	if Input.is_action_just_pressed("ui_down"):
		Events.level_won.emit()
