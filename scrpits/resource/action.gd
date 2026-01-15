class_name Action
extends Resource

@export var required_in_bag: bool = true
@export var required_in_destination: bool = true

func execute(subject:Character, item:Item, destination:Destination, actionname:String) -> void:
	pass
