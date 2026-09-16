extends Node

const SINGLE_GAME_SCENE = true

@onready var scene_resource: SceneResource = preload("res://base/core/scenes/scenes.tres")

var main: Main
var current_level: Node

var _transition: Control
var _in_transition = false


func _ready():
	Events.level_won.connect(_on_game_won)
	Events.level_lose.connect(_on_game_lose)

	var transition = scene_resource.transition.instantiate()
	add_child(transition)
	_transition = transition.get_node("Transition")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_pause_game()


func load_game_scene():
	_change_scene_to_main(scene_resource.main_scene)


func load_corridor_scene():
	_change_scene_to_menu(scene_resource.corridor_scene)


func load_tutorial_scene():
	_change_scene_to_menu(scene_resource.tutorial_scene)


func load_shop_scene():
	_change_scene_to_menu(scene_resource.shop_scene)


func load_end_scene():
	_change_scene_to_menu(scene_resource.end_scene)


func load_main_menu():
	_change_scene_to_menu(scene_resource.main_menu)


func reload_level():
	if SINGLE_GAME_SCENE:
		load_game_scene()
		return

	load_level(GameState.get_current_level())


func advance_level():
	if SINGLE_GAME_SCENE:
		load_game_scene()
		return

	var next_level = GameState.get_current_level() + 1
	if next_level >= level_size():
		return

	load_level(next_level)


func level_size() -> int:
	return scene_resource.levels.size()


func load_level(level: int):
	if SINGLE_GAME_SCENE:
		load_game_scene()
		return

	assert(level < level_size())
	GameState.set_current_level(level)
	load_level_scene(scene_resource.levels[level])


func load_level_scene(level_scene: PackedScene):
	if SINGLE_GAME_SCENE:
		load_game_scene()
		return

	var callback = func(scene):
		if not is_instance_valid(main):
			load_game_scene()

		if is_instance_valid(current_level):
			current_level.queue_free()
			current_level = null

		current_level = scene.instantiate()

		if is_instance_valid(main.level_container):
			main.level_container.call_deferred("add_child", current_level)
		else:
			main.call_deferred("add_child", current_level)

	_transition_callback(callback.bind(level_scene))


### TRANSITION HELPER ###


func _change_scene_to_main(main_scene: PackedScene):
	var callback = func(scene):
		main = scene.instantiate()
		var tree = get_tree()
		var current_scene = tree.current_scene

		tree.root.add_child(main)
		tree.root.remove_child(current_scene)
		current_scene.queue_free()
		tree.current_scene = main

	if SINGLE_GAME_SCENE:
		_transition_callback(callback.bind(main_scene))
	else:
		callback.call(main_scene)


func _change_scene_to_menu(menu_scene: PackedScene):
	var callback = func(scene):
		get_tree().change_scene_to_packed(scene)
		main = null

	_transition_callback(callback.bind(menu_scene))


func _transition_callback(callback: Callable):
	if _in_transition:
		return
	_in_transition = true
	await _do_transition(true)
	callback.call()
	await _do_transition(false)
	_in_transition = false


### OVERLAY MENU ###


func _on_game_won():
	_overlay_menu(scene_resource.win_menu)


func _on_game_lose():
	_overlay_menu(scene_resource.lose_menu)


func _pause_game():
	_overlay_menu(scene_resource.pause_menu)


func _overlay_menu(menu: PackedScene) -> void:
	if not is_instance_valid(main):
		return

	var scene = menu.instantiate()
	main.gui.add_child(scene)


### TRANSITION ###


# wait for transition to be finished
func _do_transition(transition_in: bool) -> void:
	const SHADER_HEIGHT_IN = 1.0
	const SHADER_HEIGHT_OUT = -1.0
	var transition_time = 1.0

	var tween := get_tree().create_tween()
	var to = SHADER_HEIGHT_IN if transition_in else SHADER_HEIGHT_OUT
	var from = SHADER_HEIGHT_OUT if transition_in else SHADER_HEIGHT_IN
	var duration = transition_time / 2.0

	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(_transition, "material:shader_parameter/height", to, duration).from(from)

	await tween.finished
