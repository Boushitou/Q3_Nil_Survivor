extends Control
class_name MainMenu

func change_scene(scene_name : String) -> void:
	get_tree().change_scene_to_file(scene_name)
	
	
func quit_game() -> void:
	get_tree().quit()
	

func _on_start_button_pressed():
	change_scene("res://Scenes/main_game.tscn")


func _on_quit_button_pressed():
	quit_game()
