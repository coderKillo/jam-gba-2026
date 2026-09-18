extends OverlaidMenu


func _ready():
	%MainMenu.pressed.connect(_on_main_menu_pressed)
	%Restart.pressed.connect(_on_restart_pressed)
	_fade_in()


func _on_main_menu_pressed():
	SceneManager.load_main_menu()
	close()


func _on_restart_pressed():
	SceneManager.reload_level()
	close()


func _fade_in():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0).from(0.0)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
