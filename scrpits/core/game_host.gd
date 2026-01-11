extends Node

var last_control_time_stamp: int = int(Time.get_unix_time_from_system())

var heading_desination_id: String
var reached_time: int

func _ready() -> void:
	SignalBus.text_meta_clicked.connect(handle_text_click)

func show_info_panel() -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	
	SignalBus.message_output.emit("[hr]")
	SignalBus.message_output.emit(TimeSystem.get_time_string() + "  -  " + Gamedb.player_state.position.name)
	SignalBus.message_output.emit("▼[队伍状态信息]--------------------")
	var data_text: String = "    >> " + Gamedb.player_state.name + "    "
	for data in Gamedb.player_state.data:
		data_text += data.name + " " + str(data.value) + "/" + str(data.upper_limit) + " | "
	SignalBus.message_output.emit(data_text)
	SignalBus.message_output.emit("▼[可用行动列表]--------------------")
	
	var available_action: Array = [
		"[url=" + str(last_control_time_stamp) + "/gamehost/move][wave]>> 移动 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/gamehost/wait][wave]>> 等待 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/gamehost/pause][wave]>> 暂停 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/gamehost/bag][wave]>> 背包 <<[/wave][/url]",
		"[url=" + str(last_control_time_stamp) + "/gamehost/lookaround][wave]>> 观察四周 <<[/wave][/url]",
	]
	
	var object = 0
	var action_text:String = "    "
	for action in available_action:
		object += 1
		action_text += action + "          "
		if object % 4 == 0:
			SignalBus.message_output.emit(action_text)
			action_text = "    "
	if action_text != "    ":
		SignalBus.message_output.emit(action_text)

func look_to_move() -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	
	SignalBus.message_output.emit("[hr]")
	SignalBus.message_output.emit(Gamedb.player_state.name + "看了看四周，寻找能移动到的目的地...")
	
	var possible_destinations = get_posible_destinations(Gamedb.player_state.position.id)
	if possible_destinations == []:
		SignalBus.message_output.emit("但是并没有发现可以前往的地方！")
	else:
		SignalBus.message_output.emit("要去哪里呢？")
		var object = 0
		var des_text:String = "    "
		for possible_destination in possible_destinations:
			object += 1
			des_text += "[url=" + str(last_control_time_stamp) + "/gamehost/moveto/"+ possible_destination.id + "][wave]>> " + possible_destination.name + " <<[/wave][/url]" + "          "
			if object % 3 == 0:
				SignalBus.message_output.emit(des_text)
				des_text = "    "
			if des_text != "    ":
				SignalBus.message_output.emit(des_text)
		SignalBus.message_output.emit("    [url=" + str(last_control_time_stamp) + "/gamehost/info][wave]>> 返回 <<[/wave][/url]")
		

func try_to_move(id:String) -> void:
	var des = get_destination_by_id(id)
	SignalBus.message_output.emit(Gamedb.player_state.name + "起身准备前往" + des.name + "...")
	var check_destinations = get_posible_destinations(Gamedb.player_state.position.id)
	var checked = false
	for destination in check_destinations:
		if destination.id == id:
			checked = true
			break
	if not checked:
		SignalBus.message_output.emit("但是可能是因为时间变动，[color=red]现在好像[shake]没法[/shake]前往" + des.name + "[/color]")
		show_info_panel()
	else:
		SignalBus.message_output.emit("[color=green][pulse]正在前往" + des.name + "[/pulse][/color]")
		heading_desination_id = id
		reached_time = get_connect(Gamedb.player_state.position.id, id)[0].travel_time
		SignalBus.time_ticked.connect(update_moving)
		
	
func update_moving() -> void:
	reached_time -= 1
	if reached_time <= 0:
		SignalBus.time_ticked.disconnect(update_moving)
		Gamedb.player_state.position = get_destination_by_id(heading_desination_id)
		SignalBus.message_output.emit(Gamedb.player_state.name + "到达了目的地！")
		show_info_panel()
		



func get_posible_destinations(id:String) -> Array[Destination]:
	var possible_destinations: Array[Destination]
	for des_connect in Gamedb.all_destination_connect:
		if des_connect.connect_from.id == id:
			possible_destinations.append(des_connect.connect_to)
	return possible_destinations

func get_connect(fromid:String, toid:String) -> Array[DestinationConnect]:
	var possible_connects: Array[DestinationConnect]
	for des_connect in Gamedb.all_destination_connect:
		if des_connect.connect_from.id == fromid and des_connect.connect_to.id == toid:
			possible_connects.append(des_connect)
	return possible_connects

func get_destination_by_id(id:String) -> Destination:
	for des in Gamedb.all_destinations:
		if des.id == id:
			return des
	return

func handle_text_click(meta) -> void:
	if meta[1] != "gamehost":
		return
	
	match meta[2]:
		"move":
			look_to_move()
		"moveto":
			try_to_move(meta[3])
		"info":
			show_info_panel()
