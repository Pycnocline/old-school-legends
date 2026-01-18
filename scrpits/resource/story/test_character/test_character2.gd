extends StoryScript



func execute(subject:Character, object:Character) -> void:
	SignalBus.message_output.emit("测试任务已完成")
