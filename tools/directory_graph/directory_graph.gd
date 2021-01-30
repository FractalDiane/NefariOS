extends GraphEdit
class_name DirectoryGraph


const GRAPH_NODE := preload("res://tools/directory_graph/directory_graph_node.tscn")

export(Array) var connections := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_valid_connection_type(0, 0)
	
	for connection in connections:
		connect_node(connection["from"], connection["from_port"], connection["to"], connection["to_port"])
	yield(get_tree(), "idle_frame")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func get_directories() -> Array:
	var dirs := {}
	for c in get_children():
		if not c is DirectoryGraphNode:
			continue
		
		var child := c as DirectoryGraphNode
		var dir := DirectoryNode.new()
		
		dir.directory_name = child.get_directory_name()
		dir.contents = child.get_files()
		dirs[child.name] = dir
	
	for connection in get_connection_list():
		var from := get_node(connection["from"]) as DirectoryGraphNode
		var to := get_node(connection["to"]) as DirectoryGraphNode
		
		var dir := dirs[from.name] as DirectoryNode
		var todir := dirs[to.name] as DirectoryNode
		
		dir.links.append(todir)
	return dirs.values()


func _on_GraphEdit_connection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_disconnection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	disconnect_node(from, from_slot, to, to_slot)


func _on_AddNode_pressed() -> void:
	var node := GRAPH_NODE.instance() as DirectoryGraphNode
	add_child(node)
	node.owner = self


func _on_Save_pressed() -> void:
	connections = get_connection_list()
	
	var popup := FileDialog.new()
	popup.resizable = true
	popup.mode = FileDialog.MODE_SAVE_FILE
	get_parent().add_child(popup)
	popup.popup_centered(Vector2(400, 400))
	var path := yield(popup, "file_selected") as String
	popup.queue_free()
	
	var scene := PackedScene.new()
	for child in get_children():
		if child is GraphNode:
			child.set_owners()
	owner = null
	scene.pack(self)
	ResourceSaver.save(path, scene)
