extends GPUParticles2D
class_name ParticlesEffect

var particles_type : String


func _on_finished():
	print(particles_type, " over")
	PoolSystem.pool_object(particles_type, self)

func _on_draw(): 
	restart()
