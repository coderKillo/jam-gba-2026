extends Node

enum Type {
	SCREWDRIVER,
	GLOVES,
	GLUE,
	GOGGLES,
	WRENCH,
	BRUSH,
}

enum ValueType {
	TIMER,
	COUNTER,
}


class Value:
	var type: ValueType
	var value: float = 0.0

	func _init(_type: ValueType):
		type = _type


var _data = {
	Type.SCREWDRIVER: Value.new(ValueType.TIMER),
	Type.GLOVES: Value.new(ValueType.COUNTER),
	Type.GLUE: Value.new(ValueType.TIMER),
	Type.GOGGLES: Value.new(ValueType.TIMER),
	Type.WRENCH: Value.new(ValueType.TIMER),
	Type.BRUSH: Value.new(ValueType.COUNTER),
}


func _process(delta):
	for value in _data.values():
		if value.type == ValueType.TIMER:
			if value.value > 0.0:
				value.value -= delta


func set_item(type: Type):
	match _data[type].type:
		ValueType.COUNTER:
			_data[type].value += 1.0
		ValueType.TIMER:
			_data[type].value = Global.ITEM_DURATION


func consume_item(type: Type):
	match _data[type].type:
		ValueType.COUNTER:
			_data[type].value -= 1.0
		ValueType.TIMER:
			pass


func is_active(type: Type):
	return _data[type].value > 0.0
