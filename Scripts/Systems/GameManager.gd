extends Node
class_name GameManager

var game_is_paused : bool = false
var can_pause : bool = true

func _ready() -> void:
	SignalBus.connect("time_over", on_game_win)
	SignalBus.connect("pause_pressed", pause_game)
	SignalBus.connect("enable_pause", enable_pause)

	
func on_game_win() -> void:
	print("Game Win")

	
func pause_game() -> void:
	if can_pause:
		if game_is_paused:
			get_tree().paused = false
			game_is_paused = false
			Engine.time_scale = 1.0
		else:
			get_tree().paused = true
			game_is_paused = true
			Engine.time_scale = 0.0
		
		print("game is paused ? : ", game_is_paused)	

		
func enable_pause(pause_enabled : bool) -> void:
	can_pause = pause_enabled
	print("can pause ? : ", can_pause)
