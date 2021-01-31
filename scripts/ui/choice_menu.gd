extends PanelContainer
class_name ChoiceMenu


signal choice(choice)


func _init(choices: Array) -> void:
	var vbox := VBoxContainer.new()
	add_child(vbox)
	
	vbox.add_constant_override("separation", 0)
	
	for choice in choices:
		var button := FileButton.new()
		button.text = choice
		vbox.add_child(button)
		button.connect("pressed", self, "_on_chosen", [choice])


func _process(delta: float) -> void:
	var mpos: Vector2 = ScreenHelper.align_and_clamp(get_viewport().get_mouse_position())
	if not get_rect().grow_individual(9.1, 16.1, 9.1, 16.1).has_point(mpos):
		_on_mouse_exit()


func _on_mouse_exit() -> void:
	emit_signal("choice", "")
	queue_free()


func _on_chosen(choice: String) -> void:
	emit_signal("choice", choice)
	queue_free()
