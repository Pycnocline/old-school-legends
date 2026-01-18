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
	
	SignalBus.message_output.emit("▼[场景中的角色]--------------------")
	var data_text: String = "    >> " + Gamedb.player_state.name + "    "
	for data in Gamedb.player_state.data:
		data_text += data.name + " " + str(data.value) + "/" + str(data.upper_limit) + " | "
	SignalBus.message_output.emit(data_text)
	
	for character in Gamedb.get_character_by_destination_id(Gamedb.player_state.position.id):
		SignalBus.message_output.emit("    [url=%s/%s/gamehost/interactcharacter/%s][wave]>> %s[/wave][/url]" % [character.name, str(last_control_time_stamp), character.id, character.name])
	
	SignalBus.message_output.emit("▼[可用行动列表]--------------------")
	
	var available_action: Array = [
		"[url=" + "移动/" + str(last_control_time_stamp) + "/gamehost/move][wave]>> 移动 <<[/wave][/url]",
		"[url=" + "等待/" + str(last_control_time_stamp) + "/gamehost/wait][wave]>> 等待 <<[/wave][/url]",
		"[url=" + "暂停/" + str(last_control_time_stamp) + "/gamehost/pause][wave]>> 暂停 <<[/wave][/url]",
		"[url=" + "背包/" + str(last_control_time_stamp) + "/gamehost/bag][wave]>> 背包 <<[/wave][/url]",
		"[url=" + "观察四周/" + str(last_control_time_stamp) + "/gamehost/lookaround][wave]>> 观察四周 <<[/wave][/url]",
	]
	
	var object = 0
	var action_text:String = "    "
	for action in available_action:
		object += 1
		action_text += action + "          "
		if object % 5 == 0:
			SignalBus.message_output.emit(action_text)
			action_text = "    "
	if action_text != "    ":
		SignalBus.message_output.emit(action_text)

func look_to_move() -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	
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
			des_text += "[url=" + possible_destination.name + "/" + str(last_control_time_stamp) + "/gamehost/moveto/"+ possible_destination.id + "][wave]>> " + possible_destination.name + " <<[/wave][/url]" + "          "
			if object % 3 == 0:
				SignalBus.message_output.emit(des_text)
				des_text = "    "
		if des_text != "    ":
			SignalBus.message_output.emit(des_text)
		SignalBus.message_output.emit("    [url="+ "返回"  + "/" + str(last_control_time_stamp) + "/gamehost/info][wave]>> 返回 <<[/wave][/url]")
		

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

func pause_game() -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	SignalBus.game_circle_timer_control.emit("pause")
	SignalBus.message_output.emit("[color=yellow][pulse]游戏已暂停...[/pulse][/color]")
	SignalBus.message_output.emit("    [url=回到游戏/" + str(last_control_time_stamp) + "/gamehost/unpause][wave]>> 回到游戏 <<[/wave][/url]")
	
func unpause_game() -> void:
	SignalBus.game_circle_timer_control.emit("roaming")
	SignalBus.message_output.emit("[color=green]游戏继续[/color]")
	show_info_panel()

func look_around() -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	SignalBus.message_output.emit(Gamedb.player_state.name + "观察了一下周围的环境...")
	SignalBus.message_output.emit("▼[当前地图信息]--------------------")
	SignalBus.message_output.emit(Gamedb.player_state.position.description)
	SignalBus.message_output.emit("▼[附近可互动物]--------------------")
	
	var object = 0
	var item_text = "    "
	for item in Gamedb.player_state.position.item:
		object += 1
		item_text += "[url=%s/%s/gamehost/lookitem/%s][wave]>> %s <<[/wave][/url]" % [item.name, last_control_time_stamp, item.id, item.name]
		if object % 5 == 0:
			SignalBus.message_output.emit(item_text)
			item_text = "    "
	if item_text != "    ":
		SignalBus.message_output.emit(item_text)
	
	if object == 0:
		SignalBus.message_output.emit("附近没有可互动的物品")
	SignalBus.message_output.emit("    [url="+ "返回"  + "/" + str(last_control_time_stamp) + "/gamehost/info][wave]>> 返回 <<[/wave][/url]")

func look_item(id:String) -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	var item = Gamedb.all_items[id]
	SignalBus.message_output.emit("%s凑近看了看%s..." % [Gamedb.player_state.name, item.name])
	SignalBus.message_output.emit("▼[物品信息]--------------------")
	SignalBus.message_output.emit("物品名称：%s" %[item.name])
	SignalBus.message_output.emit("描述：%s" %[item.description])
	SignalBus.message_output.emit("价格：%s" %[item.price])
	SignalBus.message_output.emit("▼[可执行操作]--------------------")
	
	var object = 0
	var action_text = "    "
	for action in item.action:
		if item.is_in_bag == item.action[action].required_in_bag or item.is_in_destination == item.action[action].required_in_destination:
			object += 1
			action_text += "[url=%s/%s/gamehost/interactitem/%s/%s][wave]>> %s <<[/wave][/url]" % [action, last_control_time_stamp, item.id, action, action] + "          "
			if object % 5 == 0:
				SignalBus.message_output.emit(action_text)
				action_text = "    "

	if action_text != "    ":
		SignalBus.message_output.emit(action_text)
	SignalBus.message_output.emit("    [url="+ "返回"  + "/" + str(last_control_time_stamp) + "/gamehost/info][wave]>> 返回 <<[/wave][/url]")

