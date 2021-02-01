extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta: float) -> void:
	update()


func _draw() -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	mouse_pos = Vector2(clamp(floor((mouse_pos.x - 1) / 9) * 9, 0, 79 * 9), clamp(floor((mouse_pos.y - 1) / 16) * 16, 0, 24 * 16))
	draw_rect(Rect2(mouse_pos, Vector2(9, 14)), Color.white)
	#draw_rect(Rect2(Vector2(clamp(9 * floor(mouse_pos.x / 9) - 272, 0, 700), clamp(16 * floor(mouse_pos.y / 16) - 160, 0, 384)), Vector2(9, 14)), Color.white)
