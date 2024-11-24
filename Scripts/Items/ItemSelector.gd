class_name ItemSelector

extends Node

var item_choice = preload("res://Scenes/item_choice.tscn")

var inventory : Inventory
var player_stats : PlayerStats

var passives_data = {}
var weapons_data = {}
var items_data = {}
var items_to_display = []
var item_name_to_key = {}

const MAX_ITEMS = 3


func _ready():
	passives_data = set_items_data("res://Data/Items/PassiveItems.json")
	weapons_data = set_items_data("res://Data/Items/Weapons.json")
	items_data = passives_data.duplicate()
	items_data.merge(weapons_data)

	set_keys_name(passives_data)
	set_keys_name(weapons_data)

	inventory = get_tree().get_nodes_in_group("player")[0].get_node("Inventory")
	player_stats = inventory.player_stats
	player_stats.connect("level_up_signal",make_parent_visible)


func _process(_delta):
	pass

func set_items_data(path : String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = {}
	
	if file:
		data = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		print("Error while opening file : ", path)
	
	return data


func set_keys_name(data : Dictionary):
	for key in data.keys():
		var item = data[key]
		item_name_to_key[item["name"]] = key


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

		var item_level = 1
		var player_item = inventory.get_item_by_name(items_data[item]["name"])
		var first_time = true
		if player_item:
			item_level = player_item.level + 1
			first_time = false
			print("item level : ", item_level)

		item_instance.set_item_data(items_data[item], player_stats, item_level, first_time)
		item_instance.connect("item_selected_signal", set_item_in_inventory)
		item_instance.connect("item_selected_signal", make_parent_not_visible)


func set_item_in_inventory(added_item : Items):
	var player_item = inventory.get_item_by_name(items_data[item_name_to_key[added_item.item_name]]["name"])
	if not player_item:
		inventory.add_item(added_item)
	else:
		inventory.level_up_item(added_item)


func get_available_items() -> Array:
	var total_passive_items = passives_data.keys()
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


func prepare_items_to_display():
	for child in get_children():
		child.disconnect("item_selected_signal", set_item_in_inventory)
		child.disconnect("item_selected_signal", make_parent_not_visible)
		child.queue_free()
	
	items_to_display = get_random_item()
	if items_to_display.size() > 0:
		display_items()
	else:
		print("No items to display !")


func make_parent_visible():
	get_parent().visible = true


func make_parent_not_visible(_added_item : Items):
	get_parent().visible = false


func _on_visibility_changed():
	if not inventory:
		return
	if get_parent().is_visible_in_tree():
		prepare_items_to_display()
