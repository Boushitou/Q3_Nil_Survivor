extends Node
class_name GameManager


func _ready():
	SignalBus.connect("time_over", on_game_win)

	
func on_game_win():
	print("Game Win")
