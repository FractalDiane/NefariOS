class_name Screen
extends Node


func set_screen_text(text: String) -> void:
	($Text as RichTextLabel).set_text(text)
