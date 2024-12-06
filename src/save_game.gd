extends Resource
class_name SaveGame

@export var level: int

## These 2 variables save on file size, as opposed to one Array[Vector2i], NOT as a .res file
@export var x: Array[int]
@export var y: Array[int]

func save(level_: int, all_cells_: Array[Vector2i]) -> SaveGame:
	level = level_
	for i in all_cells_.size():
		x.push_back(all_cells_[i].x)
		y.push_back(all_cells_[i].y)
	return self

func to(save_path: String) -> void:
	ResourceSaver.save(self, save_path)

## an element in each array is paired via their index.
## Varying lengths of the arrays messes up everything.
func are_cells_null() -> bool:
	return x.size() != y.size()

func get_cells() -> Array[Vector2i]:
	if x.size() != y.size():
		return []
	var res: Array[Vector2i] = []
	for i in x.size():
		res.push_back(Vector2i(x[i], y[i]))
	return res;
