class_name OreViewer
extends Node2D

@onready var cells = {
	Vector2i(0, 0): $Cells/Cell1,
	Vector2i(1, 0): $Cells/Cell2,
	Vector2i(2, 0): $Cells/Cell3,
	Vector2i(0, 1): $Cells/Cell4,
	Vector2i(1, 1): $Cells/Cell5,
	Vector2i(2, 1): $Cells/Cell6,
	Vector2i(0, 2): $Cells/Cell7,
	Vector2i(1, 2): $Cells/Cell8,
	Vector2i(2, 2): $Cells/Cell9,
}
@onready var selector: Node2D = $Selector

var _current_selected_cell := Vector2i.ZERO


func _ready():
	reset()


func reset():
	hide()
	selector.position = Vector2.ZERO


func move(direction: Vector2):
	if abs(direction.x) == 1.0:
		_current_selected_cell.x += roundi(direction.x)
	elif abs(direction.y) == 1.0:
		_current_selected_cell.y += roundi(direction.y)
	else:
		return

	_current_selected_cell.x = posmod(_current_selected_cell.x, Ore.DIMENSION.x)
	_current_selected_cell.y = posmod(_current_selected_cell.y, Ore.DIMENSION.y)
	selector.position = cells[_current_selected_cell].position


func selected() -> Vector2i:
	return _current_selected_cell


func display_ore(ore: Ore):
	for x in range(Ore.DIMENSION.x):
		for y in range(Ore.DIMENSION.y):
			var cell_pos = Vector2i(x, y)
			cells[cell_pos].frame = ore.top_value(cell_pos)
