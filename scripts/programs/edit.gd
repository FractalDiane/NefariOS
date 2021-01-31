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
	
	edit_scene = EDIT_SCENE.instance()
	window.add_child(edit_scene)
	
	text_edit = edit_scene.get_node("TextEdit")
	text_edit.text = file.text
