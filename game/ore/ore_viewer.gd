class_name OreViewer
extends Viewer


func mine(cell: Vector2i):
	Vfx.spawn("explode", cells[cell].global_position, self)


func broke(ore: Ore):
	for x in range(Ore.DIMENSION.x):
		for y in range(Ore.DIMENSION.y):
			var cell = Vector2i(x, y)
			if ore.empty(cell):
				continue
			Vfx.spawn("explode", cells[cell].global_position, self)


func display_ore(ore: Ore):
	display()

	for x in range(Ore.DIMENSION.x):
		for y in range(Ore.DIMENSION.y):
			var cell_pos = Vector2i(x, y)
			cells[cell_pos].frame = ore.top_value(cell_pos)
			cells[cell_pos].label.text = str(ore.height[x][y])
			cells[cell_pos].label.visible = Items.is_active(Items.Type.GOGGLES)
