extends Control

@onready var main_output_rich_text_label: RichTextLabel = $MainOutput_RichTextLabel
@onready var input_line_line_edit: LineEdit = $InputLine_LineEdit
@onready var game_circle_timer: Timer = $GameCircle_Timer

func _ready() -> void:
	SignalBus.message_output.emit("启动游戏...")
	Gamedb.load_all_destinations()
	Gamedb.load_all_destination_connect()
	Gamedb.load_player_state()
	Gamedb.load_all_character()
	SignalBus.message_output.emit("启动完毕")
	
	game_circle_timer.start()
	GameHost.show_info_panel()


func _on_game_circle_timer_timeout() -> void:
	GameManager.do_game_circle()
