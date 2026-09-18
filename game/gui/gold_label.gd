extends Label


func _ready():
	Events.gold_changed.connect(_on_gold_changed)
	_on_gold_changed()


func _on_gold_changed():
	text = "Gold %s" % GameState.gold
