class_name TimerSurvival

extends Node

var max_time = 1800.0 #30 minutes
var elapsed_time = 0.0 #To check every minutes
var current_time = 0.0 #total time elapsed
var time_is_over = false

@export var timer_label : Label #todo: create another script to handle the timer label update

signal minute_passed
signal time_over

func _process(delta):
	if time_is_over:
		return
		
	if current_time >= max_time:
		emit_signal("time_over")
		time_is_over = true
		return
	
	current_time += delta
	elapsed_time += delta
	
	if elapsed_time >= 60.0:
		elapsed_time = 0.0
		emit_signal("minute_passed")
		
	var minutes = int(current_time / 60.0)
	var seconds = int(fmod(current_time, 60.0))
	
	if timer_label:
		timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
