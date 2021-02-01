extends Node

const FILE_GRAPH = preload("res://scenes/directory_graphs/filesystem.tscn")

export(Array, Resource) var target_file_candidates: Array
export(int) var virus_countdown_limit := 4

var nodes: Array
var player := Player.new()

var virus_countdown := virus_countdown_limit
var running_main_scene := false

var target_files_found := 0
var target_files_corrupted := 0
var secret_files_found := 0


func _ready() -> void:
	randomize()
	load_graph()
	if get_tree().current_scene.name == "MainScene" or get_tree().current_scene.name == "Screen" or get_tree().current_scene.name == "Warning":
		for node in nodes:
			for file in node.contents:
				file.subscribe(get_tree())
				
	player.connect("directory_changed", self, "_on_player_directory_changed")
	
	generate_target_files()
	
		
func generate_target_files() -> void:
	player.required_files.clear()
	var candidates := target_file_candidates.duplicate()
	for _i in range(4):
		var index := int(rand_range(0, len(candidates) - 1))
		player.required_files.push_back(candidates[index])
		candidates[index].is_target = true
		candidates.remove(index)
		
		
func cross_off_file(file_name: String) -> void:
	if get_tree().current_scene.name == "MainScene":
		get_tree().current_scene.get_node("StickyNote").cross_off_file(file_name)
		
		
func flash_screen_red() -> void:
	var screen: Screen
	if running_main_scene:
		screen = get_tree().current_scene.get_node("Viewport/Screen") as Screen
	else:
		screen = get_tree().current_scene as Screen
		
	screen.show_secret_2()
	
	screen.flash_screen_red()
		
		
func set_sticky_note_text() -> void:
	var note_string := "Find these files:\n"
	for f in player.required_files:
		note_string += "- " + f.file_name + "\n"
		
	note_string += "DO NOT TOUCH these files:\n- nbv.cfg \n- nell.pcx\n- Anything ending in .notebook\n- chcklst.txt\nDo it fast.\nG"
	
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
	
	
func add_target_file_found() -> void:
	target_files_found += 1
	if target_files_found + target_files_corrupted >= 4:
		get_tree().change_scene("res://scenes/ending_1.tscn")
		
		
func add_target_file_corrupted() -> void:
	target_files_corrupted += 1
	if get_tree().current_scene.name == "MainScene":
		if target_files_found + target_files_corrupted >= 3:
			get_tree().current_scene.get_node("Props/Computer/Light").switch_state(3)
		elif target_files_found + target_files_corrupted >= 2:
			get_tree().current_scene.get_node("Props/Computer/Light").switch_state(2)
		elif target_files_found + target_files_corrupted >= 1:
			get_tree().current_scene.get_node("Props/Computer/Light").switch_state(1)

	if target_files_found + target_files_corrupted >= 4:
		get_tree().change_scene("res://scenes/ending_1.tscn")
		
		
func add_secret_file_found() ->  void:
	secret_files_found += 1
	
	
func play_sound_oneshot(sound: AudioStream, pitch: float = 1.0, volume: float = 0.0, bus: String = "Master") -> void:
	var player_ := AudioStreamPlayer.new()
	player_.connect("finished", player_, "queue_free")
	player_.stream = sound
	player_.pitch_scale = pitch
	player_.volume_db = volume
	player_.bus = bus
	get_tree().root.add_child(player_)
	player_.play()
	
	
func trigger_secret_ending() -> void:
	var screen: Screen
	if running_main_scene:
		screen = get_tree().current_scene.get_node("Viewport/Screen") as Screen
		get_tree().current_scene.get_node("Sound/Stairs").play()
	else:
		screen = get_tree().current_scene as Screen
		
	screen.set_screen_color(Color("#ff0000"))
	screen.show_secret()
	$TimerSecret.start()
	
	
func secret_ending_2() -> void:
	var screen: Screen
	if running_main_scene:
		screen = get_tree().current_scene.get_node("Viewport/Screen") as Screen
	else:
		screen = get_tree().current_scene as Screen
		
	screen.show_secret_2()
	$TimerSecret2.start()
	
	
func secret_ending_3() -> void:
	get_tree().quit()


func _on_player_directory_changed(new_dir: DirectoryNode) -> void:
	if secret_files_found >= 5:
		trigger_secret_ending()
		
	#virus_countdown -= 1
	#if virus_countdown <= 0:
	Virus.advance_corruption()
		#virus_countdown = virus_countdown_limit

	if running_main_scene:
		(get_tree().current_scene.get_node("Viewport/Screen") as Screen).show_virus_particles(Virus.current_location == new_dir)
	else:
		(get_tree().current_scene as Screen).show_virus_particles(Virus.current_location == new_dir)
