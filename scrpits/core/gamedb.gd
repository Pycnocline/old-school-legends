extends Node

var all_destinations: Array[Destination] = []
var all_destination_connect: Array[DestinationConnect] = []
var all_items: Dictionary[String, Item] = {}
var player_state:PlayerState

var destination_path:String = "res://resources/destination/"
var destination_connect_path:String = "res://resources/destination_connect/"

func load_all_destinations() -> void:
	SignalBus.message_output.emit("开始注册目的地...")
	var dir = DirAccess.open(destination_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			file_name = file_name.replace(".remap", "")
			if file_name.ends_with(".tres"):
				var clean_path = destination_path.path_join(file_name)
				var res = load(clean_path)
				if res is Destination:
					all_destinations.append(res)
					SignalBus.message_output.emit("已注册目的地:" + file_name)
					for i in range(res.item.size()):
						var item = res.item[i].duplicate()
						var id_int = ResourceUID.create_id()
						item.id = str(id_int)
						all_items[item.id] = item
						res.item[i] = item
						SignalBus.message_output.emit("已注册目的地物品" + item.id)
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
	SignalBus.message_output.emit(player_state.position.name)
	SignalBus.message_output.emit("完成玩家信息注册")
