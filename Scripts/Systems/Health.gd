extends Node
class_name Health

@export var total_health : int
@export var health_regeneration : int
var current_health : int
var is_dead : bool = false

var regeneration_time = 1.0
var regeneration_timer = 0.0

signal has_died
signal change_health_signal(current_health : int)
signal health_upgrade_signal(total_health : int)

func _ready():
	current_health = total_health


func init_health():
	current_health = total_health
	is_dead = false


func _process(delta):
	health_regeneration_tick(delta)


func take_damage(amount : int):
	if is_dead:
		return
	
	#print("current health: ", current_health)
	current_health -= amount
	
	if current_health <= 0:
		current_health = 0
		death()
		
	change_health_signal.emit(current_health)	

func heal(amount : int):
	if is_dead:
		return
	
	current_health += amount
	current_health = total_health if current_health > total_health else current_health


func upgrade_health(amount : int):
	total_health += amount
	health_upgrade_signal.emit(total_health)


func upgrate_health_regeneration(amount : int):
	health_regeneration += amount


func health_regeneration_tick(delta):
	if is_dead || health_regeneration <= 0:
		return
	
	regeneration_timer += delta
	if regeneration_timer >= regeneration_time:
		regeneration_timer = 0
		heal(health_regeneration)
		change_health_signal.emit(current_health)
	

func death():
	is_dead = true
	emit_signal("has_died")
