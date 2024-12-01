class_name EnemySpawner

extends Node

@export var camera_buffer : int = 50

@export var timer_survival : TimerSurvival
@export var waves : Array[WaveData] = []
#The enemy type is defined by an ID, to know the correspondance go to: Data\Enemies\ID_enemies_helper.txt
@export var enemies_data : Array[EnemyData] = []

var player_node : Node2D
var enemies_manager : EnemiesManager
var camera : Camera2D

var enemy_scene = preload("res://Scenes/enemy.tscn")

var enemy_frequency = 0.001
var time_since_last_spawn = 0.0

var enemies = {}
var current_wave_nb = -1
var current_enemies_nb = 0
var current_wave : WaveData
var max_wave_enemies = 0

var can_spawn = false

var rng = RandomNumberGenerator.new()


func _ready():
	timer_survival.connect("time_over", _on_time_over)
	timer_survival.connect("minute_passed", _on_minute_passed)
	
	for enemy_data in enemies_data:
		enemies[enemy_data.ID] = enemy_data

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
	enemies_manager = manager
	camera = enemies_manager.camera
	enemies_manager.connect("enemy_died_signal", _on_enemy_died)
	can_spawn = true
	

func start_next_wave():
	current_wave_nb += 1
	
	if current_wave_nb >= waves.size():
		return
		
	current_wave = waves[current_wave_nb]
	
	max_wave_enemies = calculate_max_enemies(current_wave)
	enemy_frequency = waves[current_wave_nb].enemy_frequency
	

func calculate_max_enemies(wave_data : WaveData) -> int:
	var max_enemies = 0
	
	for enemy in wave_data.enemy_data:
		max_enemies += enemy["count"]
		
	return max_enemies


func spawn_enemies():
	if current_enemies_nb >= max_wave_enemies:
		#print("can't spawn more enemies !")
		return
	if camera == null:
		return
	
	var spawn_distance = camera.get_spawn_distance(camera_buffer)
	var enemies_to_spawn = max_wave_enemies - current_enemies_nb
	
	for i in enemies_to_spawn:
		var enemy_ID = pick_enemy_type()
		if enemy_ID == -1:
			return #fail safe
			
		var enemy = PoolSystem.instantiate_object("enemy", enemy_scene, camera.get_spawn_position(spawn_distance), 0.0, self)
		enemy.set_references(player_node, enemies_manager)
		enemy.setup_stats(enemies[enemy_ID])
		
		current_enemies_nb += 1
		#print("spawning ennemies !")


func pick_enemy_type() -> int:
	var enemies_type = current_wave.enemy_data
	
	if enemies_type.size() == 0:
		return -1
	
	return enemies_type[rng.randi_range(0, enemies_type.size() - 1)]["type"]


func _on_enemy_died(_position : Vector2):
	current_enemies_nb -= 1
	#print("number of enemies: ", current_enemies_nb)


func _on_time_over():
	print("Time is over !")
	can_spawn = false


func _on_minute_passed():
	start_next_wave()
	print("Next wave !")
