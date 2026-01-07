extends Node

@onready var input_line_line_edit: LineEdit = $"../../InputLine_LineEdit"
@onready var main_output_rich_text_label: RichTextLabel = $"../../MainOutput_RichTextLabel"

func _ready() -> void:
	initialize_input_line()
	main_output_rich_text_label.meta_clicked.connect(_on_text_clicked)

func _process(delta: float) -> void:
	pass

func initialize_input_line() -> void:
	input_line_line_edit.text = ""

# 响应用户输入并发送信号
func _on_input_line_line_edit_text_submitted(new_text: String) -> void:
	input_line_line_edit.text = ""
	if new_text.begins_with("/"):
		CommandHandler.handle_command(new_text)
	else:
		SignalBus.input_confirmed.emit(new_text)
	print("收到用户输入：" + new_text)
	
func _on_text_clicked(meta) -> void:
	GameManager.move_to(meta)
