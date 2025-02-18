extends GPUParticles2D
class_name DeathParticles

func _on_finished():
	PoolSystem.pool_object("death_particles", self)

func _on_draw():
	emitting = true
