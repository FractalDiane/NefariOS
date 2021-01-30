extends GraphNode
class_name DirectoryGraphNode


const FILE_ENTRY := preload("res://tools/directory_graph/file_entry.tscn")

export var directory_name: String
export(Array, String) var file_paths: Array

onready var ports_begin := $PortsBegin


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LineEdit.text = directory_name
	for path in file_paths:
		_on_AddFile_pressed()
		var file = $ScrollContainer/VBoxContainer.get_child($ScrollContainer/VBoxContainer.get_child_count() - 1)
		file.get_node("LineEdit").text = path
	set_slot(0, true, 0, Color.white, false, 0, Color())


func get_directory_name() -> String:
	return $LineEdit.text


func get_files() -> Array:
	var files := Array()
	for child in $ScrollContainer/VBoxContainer.get_children():
		var path := child.get_node("LineEdit").text as String
		if len(path) > 0:
			files.append(load(path))
	return files


func set_owners() -> void:
	owner = get_parent()
	directory_name = get_directory_name()
	
	file_paths.clear()
	for child in $ScrollContainer/VBoxContainer.get_children():
		var path := child.get_node("LineEdit").text as String
		file_paths.append(path)
	
	for child in get_children():
		if child.name.begins_with("DirectoryNode"):
			child.owner = owner;


func _on_Add_pressed() -> void:
	var node := Control.new()
	node.name = "DirectoryNode"
	node.rect_min_size = Vector2(0, 20)
	add_child(node, true)
	set_slot(node.get_index(), false, 0, Color(), true, 0, Color.white)
	node.owner = get_parent()


func _on_Remove_pressed() -> void:
	var child := get_child(get_child_count() - 1)
	var graph := get_parent() as GraphEdit
	if child.name.begins_with("DirectoryNode"):
		for connection in graph.get_connection_list():
			if connection["from"] == name and connection["from_port"] == child.get_index() - (ports_begin.get_index() + 1):
				graph.disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
		clear_slot(child.get_index())
		child.queue_free()
		rect_size = Vector2()


func _on_AddFile_pressed() -> void:
	var file_entry := FILE_ENTRY.instance() as Control
	$ScrollContainer/VBoxContainer.add_child(file_entry)


func _on_GraphNode_close_request() -> void:
	var graph := get_parent() as GraphEdit
	clear_all_slots()
	for connection in graph.get_connection_list():
		if connection["from"] == name || connection["to"] == name:
			graph.disconnect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
	queue_free()
