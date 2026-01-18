extends Node

@onready var main_output_rich_text_label: RichTextLabel = $"../../MainOutput_RichTextLabel"

var output_queue: Array[String] = []
var story_queue: Array[String] = []

func _ready() -> void:
	initialize_main_output()
	handle_signal_connection()

func initialize_main_output() -> void:
	main_output_rich_text_label.text = ""
	

func handle_signal_connection() -> void:
	SignalBus.message_output.connect(_handle_message_output)
	SignalBus.story_output.connect(_handle_story_output)
	SignalBus.input_continue.connect(_story_continue)

func _handle_message_output(output_message) -> void:
	output_queue.append(output_message)

func _handle_story_output(output_story) -> void:
	story_queue.append(output_story)

func _story_continue() -> void:
	var story_to_add = story_queue.pop_front()
	if story_to_add != null:
		main_output_rich_text_label.text = main_output_rich_text_label.text + "\n" + story_to_add
	else:
		GameHost.show_info_panel()

func _on_output_timer_timeout() -> void:
	var message_to_add = output_queue.pop_front()
	if message_to_add != null:
		main_output_rich_text_label.text = main_output_rich_text_label.text + "\n" + message_to_add
