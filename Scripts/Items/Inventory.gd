extends Node
class_name Inventory

@export var starting_weapon_data : Resource

var passives_items : Array[Items]
var weapons : Array[Items]

var max_passives : int = 3
var max_weapons : int = 2

func _ready() -> void:
	pass

func add_start_weapon(player_stats : PlayerStats) -> void:
	if starting_weapon_data:
		var starting_weapon : Items = Items.new(starting_weapon_data, player_stats)
		add_item(starting_weapon)


func add_item(item: Items) -> void:
	if item.item is PassiveItem:
		passives_items.append(item)
		SignalBus.get_new_passive.emit(item)
	elif item.item is Weapon:
		weapons.append(item)
		SignalBus.get_new_weapon.emit(item)

	item.apply_effects()
	

func level_up_item(item: Items) -> void:
	var items : Array[Items] = []
	
	items = passives_items + weapons
	var correct_item : Items = null
	
	for i in items:
		if i.ID == item.ID:
			correct_item = i
			break
			
	if correct_item == null:
		print(" item not found")
		return
		
	correct_item.level_up()
	SignalBus.level_up_item.emit(correct_item)


func get_item_by_ID(item_ID : int) -> Items:
	var items : Array[Items] = []
	items = passives_items + weapons
	
	for i in items:
		if i.ID == item_ID:
			return i
	
	return null


func weapons_slots_full() -> bool:
	return weapons.size() >= max_weapons


func passives_slots_full() -> bool:
	return passives_items.size() >= max_passives


func item_is_level_max(item : Items) -> bool:
	return item.level >= item.item.max_level
	
	
func get_total_passive_items_bonuses(stat_name : String) -> float:
	var total_bonus : float = 0.0
	for passive in passives_items:
		if passive.item.stats_upgraded[passive.level - 1].has(stat_name):
			var bonus : float = passive.item.stats_upgraded[passive.level - 1][stat_name]
			total_bonus += bonus
		
	if total_bonus == 0.0:
		return 1.0
		
	return total_bonus	
