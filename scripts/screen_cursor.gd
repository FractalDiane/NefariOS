extends Control

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta: float) -> void:
	update()


func _draw() -> void:
	var mouse_pos = get_global_mouse_position()
	draw_rect(Rect2(Vector2(clamp(9 * floor(mouse_pos.x / 9) - 272, 0, 720), clamp(16 * floor(mouse_pos.y / 16) - 160, 0, 400)), Vector2(9, 14)), Color.white)
