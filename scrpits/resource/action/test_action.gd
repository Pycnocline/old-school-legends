class_name TestAction
extends Action

func execute(subject:Character, item:Item, destination:Destination, actionname:String) -> void:
	SignalBus.message_output.emit("%s对着%s大叫了一声：[b][color=gold][shake]哇袄！！！！[/shake][/color][/b]" % [item.name, subject.name])
	GameHost.show_info_panel()
