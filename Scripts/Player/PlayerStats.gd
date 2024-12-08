extends Stats
class_name PlayerStats

@export var attack_speed : float
@export var atk_range : float
@export var amount: int
@export var projectile_speed : float

var stats : Dictionary

#region leveling value
const BASE_XP = 5
const GROWTH_FACTOR = 1.2
var next_xp : int = BASE_XP
var current_xp = 0
var level_up_queue = 0 #if the player level up too many times at once

signal level_up_signal()
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	stats = {
		"speed": speed,
		"attack_speed": attack_speed,
		"power": power,
		"atk_range": atk_range,
		"amount": amount,
		"projectile_speed": projectile_speed,
		"health": health.total_health,
		"health_regeneration": health.health_regeneration
	}
	SignalBus.connect("gain_xp", add_xp)
	health.connect("has_died", player_death)


func _process(_delta):
	if level_up_queue > 0:
		level_up()

		
func add_xp(xp : int):
	current_xp += xp
	
	while current_xp >= next_xp:
		current_xp -= next_xp
		level_up_queue += 1


func level_up():
	level += 1
	next_xp = BASE_XP * pow(GROWTH_FACTOR, level - 1)
	level_up_queue -= 1
	
	if level_up_queue < 0:
		level_up_queue = 0

	level_up_signal.emit()


func increase_stat(stat_name : String, value):
	if stats.has(stat_name):
			stats[stat_name] = value
			stats[stat_name] = 0 if stats[stat_name] < 0 else stats[stat_name]
			
			if stat_name == "health" or stat_name == "health_regeneration":
				update_health_values()

				
func get_stat_value(stat_name : String):
	if stats.has(stat_name):
		return stats[stat_name]
	else:
		print("stat not found : ", stat_name)
		return 0


func update_health_values():
	health.total_health = get_stat_value("health")
	health.health_regeneration = get_stat_value("health_regeneration")

	
func player_death():
	get_parent().queue_free()