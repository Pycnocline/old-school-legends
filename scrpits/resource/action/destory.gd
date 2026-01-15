class_name Destory
extends Action

func execute(subject:Character, item:Item, destination:Destination, actionname:String) -> void:
	if item.is_in_bag:
		subject.bag.erase(item)
	elif  item.is_in_destination:
		destination.item.erase(item)
	Gamedb.all_items.erase(item)
	SignalBus.message_output.emit("%s销毁了%s！" % [subject.name, item.name])
	GameHost.show_info_panel()
