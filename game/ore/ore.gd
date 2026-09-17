class_name Ore
extends RefCounted

const DIMENSION = Vector3i(3, 3, 3)

enum CELL { DIRT, GOLD, EMPTY }

var cells := [
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]]
]

var depth := [[0, 0, 0], [0, 0, 0], [0, 0, 0]]


# set_random_cell_to_gold
func set_random():
	cells[randi() % DIMENSION.x][randi() % DIMENSION.y][randi() % DIMENSION.z] = CELL.GOLD


func empty(pos: Vector2i) -> bool:
	return depth[pos.x][pos.y] >= DIMENSION.z


func dig(pos: Vector2i):
	depth[pos.x][pos.y] += 1


func top_value(pos: Vector2i) -> int:
	var z = depth[pos.x][pos.y]
	if z >= DIMENSION.z:
		return CELL.EMPTY
	return cells[pos.x][pos.y][z]
