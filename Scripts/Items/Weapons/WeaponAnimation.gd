extends AnimatedSprite2D
class_name WeaponAnimation

@export var weapon_timer : WeaponTimer


func calculate_animation_speed() -> void:
	var duration : float = weapon_timer.wait_time
	var frames : int = sprite_frames.get_frame_count("attack")
	
	if duration > 0:
		var speed = frames / duration
		sprite_frames.set_animation_speed("attack", speed)
		

func _on_kopesh_draw():
	calculate_animation_speed() 
	play("attack")
