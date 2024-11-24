class_name ItemSelector

extends Node

var item_choice = preload("res://Scenes/item_choice.tscn")

var inventory : Inventory
var player_stats : PlayerStats

var items_data = {}
var weapons_data = {}
var items_to_display = []
var item_name_to_key = {}

const MAX_ITEMS = 3


func _ready():
	var passives_file = FileAccess.open("res://Data/Items/PassiveItems.json", FileAccess.READ)
	
	if passives_file:
		items_data = JSON.parse_string(passives_file.get_as_text())
		passives_file.close()

	for key in items_data.keys():
		var item = items_data[key]
		item_name_to_key[item["name"]] = key

	inventory = get_tree().get_nodes_in_group("player")[0].get_node("Inventory")
	player_stats = inventory.player_stats


func _process(_delta):
	if Input.is_action_just_pressed("test_action"):
		for child in get_children():
			child.disconnect("item_selected_signal", set_item_in_inventory)
			child.queue_free()
		
		items_to_display = get_random_item()
		if items_to_display.size() > 0:
			display_items()
		else:
			print("No items to display !")


func get_random_item() -> Array:
	var items = get_available_items()
	var selected = []
	
	while items.size() > 0 and selected.size() < MAX_ITEMS:
		var index = randi() % items.size()
		var passive = items[index]
		
		if not selected.has(passive):
			selected.append(passive)
			
		items.remove_at(index)
	
	return selected
		

func display_items():
	for item in items_to_display:
		var item_instance = item_choice.instantiate()
		add_child(item_instance)

		item_instance.set_item_data(items_data[item], player_stats)
		item_instance.connect("item_selected_signal", set_item_in_inventory)


func set_item_in_inventory(added_item : Items):
	if not inventory.already_has_item(added_item):
		inventory.add_item(added_item)
	else:
		inventory.level_up_item(added_item)


func get_available_items() -> Array:
	var total_passive_items = items_data.keys()
	var total_weapons = weapons_data.keys()
	var player_passives = inventory.passives_items #array of PassiveItem
	var player_weapons = inventory.weapons #array of WeaponItem
	var available_items = []
	
	if inventory.passives_slots_full():
		for passive in player_passives:
			if not inventory.item_is_level_max(passive):
				var key = item_name_to_key[passive.item_name]
				available_items.append(key)
	else:
		available_items.append_array(total_passive_items)
	
	if inventory.weapons_slots_full():
		for weapon in player_weapons:
			if not inventory.item_is_level_max(weapon):
				var key = item_name_to_key[weapon.item_name]
				available_items.append(key)
	else:
		available_items.append_array(total_weapons)
		
		
	return available_items


func _on_visibility_changed():
	pass # Replace with function body.
