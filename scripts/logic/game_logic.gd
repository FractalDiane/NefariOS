extends Node


export(Array, Resource) var target_file_candidates: Array
export(int) var virus_countdown_limit := 4
const TEST_GRAPH = preload("res://scenes/directory_graphs/filesystem.tscn")


var nodes: Array
var player := Player.new()

var virus_countdown := virus_countdown_limit


func _ready() -> void:
	randomize()
	load_graph()
	player.connect("directory_changed", self, "_on_player_directory_changed")


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
	#yield(get_tree(), "idle_frame")
	nodes = test_graph.get_directories()
	print(nodes)
	test_graph.queue_free()
	
	for node in nodes:
		if node.directory_name == "ROOT":
			player.current_directory = node
			break
	print(player.current_directory)


func _on_player_directory_changed(new_dir: DirectoryNode) -> void:
	virus_countdown -= 1
	if virus_countdown <= 0:
		Virus.advance_corruption()
		virus_countdown = virus_countdown_limit

	(get_tree().current_scene.get_node("Viewport/Screen") as Screen).show_virus_particles(Virus.current_location == new_dir)
