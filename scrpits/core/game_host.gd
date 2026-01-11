extends Node

var last_control_time_stamp: int = Time.get_unix_time_from_system()

var available_action: Array = [
		"[url=" + str(last_control_time_stamp) + "/0][wave]>> 移动 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/1][wave]>> 等待 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/2][wave]>> 暂停 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/3][wave]>> 背包 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/4][wave]>> 观察四周 <<[/wave][/url]",
	]

func show_info_panel() -> void:
	last_control_time_stamp = Time.get_unix_time_from_system()
	
	SignalBus.message_output.emit("[hr]")
	SignalBus.message_output.emit(TimeSystem.get_time_string() + "  -  " + Gamedb.player_state.position.name)
	SignalBus.message_output.emit("▼[队伍状态信息]--------------------")
	var data_text: String = "    >> " + Gamedb.player_state.name + "    "
	for data in Gamedb.player_state.data:
		data_text += data.name + " " + str(data.value) + "/" + str(data.upper_limit) + " | "
	SignalBus.message_output.emit(data_text)
	SignalBus.message_output.emit("▼[可用行动列表]--------------------")
	
	var object = 0
	var action_text:String = "    "
	for action in available_action:
		object += 1
		action_text += action + "          "
		if object % 4 == 0:
			SignalBus.message_output.emit(action_text)
			action_text = "    "
	if action_text != "":
		SignalBus.message_output.emit(action_text)
	
	
