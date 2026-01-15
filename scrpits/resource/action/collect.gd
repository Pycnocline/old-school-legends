class_name Collect
extends Action

func execute(subject:Character, item:Item, destination:Destination, actionname:String) -> void:
	destination.item.erase(item)
	subject.bag.append(item)
	item.is_in_destination = false
	item.is_in_bag = true
	SignalBus.message_output.emit("%s把%s收入了背包中！" % [subject.name, item.name])
	GameHost.show_info_panel()
