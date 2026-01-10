extends Node

signal input_confirmed(input_message:String)	#用户输入确认
signal message_output(output_message:String)		#系统输出

signal game_circle_timer_control(type:String)		#游戏主循环计时器操作
signal time_tick()		#新的一分钟
signal time_ticked()		#时间已更新，按照新时间进行游戏循环

signal player_data_signal(id:String, limit:bool)		#玩家数据达到上限或下限时触发事件，true为上限
