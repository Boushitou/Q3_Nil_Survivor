class_name Inventory

extends Node

@export var player_stats : PlayerStats

var passives_items = []
var weapons = []

var max_passives = 3
var max_weapons = 3


func select_passive_item(passive: PassiveItem):
	if passives_items.size() >= max_passives:
		print("passive item list is full")
		return
		
	if is_item_in_inventory(passive):
		level_up_passive_item(passive)
	else:
		add_passive_item(passive)
	

#this logic should change when the item selection menu in implemented because we need to show up the right description
func is_item_in_inventory(item: PassiveItem) -> bool:
	var item_name = item.passive_name
	
	for passive in passives_items:
		if passive.passive_name == item_name:
			return true
			
	return false


func add_passive_item(passive: PassiveItem):
	passives_items.append(passive)
	passive.apply_effects()
	print("passive item added : ", passive.passive_name)
	

func level_up_passive_item(passive: PassiveItem):
	var item = passives_items.find(passive)
	item.level_up()
	print("passive item leveled up : ", item.passive_name)
	print("level : ", item.passive_name)
	passive.free()
