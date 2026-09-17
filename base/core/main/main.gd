class_name Main
extends Control

enum Mode { MOVE, VIEW_ORE, SELECT_ITEM }

@export var level_container: Node
@export var gui: Control

@export_category("Timers")
@export var gun_move_interval := 2.0
@export var ore_spawn_interval := 2.0

@onready var player: Character = $World/Player
@onready var viewer: OreViewer = $OreViewer
@onready var conveyor: ConveyorBelt = $World/ConveyorBelt
@onready var gun: Gun = $World/Gun
@onready var input_manager: InputManager = $Controller/InputManager
@onready var shop_blocker: StaticBody2D = $World/ShopBlocker

var _gun_move_timer := 0.0
var _ore_spawn_timer := 0.0
var _check_index := 0
var _current_mode := Mode.MOVE
var _current_ore: Ore


func _ready():
	input_manager.move.connect(_on_move)
	input_manager.select.connect(_on_select)
	input_manager.interact.connect(_on_interact)

	_open_shop(true)
	player.area_changed.connect(_on_player_area_changed)


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
			if not _current_ore.empty(viewer.selected()):
				_current_ore.dig(viewer.selected())
				Events.camera_shake.emit(0.3)
				Vfx.spawn("explode", viewer.selector.global_position, viewer)
				viewer.display_ore(_current_ore)


func _on_interact():
	match _current_mode:
		Mode.VIEW_ORE:
			print("view")
			_current_mode = Mode.MOVE
			conveyor.put_ore(_current_ore, 6)
			viewer.reset()

		Mode.SELECT_ITEM:
			_current_mode = Mode.MOVE
			viewer.reset()

		Mode.MOVE:
			print("move")
			if player.area == "Workbench":
				_current_mode = Mode.SELECT_ITEM
				viewer.show()

			if player.area.match("Slot?"):
				_current_mode = Mode.VIEW_ORE
				#TODO: remove test
				_current_ore = Ore.new()
				_current_ore.set_random()
				_current_ore.set_random()
				_current_ore.set_random()
				_current_ore.set_random()

				viewer.show()
				viewer.display_ore(_current_ore)
				###


func _on_player_area_changed(area: String):
	if area == "Shop":
		SceneManager.load_shop_scene()
	if area == "Exit":
		SceneManager.load_corridor_scene()


func _on_gun_move_timer_timeout():
	_check_index %= 6
	_check_index += 1
	if _check_index == 3:
		gun.follow_character(player)
	gun.move_to_index(_check_index)


func _on_spawn_ore_timer_timeout():
	var ore = Ore.new()
	ore.set_random()
	ore.set_random()
	ore.set_random()
	ore.set_random()
	conveyor.spawner.spawn(ore)


func _open_shop(open: bool):
	shop_blocker.visible = not open
	shop_blocker.shape_owner_set_disabled(0, open)
