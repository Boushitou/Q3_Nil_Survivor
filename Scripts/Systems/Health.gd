class_name Health

extends Node

@export var total_health : int
var current_health : int
var is_dead : bool = false

signal has_died

func _ready():
	current_health = total_health


func init_health():
	current_health = total_health
	is_dead = false


func take_damage(amount : int):
	if is_dead:
		return
	
	#print("current health: ", current_health)
	current_health -= amount
	
	if current_health <= 0:
		current_health = 0
		death()


func heal(amount : int):
	if is_dead:
		return
	
	current_health += amount
	current_health = total_health if current_health > total_health else current_health


func upgrade_health(amount : int):
	total_health += amount


func death():
	is_dead = true
	emit_signal("has_died")
