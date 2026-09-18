class_name Player
extends Character

var stack_count_broke_ore := Global.STACK_EMPTY_TO_BREAK
var gun_checking := false


func interact(ore: Ore, viewer: OreViewer) -> Ore:
	for x in Ore.DIMENSION.x:
		for y in Ore.DIMENSION.y:
			var cell := Vector2i(x, y)
			if ore.empty(cell):
				continue
			if abs(viewer.selected() - cell).length() > 1.0:
				continue

			if ore.top_value(cell) == Ore.CELL.GOLD:
				if gun_checking:
					suspicion += Global.SUSPICION_STOLE_GOLD

				GameState.gold += 1

			ore.dig(cell)
			viewer.dig(cell)

	Events.camera_shake.emit(0.3)
	viewer.display_ore(ore)

	if ore.empty_stack_count() >= stack_count_broke_ore:
		viewer.broke(ore)
		suspicion += Global.SUSPICION_PLAYER_BROKE_ORE
		return null

	return ore


func shot():
	Events.level_lose.emit()


func is_on_slot() -> bool:
	return slot() > 0


func slot() -> int:
	if area.match("Slot?"):
		return int(area[-1])
	return 0
