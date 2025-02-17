extends Node
class_name EnemiesManager

var player_node : Node2D
var spawner : EnemySpawner
var camera : Camera2D

var enemy_grid : Dictionary = {}

signal enemy_died_signal(position : Vector2, enemy_ID : int)

func _ready() -> void:
	player_node = $"../Player/Body"
	spawner = $EnemySpawner
	camera = player_node.get_viewport().get_camera_2d()
	spawner.set_references(player_node, self)
	
	
func _process(_delta) -> void:
	if player_node != null:
		respawn_enemies()


func update_enemy_position(enemy: Node, old_cell: Vector2, new_cell: Vector2) -> void:
	var old_cell_enemies : Array = enemy_grid.get(old_cell, [])
	old_cell_enemies.erase(enemy)
	
	var new_cell_enemies : Array = enemy_grid.get(new_cell, [])
	new_cell_enemies.append(enemy)
	enemy_grid[new_cell] = new_cell_enemies


func get_enemies_in_cell(cell: Vector2) -> Array:
	return enemy_grid.get(cell, [])


func get_nearby_enemies(cell: Vector2) -> Array:
	var nearby_enemies = []
	
	for dx in [-1, 0, 1]:
		for dy in [-1, 0, 1]:
			var neighbor_cell = cell + Vector2(dx, dy)
			nearby_enemies += get_enemies_in_cell(neighbor_cell)
			
	return nearby_enemies


func remove_enemy(enemy: Node2D, cell: Vector2) -> void:
	var cell_enemies : Array = enemy_grid.get(cell, [])
	var enemy_pos : Vector2 = enemy.global_position
	cell_enemies.erase(enemy)
	enemy_grid[cell] = cell_enemies
	enemy_died_signal.emit(enemy_pos, enemy.data.ID)
	PoolSystem.pool_object("enemy", enemy)


func get_enemy_count() -> int:
	var count : int = 0
	
	for cell_enemies in enemy_grid.values():
		count += cell_enemies.size()
	
	return count

#when enemies get too far from the player they are teleported in a same way they are spawned
func respawn_enemies() -> void:
	for cells in enemy_grid.values():
		for enemy : Node in cells:
			var distance_to_player : float = enemy.global_position.distance_squared_to(player_node.global_position)
			var distance_respawn : float = camera.get_spawn_distance(50)
			
			if distance_to_player > distance_respawn * distance_respawn + 300:
				var new_pos : Vector2 = camera.get_spawn_position(distance_respawn)
				enemy.global_position = new_pos
				#print("enemy has be rellocated !")
