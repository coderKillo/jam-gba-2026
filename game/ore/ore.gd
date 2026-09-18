class_name Ore
extends RefCounted

const DIMENSION = Vector3i(3, 3, 3)

enum CELL { DIRT, GOLD, EMPTY }

var cells := [
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]],
	[[0, 0, 0], [0, 0, 0], [0, 0, 0]]
]

var height := [[3, 3, 3], [3, 3, 3], [3, 3, 3]]


# set_random_cell_to_gold
func set_random():
	var x = randi() % DIMENSION.x
	var y = randi() % DIMENSION.y
	var h = randi() % height[x][y]
	cells[x][y][h - 1] = CELL.GOLD


func empty(pos: Vector2i) -> bool:
	return height[pos.x][pos.y] < 1


func mine(pos: Vector2i):
	height[pos.x][pos.y] -= 1


func paint(pos: Vector2i):
	var h = height[pos.x][pos.y]
	cells[pos.x][pos.y][h - 1] = CELL.GOLD


func is_broken() -> bool:
	var stack_to_break = Global.STACK_EMPTY_TO_BREAK
	if Items.is_active(Items.Type.GLUE):
		stack_to_break += 2
	return empty_stack_count() >= stack_to_break


func empty_stack_count() -> int:
	var count := 0
	for x in DIMENSION.x:
		for y in DIMENSION.y:
			if top_value(Vector2i(x, y)) == CELL.EMPTY:
				count += 1
	return count


func top_value(pos: Vector2i) -> int:
	var h = height[pos.x][pos.y]
	if h < 1:
		return CELL.EMPTY
	return cells[pos.x][pos.y][h - 1]


static func create_random() -> Ore:
	var new_ore = Ore.new()
	new_ore.set_random()
	new_ore.set_random()
	new_ore.set_random()
	new_ore.set_random()
	for x in DIMENSION.x:
		for y in DIMENSION.y:
			new_ore.height[x][y] = randi_range(1, DIMENSION.z)
	return new_ore
