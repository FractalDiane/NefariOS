extends Panel
class_name WindowContainer

enum BorderDrag {
	LEFT = 1
	BOTTOM = 2
	RIGHT = 4
}

var title_label := Label.new()
var title_control := Control.new()
var border_control := Control.new()
var close_button := ToolButton.new()

var title_dragging := false
var border_dragging := false
var border_drag: int = 0

export(String) var title setget set_title
func set_title(to: String) -> void:
	title = to
	title_label.text = to

func _enter_tree() -> void:
	title_label.align = Label.ALIGN_CENTER


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(title_label)
	title_label.add_color_override("font_color", Color())
	title_label.grow_horizontal = GROW_DIRECTION_BOTH
	title_label.anchor_left     = 0.5
	title_label.anchor_right    = 0.5
	title_label.margin_left     = 0
	title_label.margin_right    = 0
	title_label.rect_size       = Vector2()
	title_label.rect_position.y = -15
	title_label.rect_position.x = floor(title_label.rect_position.x / 9) * 9
	
	add_child(title_control)
	title_control.anchor_right  = ANCHOR_END
	title_control.margin_left   = -9
	title_control.margin_top    = -14
	title_control.margin_right  = 9
	title_control.margin_bottom = 0
	title_control.connect("gui_input", self, "_title_control_gui_input")
	
	
	add_child(border_control)
	border_control.anchor_right  = ANCHOR_END
	border_control.anchor_bottom = ANCHOR_END
	border_control.margin_left   = -9
	border_control.margin_top    = 0
	border_control.margin_right  = 9
	border_control.margin_bottom = 14
	border_control.connect("gui_input", self, "_border_control_gui_input")
	
	add_child(close_button)
	close_button.text = "X"
	close_button.add_color_override("font_color", Color())
	close_button.add_color_override("font_color_hover", Color())
	close_button.add_color_override("font_color_pressed", Color())
	close_button.anchor_left   = ANCHOR_END
	close_button.anchor_right  = ANCHOR_END
	close_button.margin_left   = 0
	close_button.margin_top    = -15
	close_button.margin_right  = 9
	close_button.margin_bottom = 1
	#close_button.rect_size = Vector2(9, 16)
	close_button.connect("pressed", self, "queue_free")
	
	if Engine.editor_hint:
		set_process_input(false)
		set_process_unhandled_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _gui_input(event: InputEvent) -> void:
	pass


func _title_control_gui_input(event: InputEvent) -> void:
	#print("Title: " + str(event))
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == BUTTON_LEFT and mb.is_pressed():
			title_dragging = true


func _border_control_gui_input(event: InputEvent) -> void:
	#print("Border: " + str(event))
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == BUTTON_LEFT and mb.is_pressed():
			border_dragging = true
			var mpos = get_viewport().get_mouse_position()
			if mpos.x < rect_global_position.x:
				border_drag |= BorderDrag.LEFT
			if mpos.x > (rect_global_position.x + rect_size.x):
				border_drag |= BorderDrag.RIGHT
			if mpos.y > (rect_global_position.y + rect_size.y):
				border_drag |= BorderDrag.BOTTOM


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == BUTTON_LEFT and not mb.is_pressed():
			title_dragging = false
			border_dragging = false
			border_drag = 0
	if event is InputEventMouseMotion:
		if title_dragging:
			rect_position = get_viewport().get_mouse_position()
			rect_position.x = (floor(rect_position.x / 9) * 9) + 9
			rect_position.y = (floor(rect_position.y / 16) * 16) + 16
#		elif border_dragging:
#			if (border_drag & BorderDrag.LEFT) == BorderDrag.LEFT:
#
