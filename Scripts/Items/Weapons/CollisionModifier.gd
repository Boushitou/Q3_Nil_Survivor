extends CollisionShape2D
class_name CollisionModifier


func update_collider(size: Vector2, sprite : Sprite2D) -> void:
	var collider_size = 1
	
	if shape is RectangleShape2D:
		shape.extents = size / 2.0
		collider_size = shape.extents * 2.0

	update_sprite(collider_size, sprite)	
		
	
func update_sprite(size: Vector2, sprite: Sprite2D) -> void:
	var texture_size : Vector2 = sprite.texture.get_size()
	
	if shape is RectangleShape2D:
		sprite.scale = size / texture_size
