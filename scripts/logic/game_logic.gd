extends Node


const TEST_GRAPH = preload("res://scenes/directory_graphs/test_graph.tscn")

export(Array, Resource) var target_file_candidates: Array


class Player:
	var required_files: Array
	var required_secrets: Array
	var current_directory: DirectoryNode
	var files_found: int
	var secrets_found: int


var nodes: Array
var player := Player.new()


func _ready() -> void:
	load_graph()


func generate_target_files() -> void:
	player.required_files.clear()
	var candidates := target_file_candidates.duplicate()
	for _i in range(4):
		var index := int(rand_range(0, len(candidates) - 1))
		player.required_files.push_back(candidates[index])
		candidates.remove(index)


func load_graph() -> void:
	var test_graph := TEST_GRAPH.instance() as DirectoryGraph
	test_graph.visible = false
	add_child(test_graph)
	yield(get_tree(), "idle_frame")
	nodes = test_graph.get_directories()
	print(nodes)
	test_graph.queue_free()
