extends Node

var current_location: DirectoryNode

func _ready() -> void:
	# Start at random location
	var index := int(rand_range(0, len(GameLogic.nodes) - 1))
	var start_node: DirectoryNode = GameLogic.nodes[index]
	while start_node.directory_name == "ROOT":
		index = int(rand_range(0, len(GameLogic.nodes) - 1))
		start_node = GameLogic.nodes[index]
		
	current_location = start_node


func advance_corruption() -> void:
	if not current_location.contents.empty():
		var index := int(rand_range(0, len(current_location.contents) - 1))
		(current_location.contents[index] as NOSFile).is_corrupted = true
		
	var index := int(rand_range(0, len(current_location.links) - 1))
	current_location = current_location.links[index] as DirectoryNode
