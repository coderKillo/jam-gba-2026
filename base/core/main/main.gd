class_name Main
extends Control

enum Mode { MOVE, VIEW_ORE, SELECT_ITEM }

@export var level_container: Node
@export var gui: Control

@export_category("Timers")
@export var gun_move_interval := 2.0
@export var ore_spawn_interval := 2.0

@onready var player: Player = $World/Player
@onready var viewer: OreViewer = $OreViewer
@onready var conveyor: ConveyorBelt = $World/ConveyorBelt
@onready var coworker_group: Node2D = $World/CoworkerGroup
@onready var gun: Gun = $World/Gun
@onready var input_manager: InputManager = $Controller/InputManager
@onready var shop_blocker: StaticBody2D = $World/ShopBlocker
@onready var view_label: Label = $CanvasLayer/Gui/ButtonLabel

var _gun_move_timer := 0.0
var _ore_spawn_timer := 0.0
var _check_index := 0
var _current_mode := Mode.MOVE:
	set(value):
		_current_mode = value
		_update_view_label()
var _current_ore: Ore


func _ready():
	SceneManager.main = self

	input_manager.move.connect(_on_move)
	input_manager.select.connect(_on_select)
	input_manager.interact.connect(_on_interact)

	player.area_changed.connect(_on_player_area_changed)

	conveyor.enter_slot.connect(_on_ore_entered_slot)

	_open_shop(false)

	for child in coworker_group.get_children():
		var coworker := child as Coworker
		if coworker:
			coworker.intrest_cell = Vector2i(randi_range(0, 2), randi_range(0, 2))


func _process(delta):
	_gun_move_timer -= delta
	if _gun_move_timer <= 0.0:
		_on_gun_move_timer_timeout()
		_gun_move_timer = gun_move_interval

	_ore_spawn_timer -= delta
	if _ore_spawn_timer <= 0.0:
		_on_spawn_ore_timer_timeout()
		_ore_spawn_timer = ore_spawn_interval


func _on_move(direction: Vector2):
	match _current_mode:
		Mode.MOVE:
			player.move(direction)
		Mode.VIEW_ORE:
			viewer.move(direction)
		Mode.SELECT_ITEM:
			viewer.move(direction)


func _on_select():
	match _current_mode:
		Mode.VIEW_ORE:
			_current_ore = player.interact(_current_ore, viewer)
			if not _current_ore:
				_current_mode = Mode.MOVE
				viewer.reset()


func _on_interact():
	match _current_mode:
		Mode.VIEW_ORE:
			_current_mode = Mode.MOVE
			conveyor.put_ore(_current_ore, player.slot())
			viewer.reset()

		Mode.SELECT_ITEM:
			_current_mode = Mode.MOVE
			viewer.reset()

		Mode.MOVE:
			if player.area == "Workbench":
				_current_mode = Mode.SELECT_ITEM

			if player.area.match("Slot?"):
				_current_mode = Mode.VIEW_ORE
				_current_ore = Ore.create_random()

				viewer.display_ore(_current_ore)


func _on_ore_entered_slot(ore: Ore, id: int):
	for child in coworker_group.get_children():
		var coworker := child as Coworker
		if coworker.id != id:
			continue
		conveyor.take_ore(ore)
		ore = coworker.inspect(ore)
		if ore:
			conveyor.put_ore(ore, id)


func _on_player_area_changed(area: String):
	if area == "Shop":
		SceneManager.load_shop_scene()
	if area == "Exit":
		SceneManager.load_corridor_scene()
	_update_view_label()


func _on_gun_move_timer_timeout():
	player.gun_checking = false

	_check_index %= 6
	_check_index += 1

	await gun.move_to_index(_check_index)

	for child in coworker_group.get_children():
		var coworker := child as Coworker
		if coworker.suspicion >= Global.SUSPICION_TRESHOLD:
			gun.follow_character(coworker)

	if _check_index == Global.PLAYER_INDEX:
		player.gun_checking = true
		if not player.is_on_slot():
			player.suspicion += Global.SUSPICION_PLAYER_NOT_ON_SLOT

	if player.suspicion >= Global.SUSPICION_TRESHOLD:
		gun.follow_character(player)


func _on_spawn_ore_timer_timeout():
	# no ore spawn
	pass


func _update_view_label():
	if _current_mode == Mode.VIEW_ORE:
		view_label.show()
		view_label.text = "[K] dig   [L] drop"
	elif _current_mode == Mode.MOVE and player.is_on_slot():
		view_label.show()
		view_label.text = "[L] pick up ore"
	else:
		view_label.hide()


func _open_shop(open: bool):
	shop_blocker.visible = not open
	shop_blocker.shape_owner_set_disabled(0, open)
