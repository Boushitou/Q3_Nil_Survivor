extends Control
class_name InventoryDisplay

@export var weapons_display : HBoxContainer
@export var passives_display : HBoxContainer


func _ready() -> void:
	SignalBus.connect("get_new_weapon", update_inventory_display)
	SignalBus.connect("get_new_passive", update_inventory_display)
	SignalBus.connect("level_up_item", update_item_level)

func update_inventory_display(item: Items) -> void :
	if not item:
		return
		
	if item.item is PassiveItem:
		set_display_by_type(passives_display, item)
	elif item.item is Weapon:
		set_display_by_type(weapons_display, item)


func set_display_by_type(container : Control, item : Items) -> void :
	for item_display : InventoryItemDisplay in container.get_children():
		if not item_display:
			return
		
		if item_display.item_displayed == null:
			item_display.set_item_infos(item)
			break
			
		
func update_item_level(item: Items) -> void:
	if not item:
		return
		
	if item.item is PassiveItem:
		update_item_level_by_type(passives_display, item)
	elif item.item is Weapon:
		update_item_level_by_type(weapons_display, item)
		
		
func update_item_level_by_type(container : Control, item : Items) -> void:
	for item_display : InventoryItemDisplay in container.get_children():
		if not item_display:
			return
			
		if 	item_display.item_displayed == item:
			item_display.set_item_infos(item)
			break
