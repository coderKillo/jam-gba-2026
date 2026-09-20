class_name SoundController
extends Node

enum { DIALOGUE, SHOOT, MINING, BROKE, CATCH, SELECT, GUN_MOVE, ALARM }

@onready var sounds = {
	DIALOGUE: $Dialogue,
	SHOOT: $Shoot,
	MINING: $Mining,
	BROKE: $Broke,
	CATCH: $Catch,
	GUN_MOVE: $GunMove,
	ALARM: $Alarm,
	SELECT: $Select
}


func _ready():
	Events.play_sound.connect(_on_play_sound)


func _on_play_sound(sound: int):
	if sound not in sounds:
		printerr("sound: '%s' not found" % sound)
		return
	(sounds[sound] as AudioStreamPlayer).pitch_scale = randf_range(0.8, 1.2)
	(sounds[sound] as AudioStreamPlayer).play()
