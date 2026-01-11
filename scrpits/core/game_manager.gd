extends Node

func look_for_item() -> void:
	SignalBus.message_output.emit("寻找可互动物品...")
	SignalBus.message_output.emit("[center]----------可选互动物品----------[/center]")
	for item in Gamedb.player_state.position.item:
		SignalBus.message_output.emit(item.name)
	SignalBus.message_output.emit("[center]------------------------------[/center]")

func do_game_circle() -> void:
	DisplayServer.window_set_title("Old School Legends - " + TimeSystem.get_time_string())

func set_game_state(state:String) -> void:
	SignalBus.game_circle_timer_control.emit(state)
		
