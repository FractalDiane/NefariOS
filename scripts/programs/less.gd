extends Program

var window: Panel
var scroll_container: ScrollContainer
var label: Label
var text_file: NOSTextFile

func _exec(args: Array) -> void:
	text_file = args[0]
	window = open_window(Rect2(Vector2(9 * 4, 16 * 4), Vector2(9 * 60, 16 * 17)), text_file.file_name)
	window.connect("tree_exiting", self, "queue_free")
	
	scroll_container = AlignedScrollContainer.new()
	window.add_child(scroll_container)
	scroll_container.anchor_right = Control.ANCHOR_END
	scroll_container.anchor_bottom = Control.ANCHOR_END
	scroll_container.margin_right = 0
	scroll_container.margin_bottom = 0
	scroll_container.scroll_horizontal_enabled = true
	
	label = Label.new()
	scroll_container.add_child(label)
	label.text = text_file.text
	label.add_constant_override("line_spacing", 0)
