extends Node
class_name EnemySpawner

@export var camera_buffer : int = 50

@export var waves : Array[WaveData] = []
#The enemy type is defined by an ID, to know the correspondance go to: Data\Enemies\ID_enemies_helper.txt
@export var enemies_data : Array[EnemyData] = []

var player_node : Node2D
var enemies_manager : EnemiesManager
var camera : Camera2D

var enemy_scene : Resource = preload("res://Scenes/enemy.tscn")

var enemy_frequency : float = 0.001
var time_since_last_spawn : float = 0.0

var enemies : Dictionary = {}
var current_wave_nb : int = -1
var current_enemies_nb : int = 0
var current_wave : WaveData
var max_wave_enemies : int = 0

var can_spawn : bool = false

var rng : RandomNumberGenerator = RandomNumberGenerator.new()
#keep track of enemies type so we don't have to spawn randomly
var enemies_killed : Dictionary = {} #string, int "type" = int
var enemies_spawned : Dictionary = {} #string, int "type" = int


func _ready() -> void:
	SignalBus.connect("time_over", _on_time_over)
	SignalBus.connect("minute_passed", _on_minute_passed)
	
	for enemy_data in enemies_data:
		enemies[enemy_data.ID] = enemy_data

	start_next_wave()


func _process(delta) -> void:
	if !can_spawn or player_node == null:
		return
		
	time_since_last_spawn += delta
	
	if time_since_last_spawn >= enemy_frequency:
		spawn_enemies()
		time_since_last_spawn = 0.0


func set_references(player : Node2D, manager: EnemiesManager) -> void:
	player_node = player
	enemies_manager = manager
	camera = enemies_manager.camera
	enemies_manager.connect("enemy_died_signal", _on_enemy_died)
	can_spawn = true
	

func start_next_wave() -> void:
	current_wave_nb += 1
	
	if current_wave_nb >= waves.size():
		return
		
	current_wave = waves[current_wave_nb]
	
	max_wave_enemies = calculate_max_enemies(current_wave)
	enemy_frequency = waves[current_wave_nb].enemy_frequency
	time_since_last_spawn = enemy_frequency
	
	#reset enemies spawned and killed to let the new enemies type to be spawned
	enemies_spawned.clear()
	enemies_killed.clear()
	for enemy_type in current_wave.enemy_data:
		enemies_spawned[enemy_type["type"]] = 0
		enemies_killed[enemy_type["type"]] = 0
	

func calculate_max_enemies(wave_data : WaveData) -> int:
	var max_enemies = 0
	
	for enemy in wave_data.enemy_data:
		max_enemies += enemy["count"]
		
	return max_enemies


func spawn_enemies() -> void:
	if current_enemies_nb >= max_wave_enemies:
		#print("can't spawn more enemies !")
		return
	if camera == null:
		return
	
	var spawn_distance : float = camera.get_spawn_distance(camera_buffer)
	var enemies_to_spawn : int = max_wave_enemies - current_enemies_nb
	
	for i in enemies_to_spawn:
		var enemy_ID : int = pick_enemy_type()
		if enemy_ID == -1:
			return #fail safe
			
		var enemy : Enemy = PoolSystem.instantiate_object("enemy", enemy_scene, camera.get_spawn_position(spawn_distance), 0.0, self)
		enemy.set_references(player_node, enemies_manager)
		enemy.setup_stats(enemies[enemy_ID])
		enemies_spawned[enemy_ID] += 1
		
		current_enemies_nb += 1
		#print("spawning ennemies !")


func pick_enemy_type() -> int:
	var enemies_type : Array[Dictionary] = current_wave.enemy_data
	var enemy_ID : int = -1
	
	if enemies_type.size() == 0:
		return enemy_ID
	
	for enemy in enemies_type:
		if enemies_spawned[enemy["type"]] < enemy["count"]:
			return enemy["type"]
	
	for dead_enemy : int in enemies_killed.keys():
		if enemies_killed[dead_enemy] > 0:
			enemies_killed[dead_enemy] -= 1
			return dead_enemy	
	return enemy_ID	


func _on_enemy_died(_position : Vector2, enemy_type : int) -> void:
	current_enemies_nb -= 1
	if enemies_killed.has(enemy_type):
		enemies_killed[enemy_type] += 1
	#print("number of enemies: ", current_enemies_nb)


func _on_time_over() -> void:
	print("Time is over !")
	can_spawn = false


func _on_minute_passed() -> void:
	start_next_wave()
	print("Next wave !")
