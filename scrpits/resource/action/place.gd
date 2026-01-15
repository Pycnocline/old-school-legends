class_name Place
extends Action

func execute(subject:Character, item:Item, destination:Destination, actionname:String) -> void:
	subject.bag.erase(item)
	destination.item.append(item)
	item.is_in_destination = true
	item.is_in_bag = false
	SignalBus.message_output.emit("%s把%s放置在了当前场景中！" % [subject.name, item.name])
	GameHost.show_info_panel()
