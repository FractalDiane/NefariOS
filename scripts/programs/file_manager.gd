extends Program


var window: Panel
var directory_list: VBoxContainer
var player: Player


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


func display_directory(dir: DirectoryNode) -> void:
	for child in directory_list.get_children():
		child.queue_free()
	
	for _d in dir.links:
		var d := _d as DirectoryNode
		var button := Button.new()
		button.align = Button.ALIGN_LEFT
		button.text = d.directory_name.to_upper() + " ->"
		directory_list.add_child(button)
		button.connect("pressed", self, "_on_directory_clicked", [d])
	
	for f in dir.contents:
		var button := Button.new()
		button.align = Button.ALIGN_LEFT
		button.text = f.file_name.to_upper()
		directory_list.add_child(button)
		button.connect("pressed", self, "_on_file_clicked", [f])


func _on_directory_clicked(dir: DirectoryNode) -> void:
	player.current_directory = dir
	display_directory(dir)


func _on_file_clicked(file: NOSFile) -> void:
	default_open_file(file)
