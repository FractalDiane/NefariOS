extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Load_pressed() -> void:
	var dialog := FileDialog.new()
	dialog.mode = FileDialog.MODE_OPEN_FILE
	dialog.resizable = true
	add_child(dialog)
	dialog.popup_centered(Vector2(400, 400))
	var file_path = yield(dialog, "file_selected")
	$LineEdit.text = file_path
	dialog.queue_free()
