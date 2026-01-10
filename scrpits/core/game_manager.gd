extends Node

func output_state() -> void:
	SignalBus.message_output.emit("[center]----------当前状态信息----------[/center]")
	SignalBus.message_output.emit("玩家名称：" + Gamedb.player_state.name)
	SignalBus.message_output.emit("所在位置:" + Gamedb.player_state.position.name)
	SignalBus.message_output.emit("地点描述:" + Gamedb.player_state.position.description)
	SignalBus.message_output.emit("[center]------------------------------[/center]")


func look_to_move() -> void:
	SignalBus.message_output.emit("尝试移动...")
	SignalBus.message_output.emit("[center]----------可选移动地址----------[/center]")
	var possible_destinations = _get_posible_destinations(Gamedb.player_state.position.id)
	for possible_destination in possible_destinations:
		SignalBus.message_output.emit("移动到：[url=" + possible_destination.connect_to.id + "]" + possible_destination.connect_to.name + "[/url]")
	SignalBus.message_output.emit("[center]------------------------------[/center]")

func look_for_item() -> void:
	SignalBus.message_output.emit("寻找可互动物品...")
	SignalBus.message_output.emit("[center]----------可选互动物品----------[/center]")
	for item in Gamedb.player_state.position.item:
		SignalBus.message_output.emit(item.name)
	SignalBus.message_output.emit("[center]------------------------------[/center]")

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
	DisplayServer.window_set_title("Old School Legends - " + TimeSystem.get_time_string())

func set_game_state(state:String) -> void:
	SignalBus.game_circle_timer_control.emit(state)
		
