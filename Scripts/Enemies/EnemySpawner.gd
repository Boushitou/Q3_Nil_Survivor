class_name EnemySpawner

extends Node

@export var timer_survival : TimerSurvival
var playerNode : Node2D
var enemies_manager : EnemiesManager

var enemy_scene = preload("res://Scenes/enemy.tscn")
var enemy_data = {}
var waves_data = {}

var enemy_frequency = 0.001
var time_since_last_spawn = 0.0

var current_wave_nb = 0
var current_enemies_nb = 0
var current_wave = {}
var max_wave_enemies = 0

var can_spawn = true

var rng = RandomNumberGenerator.new()


func _ready():
	var enemies_file = FileAccess.open("res://Data/Enemies/enemies.json", FileAccess.READ)
	if enemies_file:
		enemy_data = JSON.parse_string(enemies_file.get_as_text())
		enemies_file.close()
	
	var waves_file = FileAccess.open("res://Data/Enemies/waves.json", FileAccess.READ)
	if waves_file:
		waves_data = JSON.parse_string(waves_file.get_as_text())
		waves_file.close()
	
	current_wave = waves_data["waves"][current_wave_nb]
	max_wave_enemies = calculate_max_enemies(current_wave)
	enemy_frequency = current_wave["enemies_frequency"]
	timer_survival.connect("time_over", _on_time_over)
	timer_survival.connect("minute_passed", _on_minute_passed)


func _process(delta):
	if !can_spawn:
		return
		
	time_since_last_spawn += delta
	
	if time_since_last_spawn >= enemy_frequency:
		spawn_enemies()
		time_since_last_spawn = 0.0


func set_references(player : Node2D, manager: EnemiesManager):
	playerNode = player 
	enemies_manager = manager
	enemies_manager.connect("enemy_died_signal", _on_enemy_died)
	

func start_next_wave():
	if current_wave_nb >= waves_data["waves"].size():
		return
	current_wave = waves_data["waves"][current_wave_nb]
	max_wave_enemies = calculate_max_enemies(current_wave)
	enemy_frequency = current_wave["enemies_frequency"]
	

func calculate_max_enemies(wave_data) -> int:
	var max_enemies = 0
	
	for enemy in wave_data["enemies"]:
		max_enemies += enemy["count"]
		
	return max_enemies


func spawn_enemies():
	if current_enemies_nb >= max_wave_enemies:
		#print("can't spawn more enemies !")
		return
	
	var enemies_to_spawn = max_wave_enemies - current_enemies_nb
	
	for i in enemies_to_spawn:
		var dist = 800.0
		var pos = Vector2(rng.randf_range(-dist, dist), rng.randf_range(-dist, dist))
		var enemy = PoolSystem.instantiate_object("enemy", enemy_scene, pos, 0.0, self)
		enemy.set_references(playerNode, enemies_manager)
		
		var enemy_type = current_wave["enemies"][0]["type"]
		enemy.setup_stats(enemy_data[enemy_type])
		current_enemies_nb += 1
		#print("spawning ennemies !")


func _on_enemy_died():
	current_enemies_nb -= 1
	#print("number of enemies: ", current_enemies_nb)


func _on_time_over():
	print("Time is over !")
	can_spawn = false


func _on_minute_passed():
	current_wave_nb += 1
	start_next_wave()
	print("Next wave !")
