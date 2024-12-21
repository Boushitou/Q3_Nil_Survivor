extends Node
class_name TimerSurvival

var max_time = 1800.0 #30 minutes
var elapsed_time = 0.0 #To check every minutes
var current_time = 0.0 #total time elapsed
var time_is_over = false

@export var timer_label : Label

func _process(delta):
	if time_is_over:
		return
		
	if current_time >= max_time:
		SignalBus.emit_signal("time_over")
		time_is_over = true
		return
	
	current_time += delta
	elapsed_time += delta
	
	if elapsed_time >= 60.0:
		elapsed_time = 0.0
		SignalBus.emit_signal("minute_passed")
		
	var minutes = int(current_time / 60.0)
	var seconds = int(fmod(current_time, 60.0))
	
	if timer_label:
		timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
