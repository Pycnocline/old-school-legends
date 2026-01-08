extends Node

func output_state() -> void:
	SignalBus.message_output.emit("----------当前状态信息----------")
	SignalBus.message_output.emit("玩家名称：" + Gamedb.player_state.name)
	SignalBus.message_output.emit("所在位置:" + _get_destination_by_id(Gamedb.player_state.position_id).name)
	SignalBus.message_output.emit("地点描述:" + _get_destination_by_id(Gamedb.player_state.position_id).description)
	SignalBus.message_output.emit("------------------------------")

func _get_destination_by_id(id:String) -> Destination:
	for destination in Gamedb.all_destinations:
		if id == destination.id:
			return destination
	return

func look_to_move() -> void:
	SignalBus.message_output.emit("尝试移动...")
	SignalBus.message_output.emit("----------可选移动地址----------")
	var possible_destinations = _get_posible_destinations(Gamedb.player_state.position_id)
	for possible_destination in possible_destinations:
		SignalBus.message_output.emit("移动到：[url=" + possible_destination.connect_to.id + "]" + possible_destination.connect_to.name + "[/url]")

func _get_posible_destinations(id:String) -> Array[DestinationConnect]:
	var possible_destinations: Array[DestinationConnect]
	for des_connect in Gamedb.all_destination_connect:
		if des_connect.connect_from.id == id:
			possible_destinations.append(des_connect)
	return possible_destinations
	
func move_to(id:String) -> void:
	SignalBus.message_output.emit("开始移动...")
	Gamedb.player_state.position_id = id
	SignalBus.message_output.emit("移动完成")
	
func do_game_circle() -> void:
	Gamedb.game_time += 1
	var game_time = Gamedb.get_game_time()
	var hour_minute_str:String = "%02d:%02d" % [game_time.hour, game_time.minute]
	DisplayServer.window_set_title("Old School Legends - Y" + str(game_time.year) + "D" + str(game_time.day) + " " + hour_minute_str)

func set_game_state(state:String) -> void:
	SignalBus.game_circle_timer_control.emit(state)
		
