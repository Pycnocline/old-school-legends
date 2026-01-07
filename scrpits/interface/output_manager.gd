extends Node

@onready var main_output_rich_text_label: RichTextLabel = $"../../MainOutput_RichTextLabel"

func _ready() -> void:
	initialize_main_output()
	handle_signal_connection()


func _process(delta: float) -> void:
	pass

func initialize_main_output() -> void:
	main_output_rich_text_label.text = ""
	

func handle_signal_connection() -> void:
	SignalBus.message_output.connect(_handle_message_output)

func _handle_message_output(output_message) -> void:
	main_output_rich_text_label.text = main_output_rich_text_label.text + "\n" + output_message
