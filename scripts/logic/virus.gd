extends Node

var current_location: DirectoryNode
var files_corrupted := 0
var total_files := 0

var seen_dirs := {}


func _ready() -> void:
	# Start at random location
	var index := int(rand_range(0, len(GameLogic.nodes)))
	var start_node: DirectoryNode = GameLogic.nodes[index]
	while start_node.directory_name == "ROOT":
		index = int(rand_range(0, len(GameLogic.nodes)))
		start_node = GameLogic.nodes[index]
		
	current_location = start_node
	add_seen_dir(current_location)


func advance_corruption() -> void:
	if current_location.contents.empty() or current_location.all_files_corrupted():
		var index := int(rand_range(0, len(current_location.links) - 1))
		current_location = current_location.links[index] as DirectoryNode
		
		if seen_dirs.get(current_location) != null and seen_dirs[current_location] > 2:
			var tele := int(rand_range(0, len(GameLogic.nodes)))
			current_location = GameLogic.nodes[tele]
			add_seen_dir(current_location)
			GlobalSignals.emit_signal("play_teleport_sound")
		else:
			add_seen_dir(current_location)
	else:
		for f in current_location.contents:
			if not f.is_corrupted:
				f.is_corrupted = true
				files_corrupted += 1
				if get_tree().current_scene.name == "MainScene":
					var ratio := float(files_corrupted) / float(total_files)
					if ratio >= 0.75:
						get_tree().current_scene.get_node("Props/Computer/Light").switch_state(3)
					elif ratio >= 0.5:
						get_tree().current_scene.get_node("Props/Computer/Light").switch_state(2)
					elif ratio >= 0.25:
						get_tree().current_scene.get_node("Props/Computer/Light").switch_state(1)
					else:
						get_tree().current_scene.get_node("Props/Computer/Light").switch_state(0)
				
				break
		

func add_seen_dir(dir: DirectoryNode) -> void:
	if dir in seen_dirs:
		seen_dirs[dir] += 1
	else:
		seen_dirs[dir] = 1
