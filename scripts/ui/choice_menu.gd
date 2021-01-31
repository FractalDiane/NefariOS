extends VBoxContainer


signal choice(choice)


func _init(choices: Array) -> void:
	add_constant_override("separation", 0)
	
	var i = 0
	for choice in choices:
		var button := FileButton.new()
		button.text = choice
		add_child(button)
		button.connect("pressed", self, "_on_chosen", [i])
		i += 1


func _on_chosen(choice: int) -> void:
	emit_signal("choice", choice)
