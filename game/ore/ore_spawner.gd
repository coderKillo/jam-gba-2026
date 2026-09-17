class_name OreSpawner
extends Node2D

var _ores: Array[OreScene]


func move():
	var to_remove = []
	for ore in _ores:
		ore.global_position.y -= 1

		if ore.global_position.y < 0.0:
			to_remove.append(ore)

	for ore in to_remove:
		_ores.erase(ore)
		ore.queue_free()


func remove_ore(ore: Ore):
	var scene = _ores.find_custom(func(ore_scene: OreScene): return ore_scene.data == ore)
	if scene:
		_ores.erase(scene)
		scene.queue_free()


func spawn(data: Ore, offset: Vector2 = Vector2.ZERO):
	var ore: OreScene = GlobalResources.ore_scene.instantiate()
	ore.data = data
	add_child(ore)
	ore.global_position = global_position + offset
	_ores.append(ore)
