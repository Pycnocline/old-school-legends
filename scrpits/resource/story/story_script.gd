class_name StoryScript
extends Node

func s(text:String) -> void:
	SignalBus.story_output.emit(text)

func execute(subject:Character, object:Character) -> void:
	pass
