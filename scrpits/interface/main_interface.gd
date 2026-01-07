extends Control

@onready var main_output_rich_text_label: RichTextLabel = $MainOutput_RichTextLabel
@onready var input_line_line_edit: LineEdit = $InputLine_LineEdit

func _ready() -> void:
	SignalBus.message_output.emit("启动游戏...")
	Gamedb.load_all_destinations()
	Gamedb.load_all_destination_connect()
	Gamedb.load_player_state()
	SignalBus.message_output.emit("启动完毕")
