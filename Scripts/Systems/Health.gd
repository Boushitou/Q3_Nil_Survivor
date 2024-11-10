class_name Health

var total_health : float
var current_health : float
var is_dead : bool

func _init(health):
	total_health = health
	current_health = total_health
	is_dead = false


func take_damage(amount : float):
	if is_dead:
		return
	
	current_health -= amount
	current_health = 0 if current_health < 0 else current_health
	
	if current_health < 0:
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
	#death event for player ?
