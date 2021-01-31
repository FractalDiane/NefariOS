extends Reference
class_name Player

signal directory_changed(new_dir)

var required_files: Array
var required_secrets: Array
var current_directory: DirectoryNode setget set_current_directory
var files_found: int
var secrets_found: int


func set_current_directory(value: DirectoryNode) -> void:
	current_directory = value
	emit_signal("directory_changed", current_directory)
