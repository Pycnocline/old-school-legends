class_name PlayerData
extends Resource

@export_category("玩家数据")
@export var id: String
@export var name: String
@export var description: String
@export var lower_limit: int
@export var upper_limit: int
@export var value: int

func check_limit() -> void:
	if value > upper_limit:
		value = upper_limit
		SignalBus.player_data_signal.emit(id, true)
	elif value < lower_limit:
		value = lower_limit
		SignalBus.player_data_signal.emit(id, false)
