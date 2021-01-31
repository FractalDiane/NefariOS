extends ScrollContainer
class_name AlignedScrollContainer


func _ready() -> void:
	var v_scroll := $_v_scroll as VScrollBar
	var h_scroll := $_h_scroll as HScrollBar
	v_scroll.step = 16
	h_scroll.step = 9