func do_item_action(itemid:String, actionname:String) -> void:
	var item = Gamedb.all_items[itemid]
	item.action[actionname].execute(Gamedb.player_state, item, Gamedb.player_state.position, actionname)

func open_bag() -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	SignalBus.message_output.emit("打开了背包...")
	SignalBus.message_output.emit("要查看哪个类别的物品呢？")
	var type_text = [
		"    [url=消耗品/%s/gamehost/checkbag/0][wave]>> 消耗品 <<[/wave][/url]" % [last_control_time_stamp],
		"          [url=素材/%s/gamehost/checkbag/1][wave]>> 素材 <<[/wave][/url]" % [last_control_time_stamp],
		"          [url=道具/%s/gamehost/checkbag/2][wave]>> 道具 <<[/wave][/url]" % [last_control_time_stamp],
		"          [url=重要物品/%s/gamehost/checkbag/3][wave]>> 重要物品 <<[/wave][/url]" % [last_control_time_stamp],
		"          [url=装备/%s/gamehost/checkbag/4][wave]>> 装备 <<[/wave][/url]" % [last_control_time_stamp],
	]
	
	var output_text:String = ""
	for text in type_text:
		output_text += text
	SignalBus.message_output.emit(output_text)
	SignalBus.message_output.emit("    [url="+ "返回"  + "/" + str(last_control_time_stamp) + "/gamehost/info][wave]>> 返回 <<[/wave][/url]")

func check_bag(type:int) -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	
	var type_text:String = ""
	match type:
		0:
			type_text = "消耗品"
		1:
			type_text = "素材"
		2:
			type_text = "道具"
		3:
			type_text = "重要物品"
		4:
			type_text = "装备"
	
	SignalBus.message_output.emit("▼[背包里的%s]--------------------" % [type_text])
	
	var object = 0
	var item_text = "    "
	for item in Gamedb.player_state.bag:
		if item.type == type:
			object += 1
			item_text += "[url=%s/%s/gamehost/lookitem/%s][wave]>> %s <<[/wave][/url]" % [item.name, last_control_time_stamp, item.id, item.name]
			if object % 5 == 0:
				SignalBus.message_output.emit(item_text)
				item_text = "    "
	if item_text != "    ":
		SignalBus.message_output.emit(item_text)
	
	if object == 0:
		SignalBus.message_output.emit("    没有在背包里找到这个种类的物品")
	
	SignalBus.message_output.emit("    [url="+ "返回"  + "/" + str(last_control_time_stamp) + "/gamehost/bag][wave]>> 返回 <<[/wave][/url]")

func update_moving() -> void:
	reached_time -= 1
	if reached_time <= 0:
		SignalBus.time_ticked.disconnect(update_moving)
		Gamedb.player_state.position = get_destination_by_id(heading_desination_id)
		SignalBus.message_output.emit(Gamedb.player_state.name + "到达了目的地！")
		show_info_panel()
		

func interactcharacter(characterid:String) -> void:
	last_control_time_stamp = int(Time.get_unix_time_from_system())
	var character = Gamedb.all_character[characterid]
	
	for story in character.story:
		if not Gamedb.player_state.flag.any(func(item): return story.not_flag.has(item)) and story.required_flag.all(func(item): return Gamedb.player_state.flag.has(item)):
			SignalBus.message_output.emit("    [url=%s/%s/gamehost/characterstory/%s/%s][wave]>> %s <<[/wave][/url]" % [story.type, str(last_control_time_stamp), characterid, story.type, story.type])
	SignalBus.message_output.emit("    [url="+ "返回"  + "/" + str(last_control_time_stamp) + "/gamehost/info][wave]>> 返回 <<[/wave][/url]")

func characterstory(characterid:String, storyid:String) -> void:
	var character = Gamedb.all_character[characterid]
	for story in character.story:
		if story.type == storyid:
			var instance = story.story.new()
			instance.execute(Gamedb.player_state, character)
			return




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
	if meta[2] != "gamehost":
		return
	print(meta)
	match meta[3]:
		"move":
			look_to_move()
		"moveto":
			try_to_move(meta[4])
		"info":
			show_info_panel()
		"pause":
			pause_game()
		"unpause":
			unpause_game()
		"lookaround":
			look_around()
		"lookitem":
			look_item(meta[4])
		"interactitem":
			do_item_action(meta[4], meta[5])
		"bag":
			open_bag()
		"checkbag":
			check_bag(int(meta[4]))
		"interactcharacter":
			interactcharacter(meta[4])
		"characterstory":
			characterstory(meta[4], meta[5])
