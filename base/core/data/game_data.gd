class_name GameData
extends Resource

@export var version_opened: String
@export var level_data: Dictionary = {}
@export var max_level_reached: int
@export var current_level: int
@export var gold: int = 0
@export var coworkers: int = Global.COWORKER_INIT_NUMBER
@export var items: Array[String] = []
