extends StoryScript



func execute(subject:Character, object:Character) -> void:
	SignalBus.message_output.emit("你好（这是剧情对话，输入回车继续）")
	s("这是一个测试任务")
	s("任务目标是去测试地点2转一圈")
	s("快去吧")
	subject.flag.append("测试任务已接取")
	SignalBus.character_hook.connect(done)

func done(character:Character) -> void:
	if character.position.name != "测试目的地2" or character.id != "player":
		return
	SignalBus.character_hook.disconnect(done)
	SignalBus.message_output.emit("测试任务要求已达成")
	character.flag.erase("测试任务已接取")
	character.flag.append("测试任务已完成")
	
