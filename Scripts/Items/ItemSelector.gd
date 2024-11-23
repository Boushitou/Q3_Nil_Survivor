class_name ItemSelector

extends Node

#signal weapon_selected_signal(weapon: Weapon)
signal passive_item_selected_signal(passive: PassiveItem)



func _on_button_button_up():
	emit_signal("passive_item_selected_signal", "thot_amulet")


func _on_button_2_button_up():
	emit_signal("passive_item_selected_signal", "winged_scarab")


func _on_button_3_button_up():
	emit_signal("passive_item_selected_signal", "wedjat_eye")


func _on_button_4_button_up():
	emit_signal("passive_item_selected_signal", "heart_amulet")
