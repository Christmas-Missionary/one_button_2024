extends GPUParticles2D
class_name PlayerParticles

## Used to pipeline spawning of a PlayerParticles
func as_child_to(parent: Node) -> PlayerParticles:
	parent.add_child(self)
	return self

func spawn(trans: Transform2D) -> void:
	transform = trans
	emitting = true
