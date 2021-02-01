extends Resource
class_name NOSFile

signal name_updated(file)

export(String) var file_name
export(bool) var can_be_corrupted := true
export(bool) var is_secret := false

var is_target := false
var transferred := false
var is_corrupted := false
var secret_opened := false

var frame_counter := 0


func get_file_extension() -> String:
	return ""
	
	
func subscribe(tree: SceneTree) -> void:
	tree.connect("idle_frame", self, "scramble_name", [], CONNECT_REFERENCE_COUNTED)


func scramble_name() -> void:
	frame_counter += 1
	if is_corrupted and frame_counter % 6 == 0:
		for i in range(len(file_name)):
			file_name[i] = char(int(rand_range(33, 126)))
			
		emit_signal("name_updated", self)
		
