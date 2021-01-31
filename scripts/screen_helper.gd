extends Node


func align_and_clamp(x: Vector2) -> Vector2:
	return Vector2(
		clamp(floor(x.x / 9) * 9, 0, 79 * 9),
		clamp(floor(x.y / 16) * 16, 0, 24 * 16)
	)
