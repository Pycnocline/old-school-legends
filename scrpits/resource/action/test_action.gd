class_name TestAction
extends Action

@export var message: String

func execute() -> void:
	SignalBus.message_output.emit(message)
