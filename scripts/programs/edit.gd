extends Program


const EDIT_SCENE := preload("res://scripts/programs/edit.tscn")

var window: Panel
var file: NOSTextFile
var edit_scene: Control
var text_edit: TextEdit


func _exec(args: Array) -> void:
	if len(args) > 0:
		file = args[0]
	else:
		file = NOSTextFile.new()
		file.file_name = "NEW TEXT FILE"
	window = open_window(Rect2(Vector2(9*2,16*2), Vector2(9*60,16*20)), file.file_name)
	window.connect("tree_exiting", self, "queue_free")
	
	edit_scene = EDIT_SCENE.instance()
	window.add_child(edit_scene)
	
	text_edit = edit_scene.get_node("TextEdit")
	text_edit.text = file.text
	text_edit.caret_block_mode = true
	text_edit.caret_blink = true
	
	edit_scene.get_node("PanelContainer/HBoxContainer/FILE").connect("pressed", self, "_on_button_pressed")


func _on_button_pressed() -> void:
	var menu := open_choice_menu(get_viewport().get_mouse_position(), ["SAVE", "EXIT"])
	match yield(menu, "choice"):
		"SAVE":
			file.text = text_edit.text
		"EXIT":
			window.queue_free()
