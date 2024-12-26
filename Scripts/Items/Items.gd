class_name Items

var item : Item
var level : int = 1
var ID : int = -1

var player_stats : PlayerStats

func _init(item_type: Item, stats: PlayerStats) -> void:
	item = item_type
	ID = item.ID
	player_stats = stats
	

func get_effect_description(index: int) -> String:
	return  item.descriptions[index]


func level_up() -> void:
	if level + 1 > item.max_level:
		print("This item can't level up anymore !")
		return
		
	level += 1
	apply_effects()
	print("Item leveled up : ", item.name, " level : ", level)
	
	
func apply_effects() -> void:
	item.apply_effect(player_stats, level)
	
	
func attack(position : Vector2, direction : Vector2, inventory : Inventory) -> void:
	var weapon_atk : WeaponBehavior = item.create_attack(player_stats, level, inventory, position, direction)
	if not weapon_atk:
		return
		
	weapon_atk.initialize_weapon(self, inventory, player_stats)
