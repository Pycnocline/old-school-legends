extends Node

func handle_command(command:String) -> void:
	match command:
		"/info":
			GameManager.output_state()
		"/move":
			GameManager.look_to_move()
