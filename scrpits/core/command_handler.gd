extends Node

func handle_command(command:String) -> void:
	match command:
		"/info":
			GameHost.show_info_panel()
		"/move":
			GameManager.look_to_move()
		"/roaming":
			GameManager.set_game_state("roaming")
		"/pause":
			GameManager.set_game_state("pause")
		"/speedup":
			GameManager.set_game_state("speedup")
		"/lookaround":
			GameManager.look_for_item()
