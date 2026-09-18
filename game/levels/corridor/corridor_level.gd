extends Node2D

@onready var player: Character = $Player

var _spawn_position: Vector2
var _coworkers: Array[Character] = []


func _ready():
	$InputManager.move.connect(_on_player_move)
	$CoworkerTrigger.body_entered.connect(_on_coworker_triggered)
	$ExitTrigger.body_entered.connect(_on_exit_triggered)

	_spawn_position = player.global_position


func _physics_process(_delta):
	for worker in _coworkers:
		if abs(worker.global_position.x - player.global_position.x) < 1.0:
			worker.speed = 10.0
			worker.move(Vector2.RIGHT)
			SceneManager.load_game_scene()


func _on_player_move(direction: Vector2):
	if direction.y < 0:
		player.jump()
	player.move(direction)


func _on_coworker_triggered(_body: Character):
	call_deferred("_spawn_coworkers")


func _on_exit_triggered(_body: Character):
	SceneManager.load_end_scene()


func _spawn_coworkers():
	for i in GameState.coworkers:
		var character := GlobalResources.character_scene.instantiate() as Character
		add_child(character)
		character.global_position = _spawn_position
		character.speed = randi_range(40, 60)
		character.move(Vector2.RIGHT)
		_coworkers.append(character)
