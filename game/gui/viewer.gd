class_name Viewer
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
var _dimension := Ore.DIMENSION


func _ready():
	_ready_intern()
	reset()


func _ready_intern():
	pass


func _show_intern():
	pass


func _hide_intern():
	pass


func _selection_changed():
	pass


func selected() -> Vector2i:
	return _current_selected_cell


func selected_cell() -> Node2D:
	return cells[_current_selected_cell]


func reset():
	for cell in cells.values():
		cell.hide()
	selector.hide()
	selector.position = Vector2.ZERO
	_current_selected_cell = Vector2i.ZERO
	_selection_changed()
	_hide_intern()


func move(direction: Vector2):
	if abs(direction.x) == 1.0:
		_current_selected_cell.x += roundi(direction.x)
	elif abs(direction.y) == 1.0:
		_current_selected_cell.y += roundi(direction.y)
	else:
		return

	_current_selected_cell.x = posmod(_current_selected_cell.x, _dimension.x)
	_current_selected_cell.y = posmod(_current_selected_cell.y, _dimension.y)
	_selection_changed()
	selector.position = cells[_current_selected_cell].position


func display():
	for cell in cells.values():
		cell.show()
	selector.show()
	_show_intern()
