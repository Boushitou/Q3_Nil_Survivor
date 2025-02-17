extends Node
class_name GameManager


func _ready() -> void:
	SignalBus.connect("time_over", on_game_win)

	
func on_game_win() -> void:
	print("Game Win")
