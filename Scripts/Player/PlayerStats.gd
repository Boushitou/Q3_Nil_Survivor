class_name PlayerStats

extends Node

@export var initial_health = 100.0
var health : Health

@export var speed : float
@export var attack_speed : float
@export var power : float
@export var atk_range : float
@export var amount: int

var stats : Dictionary

#region leveling value
var level = 1
const BASE_XP = 50
const GROWTH_FACTOR = 1.2
var next_xp = 50
var current_xp = 0
#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	health = Health.new(initial_health)
	stats = {
		"speed" : speed,
		"attack_speed" : attack_speed,
		"power" : power,
		"atk_range" : atk_range,
		"amount" : amount
}


func _process(delta):
	if Input.is_action_pressed("test_action"):
		increase_stat("speed", 10)
		print("speed has been increase by 10, total value : ", get_stat_value("speed"))


func get_xp(xp : int):
	current_xp += xp
	
	if current_xp > next_xp:
		level_up()


func level_up():
	level += 1
	current_xp = 0
	next_xp = BASE_XP * pow(GROWTH_FACTOR, level - 1)


func increase_hp(value : float):
	health.upgrade_health(value)


func increase_stat(stat_name : String, value):
	if stats.has(stat_name):
		stats[stat_name] += value
		stats[stat_name] = 0 if stats[stat_name] < 0 else stats[stat_name]


func get_stat_value(stat_name : String):
	if stats.has(stat_name):
		return stats[stat_name]
