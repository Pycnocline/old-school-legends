extends Node

var time: Dictionary = {
	"year": 0,
	"month": 9,
	"day": 1,
	"hour": 9,
	"minute": 0,
	"day_of_week": 1 
}

const DAYS_IN_MONTH = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

func _ready() -> void:
	SignalBus.time_tick.connect(tick_time)

func tick_time() -> void:
	var new_time = time
	new_time["minute"] += 1
	
	if new_time["minute"] >= 60:
		new_time["minute"] = 0
		new_time["hour"] += 1
		
		if new_time["hour"] >= 24:
			new_time["hour"] = 0
			new_time["day"] += 1
			new_time["day_of_week"] += 1
			
			if new_time["day_of_week"] > 7:
				new_time["day_of_week"] = 1
			
			if new_time["day"] > DAYS_IN_MONTH[new_time["month"]]:
				new_time["day"] = 1
				new_time["month"] += 1
				
				if new_time["month"] > 12:
					new_time["month"] = 1
					new_time["year"] += 1
	
	time = new_time
	SignalBus.time_ticked.emit()

func get_time_string() -> String:
	var hour_minute_str:String = "%02d:%02d" % [time["hour"], time["minute"]]
	var output = "第" + str(time["year"]) + "年 "+ str(time["month"]) + "月" + str(time["day"]) + "日 " + hour_minute_str + " 星期" + str(time["day_of_week"])
	return output
	
