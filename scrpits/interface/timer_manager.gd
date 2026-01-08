extends Node

@onready var game_circle_timer: Timer = $"../../GameCircle_Timer"

func _ready() -> void:
	SignalBus.game_circle_timer_control.connect(_game_circle_timer_control)


func _game_circle_timer_control(type:String) -> void:
	match type:
		"roaming":
			game_circle_timer.stop()
			game_circle_timer.wait_time = 1
			game_circle_timer.start()
		"pause":
			game_circle_timer.stop()
		"speedup":
			game_circle_timer.stop()
			game_circle_timer.wait_time = 0.01
			game_circle_timer.start()
