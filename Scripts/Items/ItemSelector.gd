class_name ItemSelector

extends Node

var item_choice = preload("res://Scenes/item_choice.tscn")

var inventory : Inventory
var player_stats : PlayerStats

var passives_data = {}
var items_to_display = []

#signal weapon_selected_signal(weapon: String)
signal passive_item_selected_signal(passive: String)


func _ready():
	var passives_file = FileAccess.open("res://Data/Items/PassiveItems.json", FileAccess.READ)
	
	if passives_file:
		passives_data = JSON.parse_string(passives_file.get_as_text())
		passives_file.close()

	inventory = get_tree().get_nodes_in_group("player")[0].get_node("Inventory")
	player_stats = inventory.player_stats


func _process(_delta):
	if Input.is_action_just_pressed("test_action"):
		for child in get_children():
			child.queue_free()
		
		items_to_display = get_random_passive_item()
		display_items()


func get_random_passive_item() -> Array:
	var passive_keys = passives_data.keys()
	var selected = []
	
	while passive_keys.size() > 0 and selected.size() < 3:
		var index = randi() % passive_keys.size()
		var passive = passive_keys[index]
		
		if not selected.has(passive):
			selected.append(passive)
			
		passive_keys.remove_at(index)
	
	return selected
		

func display_items():
	for item in items_to_display:
		var item_instance = item_choice.instantiate()
		add_child(item_instance)

		item_instance.set_item_data(passives_data[item], player_stats)


func check_player_inventory():
	var passives = inventory.passives_items
	var weapons = inventory.weapons


func _on_visibility_changed():
	pass # Replace with function body.
