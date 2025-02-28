extends Node
class_name TimerSurvival

var max_time : float = 360.0 #30 minutes 1800.0
var elapsed_time : float = 0.0 #To check every minutes
var current_time : float = 0.0 #total time elapsed
var time_is_over : bool = false

@export var timer_label : Label

func _process(delta) -> void:
	if time_is_over:
		return
		
	if current_time >= max_time:
		SignalBus.emit_signal("time_over")
		SignalBus.emit_signal("minute_passed")
		time_is_over = true
		return
	
	current_time += delta
	elapsed_time += delta
	
	if elapsed_time >= 60.0:
		elapsed_time = 0.0
		SignalBus.emit_signal("minute_passed")
		
	var minutes : float = int(current_time / 60.0)
	var seconds : float = int(fmod(current_time, 60.0))
	
	if timer_label:
		timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
