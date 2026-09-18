class_name Main
extends Control

enum Mode { MOVE, VIEW_ORE, SELECT_ITEM }

@export var level_container: Node
@export var gui: Control

@export_category("Timers")
@export var gun_move_interval := 1.0

@onready var player: Player = $World/Player
@onready var ore_viewer: OreViewer = $OreViewer
@onready var shop_viewer: ShopViewer = $Shop
@onready var conveyor: ConveyorBelt = $World/ConveyorBelt
@onready var coworker_group: Node2D = $World/CoworkerGroup
@onready var gun: Gun = $World/Gun
@onready var input_manager: InputManager = $Controller/InputManager
@onready var shop_blocker: StaticBody2D = $World/ShopBlocker
@onready var view_label: Label = $CanvasLayer/Gui/ButtonLabel

var _gun_move_timer := 0.0
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


func _on_move(direction: Vector2):
	match _current_mode:
		Mode.MOVE:
			player.move(direction)
		Mode.VIEW_ORE:
			ore_viewer.move(direction)
		Mode.SELECT_ITEM:
			shop_viewer.move(direction)


func _on_select():
	match _current_mode:
		Mode.VIEW_ORE:
			_current_ore = player.interact(_current_ore, ore_viewer)
			if not _current_ore:
				_current_mode = Mode.MOVE
				ore_viewer.reset()

		Mode.SELECT_ITEM:
			var item := shop_viewer.selected_cell() as ItemCell
			if item.cost > GameState.gold:
				return
			GameState.gold -= item.cost
			Items.set_item(item.item_type)


func _on_interact():
	match _current_mode:
		Mode.VIEW_ORE:
			_current_mode = Mode.MOVE
			player.suspicion -= Global.SUSPICION_DECAY_PROCESS_ORE
			conveyor.put_ore(_current_ore, player.slot())
			ore_viewer.reset()

		Mode.SELECT_ITEM:
			_current_mode = Mode.MOVE
			shop_viewer.reset()

		Mode.MOVE:
			if player.area == "Workbench":
				_current_mode = Mode.SELECT_ITEM
				shop_viewer.display()

			if player.area.match("Slot?"):
				_current_mode = Mode.VIEW_ORE
				_current_ore = Ore.create_random()
				ore_viewer.display_ore(_current_ore)


func _on_ore_entered_slot(ore: Ore, id: int):
	for child in coworker_group.get_children():
		var coworker := child as Coworker
		if coworker.id != id:
			continue
		conveyor.take_ore(ore)
		ore = coworker.inspect(ore)
		if ore:
			coworker.suspicion -= Global.SUSPICION_DECAY_PROCESS_ORE
			conveyor.put_ore(ore, id)


func _on_player_area_changed(area: String):
	if area == "Shop":
		SceneManager.load_shop_scene()
	if area == "Exit":
		SceneManager.load_corridor_scene()
	_update_view_label()


func _on_gun_move_timer_timeout():
	player.gun_checking = false

	if Items.is_active(Items.Type.WRENCH):
		return

	_check_index %= 6
	_check_index += 1

	await gun.move_to_index(_check_index)

	for child in coworker_group.get_children():
		var coworker := child as Coworker
		if _check_index == coworker.id and not coworker.working:
			coworker.suspicion += Global.SUSPICION_PLAYER_NOT_ON_SLOT
		if coworker.suspicion >= Global.SUSPICION_TRESHOLD:
			gun.follow_character(coworker)
			return

	if _check_index == Global.PLAYER_INDEX:
		player.gun_checking = true
		if not player.is_on_slot():
			player.suspicion += Global.SUSPICION_PLAYER_NOT_ON_SLOT

	if player.suspicion >= Global.SUSPICION_TRESHOLD:
		gun.follow_character(player)
		return


func _update_view_label():
	if _current_mode == Mode.VIEW_ORE:
		view_label.show()
		if Items.is_active(Items.Type.BRUSH):
			view_label.text = "[K] paint   [L] drop"
		else:
			view_label.text = "[K] mine   [L] drop"
	elif _current_mode == Mode.SELECT_ITEM:
		view_label.show()
		view_label.text = "[K] buy   [L] close"
	elif _current_mode == Mode.MOVE and player.is_on_slot():
		view_label.show()
		view_label.text = "[L] pick up ore"
	elif _current_mode == Mode.MOVE and player.area == "Workbench":
		view_label.show()
		view_label.text = "[L] open workbench"
	else:
		view_label.hide()


func _open_shop(open: bool):
	shop_blocker.visible = not open
	shop_blocker.shape_owner_set_disabled(0, open)
