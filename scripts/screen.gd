class_name Screen
extends Control

onready var text := $Text as RichTextLabel
onready var image := $Image as TextureRect


func set_screen_text(text_: String) -> void:
	text.set_text(text_)
	text.show()
	image.hide()
