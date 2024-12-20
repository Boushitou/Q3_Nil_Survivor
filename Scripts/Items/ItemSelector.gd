extends Node
class_name ItemSelector

@export var passive_items : Array[PassiveItem]
@export var weapons : Array[Resource] #I don't understand why my kopesh can't be put here while it inherit Weapon AND Item ...

var item_choice = preload("res://Scenes/item_choice.tscn")

var inventory : Inventory
var player_stats : PlayerStats

var total_items : Array[Item]
var items_to_display : Array[Item]

const MAX_ITEMS = 3

func _ready():
	inventory = get_tree().get_nodes_in_group("player")[0].get_node("Inventory")
	player_stats = get_tree().get_nodes_in_group("player")[0].get_node("PlayerStats")
	player_stats.connect("level_up_signal", make_parent_visible)

	total_items.append_array(passive_items)
	total_items.append_array(weapons)


func prepare_items_to_display():
	for child in get_children():
		child.disconnect("item_selected_signal", set_item_in_inventory)
		child.disconnect("item_selected_signal", make_parent_not_visible)
		child.queue_free()
		
	items_to_display = get_random_items()
	
	if items_to_display.size() > 0:
		display_items()
		get_tree().paused = true
		pass
	else:
		make_parent_not_visible(null)
		print("No items to display !")
		
		
func display_items():
	for item in items_to_display:
		var item_instance : ItemDisplay
		item_instance = item_choice.instantiate()
		add_child(item_instance)
		
		var item_level = 1
		var player_item = inventory.get_item_by_ID(item.ID)
		var first_time = true
		
		if player_item:
			item_level = player_item.level + 1
			if item_level >= player_item.item.max_level:
				remove_item(item)
				
			first_time = false
			print("Item level: ", item_level)
		
		item_instance.set_item_data(item, player_stats, item_level, first_time)
		item_instance.connect("item_selected_signal", set_item_in_inventory)
		item_instance.connect("item_selected_signal", make_parent_not_visible)


func set_item_in_inventory(added_item : Items):
	var player_item = inventory.get_item_by_ID(added_item.ID)
	
	if not player_item:
		inventory.add_item(added_item)
	else:
		inventory.level_up_item(added_item)
	

func get_available_items() -> Array[Item]:
	if total_items.size() == 0:
		return []
	
	var player_passives = inventory.passives_items
	var player_weapons = inventory.weapons
	
	var available_items : Array[Item] = []

	if inventory.passives_slots_full():
		for passive in player_passives:
			if not inventory.item_is_level_max(passive):
				available_items.append(passive.item)
	else:
		available_items.append_array(total_items)
	
	if inventory.weapons_slots_full():
		for weapon in player_weapons:
			if not inventory.item_is_level_max(weapon):
				available_items.append(weapon.item)
	else:
		available_items.append_array(weapons)
	
	return available_items
	

func get_random_items() -> Array[Item]:
	var available_items = get_available_items()
	var selected : Array[Item] = []
	
	while available_items.size() > 0 and selected.size() < MAX_ITEMS:
		var index = randi() % available_items.size();
		var item = available_items[index]
		
		if not selected.has(item):
			selected.append(item)
			
		available_items.remove_at(index)	
	
	return selected	
	
	
func remove_item(item_to_remove : Item):
	var index = total_items.find(item_to_remove)
	if index != -1:
		total_items.remove_at(index)


func make_parent_visible():
	get_parent().visible = true


func make_parent_not_visible(_added_item : Items):
	get_parent().visible = false
	get_tree().paused = false


func _on_visibility_changed():
	if not inventory:
		return
	if get_parent().is_visible_in_tree():
		prepare_items_to_display()
		Engine.time_scale = 0.0
	else:
		Engine.time_scale = 1.0
