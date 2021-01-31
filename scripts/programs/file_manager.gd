extends Program


var window: Panel
var directory_list: VBoxContainer
var player: Player

var previous_directory: DirectoryNode = null
var moused_over_button: Button = null
var moused_over_file: NOSFile = null
var moused_over_dir: DirectoryNode = null


func _exec(args: Array) -> void:
	window = open_root_window("FILE MANAGER")
	
	directory_list = VBoxContainer.new()
	window.add_child(directory_list)
	directory_list.anchor_right = Control.ANCHOR_END
	directory_list.anchor_bottom = Control.ANCHOR_END
	directory_list.margin_right = 0
	directory_list.margin_bottom = 0
	directory_list.add_constant_override("separation", 0)
	
	player = args[0]
	display_directory(player.current_directory)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var b := event as InputEventMouseButton
		if b.button_index == BUTTON_RIGHT and b.is_pressed() and moused_over_button != null:
			if moused_over_file != null:
				open_file_right_click_menu(moused_over_file)


func open_file_right_click_menu(var file: NOSFile) -> void:
	var choices := []
	if file.is_target and not file.transferred:
		choices += ["TRANSFER"]
	if file is NOSTextFile:
		choices += ["EDIT"]
	if len(choices) == 0:
		return
		
	var menu := open_choice_menu(get_viewport().get_mouse_position(), choices)
	match yield(menu, "choice"):
		"TRANSFER":
			file.transferred = true
			GameLogic.add_target_file_found()
			GlobalSignals.emit_signal("play_file_sound")
		"EDIT":
			exec("edit", [file])


func sort(a: NOSFile, b: NOSFile) -> bool:
	return a.file_name < b.file_name

func display_directory(dir: DirectoryNode) -> void:
	if previous_directory != null:
		for f in previous_directory.contents:
			f.disconnect("name_updated", self, "_on_file_name_updated")
			
	for child in directory_list.get_children():
		child.queue_free()
	
	window.get_child(0).text = dir.directory_name
	
	for _d in dir.links:
		var d := _d as DirectoryNode
		var button := FileButton.new()
		button.align = Button.ALIGN_LEFT
		button.text = d.directory_name.to_upper() + " ->"
		directory_list.add_child(button)
		button.connect("pressed", self, "_on_directory_clicked", [d])
		button.connect("mouse_entered", self, "_on_button_mouse_over", [d, button])
		button.connect("mouse_exited", self, "_on_button_mouse_exit", [d, button])
	
	dir.contents.sort_custom(self, "sort")
	
	for f in dir.contents:
		var button := FileButton.new()
		button.align = Button.ALIGN_LEFT
		button.text = f.file_name.to_upper()
		directory_list.add_child(button)
		button.connect("pressed", self, "_on_file_clicked", [f])
		
		f.connect("name_updated", self, "_on_file_name_updated", [button])
		button.connect("mouse_entered", self, "_on_button_mouse_over", [f, button])
		button.connect("mouse_exited", self, "_on_button_mouse_exit", [f, button])
		
	previous_directory = dir


func _on_file_name_updated(file: NOSFile, button: Button) -> void:
	button.text = file.file_name


func _on_directory_clicked(dir: DirectoryNode) -> void:
	player.current_directory = dir
	display_directory(dir)


func _on_file_clicked(file: NOSFile) -> void:
	default_open_file(file)


func _on_button_mouse_over(file_or_dir, button: Button) -> void:
	moused_over_button = button
	if file_or_dir is NOSFile:
		moused_over_file = file_or_dir
		moused_over_dir = null
	else:
		moused_over_dir = file_or_dir
		moused_over_file = null


func _on_button_mouse_exit(file_or_dir, button: Button) -> void:
	if button == moused_over_button:
		moused_over_button = null
		moused_over_dir = null
		moused_over_file = null
