extends Node

const FILE_GRAPH = preload("res://scenes/directory_graphs/filesystem.tscn")

export(Array, Resource) var target_file_candidates: Array
export(int) var virus_countdown_limit := 4

var nodes: Array
var player := Player.new()

var virus_countdown := virus_countdown_limit
var running_main_scene := false


func _ready() -> void:
	randomize()
	load_graph()
	for node in nodes:
		for file in node.contents:
			file.subscribe(get_tree())
	player.connect("directory_changed", self, "_on_player_directory_changed")
	
	generate_target_files()
	call_deferred("set_sticky_note_text")
	
		
func generate_target_files() -> void:
	player.required_files.clear()
	var candidates := target_file_candidates.duplicate()
	for _i in range(4):
		var index := int(rand_range(0, len(candidates) - 1))
		player.required_files.push_back(candidates[index])
		candidates.remove(index)
		
		
func set_sticky_note_text() -> void:
	var note_string := "Find these files:\n"
	for f in player.required_files:
		note_string += "- " + f.file_name + "\n"
		
	note_string += "DO NOT TOUCH these files:\n- secret file 1\n- secret file 2\n- secret file 3\n\nDo it fast.\n- G"
	
	if get_tree().current_scene.name == "MainScene":
		get_tree().current_scene.get_node("StickyNote").set_note_text(note_string)


func load_graph() -> void:
	var graph := FILE_GRAPH.instance() as DirectoryGraph
	graph.visible = false
	add_child(graph)
	#yield(get_tree(), "idle_frame")
	nodes = graph.get_directories()
	graph.queue_free()
	
	var file_count := 0
	
	for node in nodes:
		file_count += len(node.contents)
		
	Virus.total_files = file_count
			
	for node in nodes:
		if node.directory_name == "ROOT":
			player.current_directory = node
			break
	
	
func play_sound_oneshot(sound: AudioStream, pitch: float = 1.0, volume: float = 0.0, bus: String = "Master") -> void:
	var player := AudioStreamPlayer.new()
	player.connect("finished", player, "queue_free")
	player.stream = sound
	player.pitch_scale = pitch
	player.volume_db = volume
	player.bus = bus
	get_tree().root.add_child(player)
	player.play()


func _on_player_directory_changed(new_dir: DirectoryNode) -> void:
	virus_countdown -= 1
	if virus_countdown <= 0:
		Virus.advance_corruption()
		virus_countdown = virus_countdown_limit

	if running_main_scene:
		(get_tree().current_scene.get_node("Viewport/Screen") as Screen).show_virus_particles(Virus.current_location == new_dir)
	else:
		(get_tree().current_scene as Screen).show_virus_particles(Virus.current_location == new_dir)
