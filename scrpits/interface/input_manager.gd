extends Node

@onready var input_line_line_edit: LineEdit = $"../../InputLine_LineEdit"

func _ready() -> void:
	initialize_input_line()

func _process(delta: float) -> void:
	pass

func initialize_input_line() -> void:
	input_line_line_edit.text = ""

# 响应用户输入并发送信号
func _on_input_line_line_edit_text_submitted(new_text: String) -> void:
	var input_text = new_text
	input_line_line_edit.text = ""
	SignalBus.input_confirmed.emit(input_text)
	print("收到用户输入：" + input_text)
	
