extends TileMap
class_name TileMapGeneration

@export var player : Node
@export var chunk_size : int = 16
@export var render_distance : int = 3

var loaded_chunks : Dictionary = {}
var player_pos : Node2D


func _ready() -> void:
	player_pos = player.get_node("Body")

	
func _process(_delta: float) -> void:
	if not player:
		return

	var player_chunk = world_to_chunk(player_pos.global_position)
	
	for x in range(-render_distance, render_distance + 1):
		for y in range(-render_distance, render_distance + 1):
			var chunk_pos = Vector2(player_chunk.x + x, player_chunk.y + y)
			if not loaded_chunks.has(chunk_pos):
				generate_new_chunk(chunk_pos)

	cleanup_chunks(player_chunk)			

func world_to_chunk(world_pos: Vector2) -> Vector2:
	return Vector2i(
		floor(world_pos.x / (chunk_size * 64)),
		floor(world_pos.y / (chunk_size * 64))
	)

	
	
func generate_new_chunk(chunk_pos: Vector2) -> void:
	loaded_chunks[chunk_pos] = true
	for x in range(chunk_size):
		for y in range(chunk_size):
			var tile_x = chunk_pos.x * chunk_size + x
			var tile_y = chunk_pos.y * chunk_size + y
			
			var rand_tile_x = randi_range(0, 1)
			var rand_tile_y = randi_range(0, 1)
			set_cell(0, Vector2i(tile_x, tile_y), 0, Vector2i(rand_tile_x, rand_tile_y))


func cleanup_chunks(player_chunk: Vector2) -> void:
	var chunk_to_remove = []
	
	for chunk_pos in loaded_chunks.keys():
		if abs(chunk_pos.x - player_chunk.x) > render_distance + 1 or abs(chunk_pos.y - player_chunk.y) > render_distance + 1:
			chunk_to_remove.append(chunk_pos)

	for chunk_pos in chunk_to_remove:
		remove_chunk(chunk_pos)

		
func remove_chunk(chunk_pos : Vector2) -> void:
	for x in range(chunk_size):
		for y in range(chunk_size):
			var tile_x = chunk_pos.x * chunk_size + x
			var tile_y = chunk_pos.y * chunk_size + y
			set_cell(0, Vector2i(tile_x, tile_y), 0)
			
	loaded_chunks.erase(chunk_pos)
