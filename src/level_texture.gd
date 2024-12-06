extends TextureRect

@onready var _rect: = $Rect as ColorRect

## Shows the amount of balls equal to the level
## (level 7 -> shows 7 balls)
## Goes to next column every 50 levels
func _adjust_balls(level_val: int) -> void:
	var lev_minus_one: int = level_val - 1
	var fifties: int = floori(lev_minus_one / 50.0)
	_rect.size.y = (((lev_minus_one % 50) + 1) * -100) + 5000
	position.x = 1187 - (fifties * 13)
	size.x = (fifties * 100) + 100
