extends WindowContainer


signal text_entered(text)


onready var line_edit := $LineEdit as LineEdit
onready var button := $Button as Button


func _ready() -> void:
	button.connect("pressed", self, "_on_button_pressed")
	connect("tree_exiting", self, "_on_button_pressed")


func _on_button_pressed() -> void:
	emit_signal("text_entered", line_edit.text)
