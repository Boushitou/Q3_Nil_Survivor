extends CollisionShape2D
class_name CollisionModifier


func update_collider(size: Vector2, sprite : AnimatedSprite2D) -> void:
	var collider_size = 1
	
	if shape is RectangleShape2D:
		shape.extents = size / 2.0
		collider_size = shape.extents * 2.0

	update_sprite(collider_size, sprite)	
		
	
func update_sprite(size: Vector2, sprite: AnimatedSprite2D) -> void:
	var texture_size : Vector2 = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame).get_size()
	
	if shape is RectangleShape2D:
		sprite.scale = size / texture_size
