class_name OreSpawner
extends Node2D

var _ores: Array[OreScene]
var to_remove = []


func move():
	for ore in _ores:
		ore.global_position.y -= 1

		if ore.global_position.y < 0.0:
			to_remove.append(ore)
	_resize()


func remove_ore(ore: Ore):
	for scene in _ores:
		if scene.data == ore:
			to_remove.append(scene)
	_resize()


func _resize():
	for scene in to_remove:
		_ores.erase(scene)
		scene.queue_free()
	to_remove.clear()


func spawn(data: Ore, spawn_position: Vector2):
	var ore: OreScene = GlobalResources.ore_scene.instantiate()
	ore.data = data
	add_child(ore)
	ore.global_position = spawn_position
	_ores.append(ore)
