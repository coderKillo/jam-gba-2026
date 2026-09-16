extends Node2D

@onready var player: Character = $Player


func _ready():
	$InputManager.move.connect(_on_player_move)
	$CoworkerTrigger.body_entered.connect(_on_coworker_triggered)
	$ExitTrigger.body_entered.connect(_on_exit_triggered)


func _on_player_move(direction: Vector2):
	if direction.y < 0:
		player.jump()
	player.move(direction)


func _on_coworker_triggered(_body: Character):
	print("spawn cowoker")


func _on_exit_triggered(_body: Character):
	SceneManager.load_end_scene()
