class_name ConveyorBelt
extends AnimatedSprite2D

const INTERVAL_TIME := 0.2

signal enter_slot(ore: Ore, id: int)

@export var tolerance := 2.0
@export var slot_space := 16.0
@export var slot_offset := -59.0

@onready var spawner: OreSpawner = $OreSpawner

var _timer := 0.0


func _process(delta):
	_timer -= delta
	if _timer < 0.0:
		spawner.move()
		_check_slot()
		_timer = INTERVAL_TIME


func take_ore(ore: Ore):
	spawner.remove_ore(ore)


func put_ore(ore: Ore, id: int):
	spawner.spawn(ore, _get_position(id))


func _check_slot():
	for ore in spawner._ores:
		var local_position = to_local(ore.global_position)
		var distance_to_reference = local_position.y - slot_offset - tolerance
		if fmod(distance_to_reference, slot_space) == 0.0:
			var id = floori(distance_to_reference / slot_space)
			enter_slot.emit(ore.data, id)


func _get_position(id: int):
	var _offset = Vector2(0.0, slot_offset + (slot_space * id))
	return global_position + _offset
