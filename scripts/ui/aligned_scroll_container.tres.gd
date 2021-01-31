extends ScrollContainer
class_name AlignedScrollContainer


func _process(delta: float) -> void:
	scroll_horizontal = floor(scroll_horizontal / 9) * 9
	scroll_vertical = floor(scroll_vertical / 16) * 16
