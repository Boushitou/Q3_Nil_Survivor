class_name Health

extends Node

@export var total_health : float
var current_health : float
var is_dead : bool = false

func _ready():
	current_health = total_health


func take_damage(amount : float):
	if is_dead:
		return
	
	current_health -= amount
	print("Player has been hit, current health : ", current_health)
	
	if current_health <= 0:
		current_health = 0
		death()


func heal(amount : float):
	if is_dead:
		return
	
	current_health += amount
	current_health = total_health if current_health > total_health else current_health


func upgrade_health(amount : float):
	total_health += amount


func death():
	is_dead = true
	print("You are dead.")
	#death event for player ?
