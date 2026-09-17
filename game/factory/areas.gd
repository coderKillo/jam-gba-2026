extends Node2D


func _ready():
	for i in get_child_count():
		var area := get_child(i) as Area2D
		if not area:
			continue
		area.body_entered.connect(_on_body_entered.bind(area.name))
		area.body_exited.connect(_on_body_exited.bind(area.name))


func _on_body_entered(body, area_name: String):
	var character := body as Character
	if not character:
		return
	character.area = area_name


func _on_body_exited(body, _area_name: String):
	var character := body as Character
	if not character:
		return
	character.area = ""
