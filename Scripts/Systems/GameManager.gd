class_name GameManager

extends Node

func _ready():
	var item_selector = $GameCanvas.get_node("ItemSelector")
	var inventory = $Player.get_node("Body").get_node("Inventory")
	
	item_selector.connect("passive_item_selected_signal", inventory.select_passive_item)
