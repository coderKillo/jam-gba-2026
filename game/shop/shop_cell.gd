class_name ItemCell
extends Sprite2D

@export var item_type: Items.Type
@export var cost: int
@export_multiline() var description: String

@onready var label = $Label


func _ready():
	label.text = str(cost)
