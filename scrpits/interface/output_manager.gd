extends Node

@onready var main_output_rich_text_label: RichTextLabel = $"../../MainOutput_RichTextLabel"

var output_queue:Array[String] = []

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
	output_queue.append(output_message)


func _on_output_timer_timeout() -> void:
	var message_to_add = output_queue.pop_front()
	if message_to_add != null:
		main_output_rich_text_label.text = main_output_rich_text_label.text + "\n" + message_to_add
