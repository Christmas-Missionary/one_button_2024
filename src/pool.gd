extends Node2D
class_name Pool

func _queue_free_children(_val) -> void:
	for node: Node in get_children():
		node.queue_free()
