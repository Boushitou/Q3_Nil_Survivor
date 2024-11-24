class_name Items

var level = 1
var item_name = ""
var effects = []
var is_multiplicative = false
var max_level = 8
var icon : Texture

var player_stats : PlayerStats


func _init(item: Dictionary, stats: PlayerStats):
	set_item_effects(item)
	player_stats = stats
	

func set_item_effects(item: Dictionary):
	effects = item["effects"]
	item_name = item["name"]
	is_multiplicative = item["multiplicative"]


func get_effect_description(index: int) -> String:
	var description = ""
	for effect_list in effects:
		var effect = effect_list[index]
		description = effect["description"]
		
	return description


func level_up():
	if level + 1 > max_level:
		print("This item can't level up anymore !")
		return
		
	level += 1
	apply_effects()
	print("passive leveled up : ", item_name, " level : ", level)
	
	
func apply_effects():
	print("A simple Item has no effects !")
