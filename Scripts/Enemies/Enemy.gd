extends Area2D
class_name Enemy

var enemies_manager : EnemiesManager

var player_node : Node2D
var separation_radius : float
var separation_force : Vector2 = Vector2.ZERO
var data : EnemyData

@export var separation_weight : float
@export var stats : Stats

@export var collider : CollisionShape2D
@export var sprite : Sprite2D

var grid_size = 50
var last_cell : Vector2 = Vector2(-1, 1)

var update_frequency = 0.1 #10fps
var time_since_last_update = 0.0


func _process(delta):
	if !enemies_manager || player_node == null:
		return
	
	update_grid_position()
	follow_player(delta)


func set_references(player : Node2D, manager: EnemiesManager):
	player_node = player
	enemies_manager = manager
	
	
func setup_stats(enemy_stat : EnemyData):
	stats.health.total_health = enemy_stat.max_health
	stats.health.init_health()
	stats.power = enemy_stat.power
	stats.speed = enemy_stat.speed
	sprite.texture = enemy_stat.sprite
	data = enemy_stat
	
	stats.health.connect("has_died", _on_enemy_died)
	
	if not is_in_group("enemies"):
		var old_group = get_groups()
		for group in old_group:
			remove_from_group(group)
		add_to_group("enemies")
		
	set_collider_bounds()
	set_separation_radius()
	set_collision_layer_value(2, true)


func follow_player(delta):
	var direction = (player_node.global_position - global_position).normalized()
	
	time_since_last_update += delta

	if time_since_last_update >= update_frequency:
		var neighbors_positions = get_neighbors_positions()
		separation_force = get_separation_force(global_position, neighbors_positions)
		time_since_last_update = 0.0
	
	var movement = (direction + separation_force * separation_weight).normalized()
	
	position += (stats.speed * delta) * movement


#make enemies avoid each other
func get_separation_force(current_position : Vector2, neighbor_positions : Array) -> Vector2:
	var force = Vector2.ZERO
	
	for neighbor_position in neighbor_positions:
		var distance = current_position.distance_squared_to(neighbor_position)
		if distance < separation_radius * separation_radius:
			var push_direction = (current_position - neighbor_position).normalized()
			
			if push_direction.length() == 0:
				push_direction = Vector2(randf() - 0.5, randf() - 0.5).normalized()
			else:
				force += push_direction / sqrt(distance)
	
	return force


func set_collider_bounds():
	if !sprite or !collider:
		return
		
	collider.set_shape(RectangleShape2D.new())
	var texture_size = sprite.texture.get_size() * sprite.scale
	var shape = collider.get_shape()
	
	if shape is CircleShape2D:
		var circle_shape = shape as CircleShape2D
		circle_shape.radius = max(texture_size.x, texture_size.y) * 0.5
	elif shape is RectangleShape2D:
		var rect_shape = shape as RectangleShape2D
		rect_shape.size = texture_size
	else:
		print("Set a circle or rectangle shape for the enemy !")

		
func set_separation_radius():
	if !collider:
		return
	
	var shape = collider.get_shape()
	
	if shape is CircleShape2D:
		var circle_shape = shape as CircleShape2D
		separation_radius = circle_shape.radius * 2
	elif shape is RectangleShape2D:
		var rect_shape = shape as RectangleShape2D
		separation_radius = sqrt(pow(rect_shape.extents.x * 2, 2) + pow(rect_shape.extents.y * 2, 2))
	else:
		print("Set a circle or rectangle shape for the enemy !")
		
		
func update_grid_position():
	var current_cell = Vector2(int(global_position.x / grid_size), int(global_position.y / grid_size))
	
	if current_cell != last_cell:
		if last_cell != Vector2(-1 , -1): #skip first update
			enemies_manager.update_enemy_position(self, last_cell, current_cell)
		
		last_cell = current_cell


func get_neighbors_positions() -> Array:
	var neighbors = enemies_manager.get_nearby_enemies(last_cell)
	var neighbor_position = []
	for neighbor in neighbors:
		if is_instance_valid(neighbor):
			neighbor_position.append(neighbor.global_position)
		
	return neighbor_position


func take_damage(amount : int):
	stats.health.take_damage(amount)


func get_damage():
	return stats.power
	

func _on_enemy_died():
	stats.health.disconnect("has_died", _on_enemy_died)
	enemies_manager.remove_enemy(self, last_cell)
