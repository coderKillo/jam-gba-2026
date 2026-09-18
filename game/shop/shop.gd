class_name ShopViewer
extends Viewer

@onready var description_label: RichTextLabel = $Panel/DescriptionLabel
@onready var panel: Panel = $Panel


func _ready_intern():
	_dimension = Vector3i(3, 2, 1)


func _show_intern():
	panel.show()
	for cell in cells.values():
		if cell.cost <= 0:
			cell.hide()


func _hide_intern():
	panel.hide()


func _selection_changed():
	description_label.text = cells[_current_selected_cell].description
