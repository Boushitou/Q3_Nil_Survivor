class_name Inventory

extends Node

@export var player_stats : PlayerStats

var passives_items = []
var weapons = []

var max_passives = 3
var max_weapons = 3

var passives_data = {}


func _ready():
	var passives_file = FileAccess.open("res://Data/Items/PassiveItems.json", FileAccess.READ)
	
	if passives_file:
		passives_data = JSON.parse_string(passives_file.get_as_text())
		passives_file.close()


func _process(_delta):
	if Input.is_action_just_pressed("add_item_test"):
		var new_passive = PassiveItem.new(passives_data["winged_scarab"], player_stats)
		select_passive_item(new_passive)
		


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
	var item = null
	for passive_item in passives_items:
		if passive.passive_name == passive_item.passive_name:
			item = passive_item
			break
			
	if item == null:
		print("passive item not found")
		return
		
	item.level_up()
