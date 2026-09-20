class_name Player
extends Character

var stack_count_broke_ore := Global.STACK_EMPTY_TO_BREAK
var gun_checking := false


func _ready():
	super._ready()
	collide_with_character.connect(_on_collide)


func interact(ore: Ore, viewer: OreViewer) -> Ore:
	if Items.is_active(Items.Type.BRUSH):
		if ore.top_value(viewer.selected()) == Ore.CELL.DIRT:
			Items.consume_item(Items.Type.BRUSH)
			Events.play_sound.emit(SoundController.SELECT)
			Events.camera_shake.emit(0.3)
			viewer.display_ore(ore)
		return

	var distance = 0.0 if Items.is_active(Items.Type.SCREWDRIVER) else 1.0
	for x in Ore.DIMENSION.x:
		for y in Ore.DIMENSION.y:
			var cell := Vector2i(x, y)
			if ore.empty(cell):
				continue
			if abs(viewer.selected() - cell).length() > distance:
				continue

			if ore.top_value(cell) == Ore.CELL.GOLD:
				if gun_checking:
					suspicion += Global.SUSPICION_STOLE_GOLD

				GameState.gold += 1

			Events.play_sound.emit(SoundController.MINING)

			ore.mine(cell)
			viewer.mine(cell)

	Events.camera_shake.emit(0.3)
	viewer.display_ore(ore)

	if ore.is_broken():
		Events.play_sound.emit(SoundController.BROKE)
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


func _on_collide(character: Character):
	if Items.is_active(Items.Type.GLOVES):
		if not character.working:
			return
		character.knockout(Global.KNOCKOUT_TIME)
		Items.consume_item(Items.Type.GLOVES)
