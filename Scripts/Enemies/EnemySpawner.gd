class_name EnemySpawner

extends Node

@export var camera_buffer : int = 50

@export var timer_survival : TimerSurvival
var player_node : Node2D
var enemies_manager : EnemiesManager
var camera : Camera2D

var enemy_scene = preload("res://Scenes/enemy.tscn")
var enemy_data = {}
var waves_data = {}

var enemy_frequency = 0.001
var time_since_last_spawn = 0.0

var current_wave_nb = -1
var current_enemies_nb = 0
var current_wave = {}
var max_wave_enemies = 0

var can_spawn = false

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
	
	start_next_wave()


func _process(delta):
	if !can_spawn:
		return
		
	time_since_last_spawn += delta
	
	if time_since_last_spawn >= enemy_frequency:
		spawn_enemies()
		time_since_last_spawn = 0.0


func set_references(player : Node2D, manager: EnemiesManager):
	player_node = player 
	camera = player_node.get_viewport().get_camera_2d()
	enemies_manager = manager
	enemies_manager.connect("enemy_died_signal", _on_enemy_died)
	can_spawn = true
	

func start_next_wave():
	current_wave_nb += 1
	
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
	if camera == null:
		return
	
	var spawn_distance = get_spawn_distance()
	var enemies_to_spawn = max_wave_enemies - current_enemies_nb
	
	for i in enemies_to_spawn:
		var enemy_type = pick_enemy_type()
		if enemy_type == "":
			return #fail safe
			
		var enemy = PoolSystem.instantiate_object("enemy", enemy_scene, get_spawn_position(spawn_distance), 0.0, self)
		enemy.set_references(player_node, enemies_manager)
		enemy.setup_stats(enemy_data[enemy_type])
		
		current_enemies_nb += 1
		#print("spawning ennemies !")


func pick_enemy_type() -> String:
	var enemy_type = current_wave["enemies"]
	
	if enemy_type.size() == 0:
		return ""
	
	return enemy_type[rng.randi_range(0, enemy_type.size() - 1)]["type"]


func get_spawn_distance() -> float:
	if camera == null:
		return 0.0
		
	var screen_size = camera.get_viewport_rect().size
	return screen_size.length() * 0.5 + camera_buffer


func get_spawn_position(spawn_distance : float) -> Vector2:
	var angle = randf() * TAU
	var spawn_offset = Vector2(cos(angle), sin(angle)) * spawn_distance
	var spawn_position = player_node.global_position + spawn_offset
	
	return spawn_position


func _on_enemy_died():
	current_enemies_nb -= 1
	#print("number of enemies: ", current_enemies_nb)


func _on_time_over():
	print("Time is over !")
	can_spawn = false


func _on_minute_passed():
	start_next_wave()
	print("Next wave !")
