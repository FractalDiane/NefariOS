extends Node


const TEST_GRAPH = preload("res://scenes/directory_graphs/test_graph.tscn")


class Player:
	var required_files: Array
	var required_secrets: Array
	var current_directory: DirectoryNode
	var files_found: int
	var secrets_found: int


var nodes: Array
var player := Player.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_graph()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func load_graph() -> void:
	var test_graph := TEST_GRAPH.instance() as DirectoryGraph
	test_graph.visible = false
	add_child(test_graph)
	yield(get_tree(), "idle_frame")
	nodes = test_graph.get_directories()
	print(nodes)
	test_graph.queue_free()
