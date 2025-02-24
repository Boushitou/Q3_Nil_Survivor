extends Menu
class_name GameOverScreen

@export var game_over_label : Label
@export var retry_button : Button

var game_over_text : String = "Game Over"

func _ready() -> void:
	SignalBus.connect("time_over", on_game_win)
	game_over_label.text = game_over_text
	
	
func on_game_win() -> void:
	game_over_label.text = "Your time is up"
	game_over_label.modulate = Color(0.353, 0.784, 0.098)


func _on_retry_button_button_up():
	change_scene("res://Scenes/main_game.tscn")


func _on_quit_button_button_up():
	quit_game()


func _on_draw():
	retry_button.grab_focus()
