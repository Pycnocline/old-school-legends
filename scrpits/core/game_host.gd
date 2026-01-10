extends Node

func show_info_panel() -> void:
	SignalBus.message_output.emit(" ")
	SignalBus.message_output.emit("[hr]")
	SignalBus.message_output.emit(TimeSystem.get_time_string())
	SignalBus.message_output.emit(Gamedb.player_state.name)
	SignalBus.message_output.emit("当前位置：" + Gamedb.player_state.position.name)
	var data_text: String = ""
	for data in Gamedb.player_state.data:
		data_text += data.name + " " + str(data.value) + "/" + str(data.upper_limit) + " | "
	SignalBus.message_output.emit(data_text)
	SignalBus.message_output.emit("[hr]")
	SignalBus.message_output.emit(" ")
