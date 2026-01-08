extends Node

var all_destinations: Array[Destination]
var all_destination_connect: Array[DestinationConnect]
var player_state:PlayerState
var game_time: int = 0

var destination_path:String = "res://resources/destination/"
var destination_connect_path:String = "res://resources/destination_connect/"

func load_all_destinations() -> void:
	SignalBus.message_output.emit("开始注册目的地...")
	var dir = DirAccess.open(destination_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var clean_path = destination_path.path_join(file_name)
				var res = load(clean_path)
				if res is Destination:
					all_destinations.append(res)
					SignalBus.message_output.emit("已注册目的地:" + file_name)
			file_name = dir.get_next()
	SignalBus.message_output.emit("共注册了" + str(all_destinations.size()) + "个目的地")

func load_all_destination_connect() -> void:
	SignalBus.message_output.emit("开始注册目的地连接...")
	var dir = DirAccess.open(destination_connect_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var clean_path = destination_connect_path.path_join(file_name)
				var res = load(clean_path)
				if res is DestinationConnect:
					all_destination_connect.append(res)
					SignalBus.message_output.emit("已注册目的地连接:" + file_name)
			file_name = dir.get_next()
	SignalBus.message_output.emit("共注册了" + str(all_destination_connect.size()) + "个目的地连接")

func load_player_state() -> void:
	SignalBus.message_output.emit("开始注册玩家信息...")
	player_state = load("res://resources/player/player_state.tres")
	SignalBus.message_output.emit("完成玩家信息注册")

func get_game_time() -> Dictionary:
	var year = game_time / 525600
	var day = game_time % 525600 / 1440
	var hour = game_time % 525600 % 1440 / 60
	var minute = game_time % 525600 % 1440 % 60
	var result_time:Dictionary = {
		"year": year,
		"day": day,
		"hour": hour,
		"minute": minute,
	}
	return result_time
