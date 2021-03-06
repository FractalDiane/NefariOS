extends Program


const TEXT_POPUP := preload("res://scripts/ui/text_popup.tscn")
const OPTIONS_MENU := preload("res://scripts/ui/options.tscn")
const SCRIPT_TEMPLATE := """extends Program
func _exec(args: Array) -> void:
	%s
"""

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
	directory_list.margin_left = 9
	directory_list.add_constant_override("separation", 0)
	
	var option_button := FileButton.new()
	window.add_child(option_button)
	option_button.text = "OPTIONS"
	option_button.set_anchors_and_margins_preset(Control.PRESET_BOTTOM_RIGHT)
	option_button.connect("pressed", self, "_on_options_button_pressed")
	
	player = args[0]
	display_directory(player.current_directory)
	
	for file in previous_directory.contents:
		if file.file_name.to_lower() == "tutorial.txt":
			default_open_file(file)
	for file in previous_directory.contents:
		if file.file_name.to_lower() == "hey_read_this.txt":
			default_open_file(file)


func _on_options_button_pressed() -> void:
	var menu := OPTIONS_MENU.instance()
	var new_win := open_window(Rect2(Vector2(9*4,16*4), menu.rect_size), "OPTIONS")
	new_win.add_child(menu)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var b := event as InputEventMouseButton
		if b.button_index == BUTTON_RIGHT and b.is_pressed():
			if moused_over_file != null:
				open_file_right_click_menu(moused_over_file, moused_over_button)
			elif moused_over_dir != null:
				pass
			else:
				empty_right_click_menu()


func empty_right_click_menu() -> void:
	var choices = ["NEW FILE"]
	var menu := open_choice_menu(get_viewport().get_mouse_position(), choices)
	match yield(menu, "choice"):
		"NEW FILE":
			var file := NOSTextFile.new()
			file.file_name = "NEW_FILE.TXT"
			previous_directory.contents.append(file)
			display_directory(previous_directory)


func open_file_right_click_menu(file: NOSFile, button: Button) -> void:
	var choices := []
	if file.is_target and not file.transferred and not file.is_corrupted:
		choices += ["TRANSFER"]
	if file is NOSTextFile and not file.is_corrupted:
		choices += ["EDIT"]
	if file is NOSTextFile and file.file_name.to_lower().ends_with(".gd") and not file.is_corrupted:
		choices += ["RUN"]
	if not file.is_corrupted:
		choices += ["RENAME"]
	if len(choices) == 0:
		return
		
	var menu := open_choice_menu(get_viewport().get_mouse_position(), choices)
	match yield(menu, "choice"):
		"TRANSFER":
			file.transferred = true
			GameLogic.add_target_file_found()
			GameLogic.cross_off_file(file.file_name)
			GlobalSignals.emit_signal("play_file_sound")
		"EDIT":
			exec("edit", [file])
			if file.is_secret and not file.opened:
				GameLogic.add_secret_file_found()
				GameLogic.flash_screen_red()
				file.opened = true
			else:
				file.opened = true
		"RENAME":
			var popup := TEXT_POPUP.instance()
			get_parent().add_child(popup)
			popup.rect_position = ScreenHelper.align_and_clamp(popup.rect_position)
			popup.get_node("LineEdit").text = file.file_name
			file.file_name = yield(popup, "text_entered")
			button.text = file.file_name.to_upper()
			popup.queue_free()
		"RUN":
			var source := (file as NOSTextFile).text
			var split := source.split("\n")
			source = SCRIPT_TEMPLATE % split.join("\n\t")
			var script := GDScript.new()
			script.source_code = source
			if (script.reload() != OK):
				return
			var node := Node.new()
			node.set_script(script)
			get_parent().add_child(node)
			node.call("_exec", [])
			


func sort(a: NOSFile, b: NOSFile) -> bool:
	return a.file_name < b.file_name

func sort_dirs(a: DirectoryNode, b: DirectoryNode) -> bool:
	return a.directory_name < b.directory_name

func display_directory(dir: DirectoryNode) -> void:
	if previous_directory != null:
		for f in previous_directory.contents:
			if f.is_connected("name_updated", self, "_on_file_name_updated"):
				f.disconnect("name_updated", self, "_on_file_name_updated")
			
	for child in directory_list.get_children():
		child.queue_free()
	
	window.get_child(0).text = dir.directory_name
	
	dir.links.sort_custom(self, "sort_dirs")
	
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
