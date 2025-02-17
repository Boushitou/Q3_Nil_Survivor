extends Stats
class_name PlayerStats

@export var inventory : Inventory
@export var stats : Dictionary

#region leveling value
const BASE_XP : int = 5
const GROWTH_FACTOR : float = 1.2 #1.2
var next_xp : int = BASE_XP
var current_xp : int = 0
var level_up_queue : int = 0 #if the player level up too many times at once
#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats["health"] = health.total_health
	stats["health_regeneration"] = health.health_regeneration
	
	inventory.add_start_weapon(self)
	SignalBus.connect("gain_xp", add_xp)
	health.connect("has_died", player_death)


func _process(_delta) -> void:
	if level_up_queue > 0:
		level_up()

		
func add_xp(xp : int) -> void:
	current_xp += xp
	
	while current_xp >= next_xp:
		current_xp -= next_xp
		level_up_queue += 1


func level_up() -> void:
	level += 1
	next_xp = calculate_xp(level)
	level_up_queue -= 1
	
	if level_up_queue < 0:
		level_up_queue = 0

	SignalBus.level_up_signal.emit(level, next_xp, current_xp)


#Calculation inspired by the description of the Vampire Survivor wiki level up system
func calculate_xp(current_level : int) -> int:
	if current_level == 1:
		return BASE_XP
	elif current_level <= 20:
		return BASE_XP + (level - 1) * 10
	elif current_level <= 40:
		return calculate_xp(20) + 600 + (current_level - 20) * 13
	else:
		return calculate_xp(40) + 2400 + (current_level - 40) * 16


func increase_stat(stat_name : String, value) -> void:
	if stats.has(stat_name):
			stats[stat_name] = value
			stats[stat_name] = 0 if stats[stat_name] < 0 else stats[stat_name]
			
			if stat_name == "health":
				health.upgrade_health(value)
			elif stat_name == "health_regeneration":
				health.upgrate_health_regeneration(value)
				


func get_stat_value(stat_name : String): #this method actually needs to be dynamic
	if stats.has(stat_name):
		return stats[stat_name] * inventory.get_total_passive_items_bonuses(stat_name)
	else:
		print("stat not found : ", stat_name)
		return 0
		

func player_death() -> void:
	get_parent().queue_free()
