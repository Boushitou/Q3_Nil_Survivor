extends Node2D
class_name DamageDisplay

@export var damage_label : Label
@export var animation_player : AnimationPlayer

var damage_to_display : int = 0

func _ready() -> void:
	animation_player.stop()
	
	
func animate_display(damage : int) -> void :
	damage_to_display = damage
	damage_label.text = str(damage_to_display)
	animation_player.play("damage_animation")


func _on_animation_player_animation_finished(_anim_name):
	animation_player.stop()
	PoolSystem.pool_object("damage_display", self)
