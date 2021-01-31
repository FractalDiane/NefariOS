extends Label
class_name HighlightLabel


export var highlight := false setget set_highlight
func set_highlight(to: bool) -> void:
	highlight = to
	update()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _draw() -> void:
	if highlight:
		draw_rect(Rect2(rect_position, rect_size), Color.white)
		add_color_override("font_color", Color())
		notification(CanvasItem.NOTIFICATION_DRAW)
	else:
		add_color_override("font_color", Color.white)
		notification(CanvasItem.NOTIFICATION_DRAW)
